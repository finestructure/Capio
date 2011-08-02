//
//  MetricOverviewController.m
//  Capio
//
//  Created by Sven A. Schmidt on 19.07.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import "MetricOverviewController.h"
#import "DataStore.h"
#import "Constants.h"


@implementation MetricOverviewController

@synthesize data = _data;
@synthesize graph = _graph;
@synthesize detailItem = _detailItem;
@synthesize processed = _processed;

@synthesize graphView = _graphView;
@synthesize metricSwitches = _metricSwitches;
@synthesize serverName = _serverName;
@synthesize reportDate = _reportDate;


#pragma mark - Actions


- (IBAction)metricToggled:(id)sender {
  UISwitch *toggle = (UISwitch *)sender;
  if (toggle.on) {
    [self drawMetric:toggle.tag];
  } else {
    [self.graph removePlotWithIdentifier:[self metricTitle:toggle.tag]];
  }
  [self drawLegend];
}


#pragma mark - Workers


- (void)configurePlotSpace:(CPTXYPlotSpace *)plotSpace {
  plotSpace.delegate = self;
  plotSpace.allowsUserInteraction = YES;
  NSTimeInterval oneDay = 24 * 60 * 60;
  NSTimeInterval xLow = 0.0f;
  plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xLow) length:CPTDecimalFromFloat(oneDay)];
  plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(100)];
}


- (void)configureAxes:(CPTXYAxisSet *)axisSet {
  NSTimeInterval oneDay = 24 * 60 * 60;
  NSDateFormatter *dateTimeFormatter = [[NSDateFormatter alloc] init];
  [dateTimeFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
  
  CPTMutableTextStyle *axisTitleTextStyle = [CPTMutableTextStyle textStyle];
	axisTitleTextStyle.fontName = @"Helvetica-Bold";
	axisTitleTextStyle.fontSize = 14.0;
  
  {
    CPTXYAxis *x = axisSet.xAxis;
    x.majorIntervalLength = CPTDecimalFromInt(oneDay);
    x.minorTicksPerInterval = 12;
    x.labelRotation = 0.7;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM-dd HH:mm";
    CPTTimeFormatter *timeFormatter = [[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter];
    
    NSString *asof = [self.detailItem objectForKey:@"asof"];
    NSDate *refDate = [[YmdDateFormatter sharedInstance] dateFromString:asof];
    timeFormatter.referenceDate = refDate;
    x.labelFormatter = timeFormatter;
    
    x.isFloatingAxis = YES;
    x.constraints = CPTMakeConstraints(CPTConstraintFixed,
                                       CPTConstraintFixed);
    
    x.titleTextStyle = axisTitleTextStyle;
    x.titleOffset = 45.0;
    x.title = NSLocalizedString(@"Date", @"Utilization graph x axis label");
  }
  {
    CPTXYAxis *y = axisSet.yAxis;
    y.majorIntervalLength = CPTDecimalFromInt(10);
    y.minorTicksPerInterval = 1;
    y.isFloatingAxis = YES;
    y.constraints = CPTMakeConstraints(CPTConstraintFixed,
                                       CPTConstraintFixed);
    
    y.titleTextStyle = axisTitleTextStyle;
    y.titleOffset = 35.0;
    y.title = NSLocalizedString(@"Utilization", @"Utilization graph y axis label");
  }
}


- (void)addAnimationToPlot:(CPTPlot *)plot {
	plot.opacity = 0.0f;
	plot.cachePrecision = CPTPlotCachePrecisionDecimal;
	
	CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeInAnimation.duration = 0.2f;
	fadeInAnimation.removedOnCompletion = NO;
	fadeInAnimation.fillMode = kCAFillModeForwards;
	fadeInAnimation.toValue = [NSNumber numberWithFloat:1.0];
	[plot addAnimation:fadeInAnimation forKey:@"animateOpacity"];
}


- (void)configurePlot:(CPTScatterPlot *)plot withTitle:(NSString *)title color:(CPTColor *)color addAnimation:(BOOL)animated {
  plot.dataSource = self;
  plot.identifier = title;
  
  // Line style
  CPTMutableLineStyle *lineStyle = [plot.dataLineStyle mutableCopy];
	lineStyle.lineWidth = 2.f;
  lineStyle.lineColor = color;
  plot.dataLineStyle = lineStyle;
	
  plot.areaBaseValue = [[NSDecimalNumber zero] decimalValue];
  
  if (animated) {
    [self addAnimationToPlot:plot];
  }
}


- (void)configureGraph:(CPTXYGraph *)graph {
	CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
  [graph applyTheme:theme];
  
  graph.paddingLeft = 0.0;
  graph.paddingTop = 0.0;
  graph.paddingRight = 0.0;
  graph.paddingBottom = 0.0;
  
  graph.plotAreaFrame.paddingTop = 20.0;
  graph.plotAreaFrame.paddingBottom = 70.0;
  graph.plotAreaFrame.paddingLeft = 65.0;
  graph.plotAreaFrame.paddingRight = 20.0;
}


- (void)drawLegend {
  CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
  CPTXYAxis *x = axisSet.xAxis;
  
  CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
	textStyle.fontName = @"Helvetica";
	textStyle.fontSize = 12.0;
  
  self.graph.legend = [CPTLegend legendWithGraph:self.graph];
	self.graph.legend.textStyle = textStyle;
	self.graph.legend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
	self.graph.legend.borderLineStyle = x.axisLineStyle;
	self.graph.legendAnchor = CPTRectAnchorTop;
	self.graph.legendDisplacement = CGPointMake(0, -10.0);
}


- (void)plotData:(NSArray *)data withTitle:(NSString *)title color:(CPTColor *)color animated:(BOOL)animated {
  CPTScatterPlot *plot = [[CPTScatterPlot alloc] init];
  [self configurePlot:plot withTitle:title color:color addAnimation:animated];
  [self.data setObject:data forKey:plot.identifier];
  [self.graph addPlot:plot];
}


- (CPTColor *)colorWithRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue {
  return [CPTColor colorWithComponentRed:red/255. green:green/255. blue:blue/255. alpha:1.0];
}


- (NSString *)metricTitle:(NSUInteger)index {
  static NSArray *titles = nil;
  if (titles == nil) {
    titles = [NSArray arrayWithObjects:
              @"cpu",
              @"cpu top 10 images",
              @"cpu top 10 users",
              @"cpu workload",
              @"mem",
              @"mem alloc",
              @"mem faultrate",
              @"mem faults io",
              @"net sent",
              @"net received",
              @"net closed",
              @"net ip packet rate",
              nil];
  }
  return [titles objectAtIndex:index];
}


- (NSArray *)makePalette:(NSUInteger)count {
  NSMutableArray *colors = [NSMutableArray arrayWithCapacity:count];
  for (NSUInteger i = 0; i < count; ++i) {
    UIColor *color = [UIColor colorWithHue:((float)i)/count saturation:1 brightness:0.8 alpha:1];
    [colors addObject:[CPTColor colorWithCGColor:color.CGColor]];
  }
  return colors;
}


- (CPTColor *)metricColor:(NSUInteger)index {
  static NSArray *colors = nil;
  if (colors == nil) {
    colors = [self makePalette:20];
  }
  return [colors objectAtIndex:index];
}


- (void)drawMetric:(NSUInteger)index {
  NSString *title = [self metricTitle:index];
  CPTColor *color = [self metricColor:index];
  
  NSString *docKey = [self.processed objectForKey:title];
  NSAssert(docKey != nil, @"doc key must not be nil");
  
  [[DataStore sharedDataStore] fetchDocument:docKey withCompletionBlock:^(NSDictionary *doc) {
    NSArray *data = [doc objectForKey:@"values"];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
      if (data != nil) {
        [self plotData:data withTitle:title color:color animated:NO];
      }
    }];
  }];
}


- (void)createGraph {
  CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
  self.graph = graph;
  self.graphView.hostedGraph = graph;
	
  [self configureGraph:graph];
  
  [self configurePlotSpace:(CPTXYPlotSpace *)graph.defaultPlotSpace];
	
  [self configureAxes:(CPTXYAxisSet *)graph.axisSet];
	
  // check list of available metrics against supported one (from metricTitle),
  // deactivate the toggles for the ones not procssed and draw the first available one
  BOOL oneActive = NO;
  for (UISwitch *toggle in self.metricSwitches) {
    NSString *title = [self metricTitle:toggle.tag];
    if ([self.processed objectForKey:title] == nil) {
      toggle.on = NO;
      toggle.enabled = NO;
    } else {
      toggle.enabled = YES;
      if (! oneActive) {
        oneActive = YES;
        toggle.on = YES;
        [self drawMetric:toggle.tag];
      } else {
        toggle.on = NO;
      }
    }
  }
  
  [self drawLegend];
}


#pragma mark - CPPlotDataSource


-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
  NSArray *data = [self.data objectForKey:plot.identifier];
  return [data count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index  {
  NSArray *data = [self.data objectForKey:plot.identifier];  
  NSArray *v = [data objectAtIndex:index];
  if (fieldEnum == CPTCoordinateX) {
    NSArray *firstPair = [data objectAtIndex:0];
    NSNumber *xOffset = [firstPair objectAtIndex:0];

    NSNumber *value = [v objectAtIndex:0];
    NSNumber *num = [NSNumber numberWithFloat:[value unsignedIntValue] - [xOffset unsignedIntValue]];
    return num;
  } else {
    NSNumber *value = [v objectAtIndex:1];
    NSNumber *num = [NSNumber numberWithFloat:[value floatValue]];
    return num;
  }
}


#pragma mark - Plot Space Delegate Methods

-(CPTPlotRange *)plotSpace:(CPTPlotSpace *)space willChangePlotRangeTo:(CPTPlotRange *)newRange forCoordinate:(CPTCoordinate)coordinate {
  if (coordinate == CPTCoordinateY) {
    CPTPlotRange *maxRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromInt(15)];
    CPTPlotRange *changedRange = [newRange copy];
    [changedRange shiftEndToFitInRange:maxRange];
    [changedRange shiftLocationToFitInRange:maxRange];
    newRange = changedRange;
  }
  return newRange;
}


- (BOOL)plotSpace:(CPTPlotSpace *)space shouldScaleBy:(CGFloat)interactionScale aboutPoint:(CGPoint)interactionPoint {
  return NO;
}


#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = NSLocalizedString(@"Metrics Overview", @"Metrics Overview Title");
  }
  return self;
}


- (void)didReceiveMemoryWarning{
  [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle


- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSAssert([[self.detailItem objectForKey:@"type"] isEqualToString:@"server"], @"must be a server type document");
  self.processed = [self.detailItem objectForKey:@"processed"];
  
  self.serverName.text = [self.detailItem objectForKey:@"hostname"];
  self.reportDate.text = [self.detailItem objectForKey:@"asof"];
  
  self.data = [NSMutableDictionary dictionary];
  [self createGraph];
}


- (void)viewDidUnload {
  self.data = nil;
  self.graph = nil;
  self.detailItem = nil;
  self.processed = nil;
  
  [self setGraphView:nil];
  [self setMetricSwitches:nil];
  [self setServerName:nil];
  [self setReportDate:nil];
  [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


@end
