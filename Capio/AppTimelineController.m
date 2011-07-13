//
//  AppTimelineController.m
//  Capio
//
//  Created by Sven A. Schmidt on 07.07.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import "AppTimelineController.h"
#import "DataStore.h"
#import "Tuple.h"


@implementation AppTimelineController

@synthesize data = _data;
@synthesize graphView = _graphView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = @"Application Timeline";
  }
  return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - Workers


- (void)configurePlotSpace:(CPTXYPlotSpace *)plotSpace {
  plotSpace.delegate = self;
  plotSpace.allowsUserInteraction = YES;
  NSTimeInterval oneDay = 24 * 60 * 60;
  NSTimeInterval xLow = 0.0f;
  plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xLow) length:CPTDecimalFromFloat(oneDay*10)];
  plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(15)];
}


- (void)configureAxes:(CPTXYAxisSet *)axisSet {
  NSTimeInterval oneDay = 24 * 60 * 60;
  NSDateFormatter *dateTimeFormatter = [[NSDateFormatter alloc] init];
  [dateTimeFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
  
  CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
  gridLineStyle.lineWidth = 0.75;
  gridLineStyle.dashPattern = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:2.0f],
                               [NSNumber numberWithFloat:5.0f],
                               nil];

  CPTMutableTextStyle *axisTitleTextStyle = [CPTMutableTextStyle textStyle];
	axisTitleTextStyle.fontName = @"Helvetica-Bold";
	axisTitleTextStyle.fontSize = 14.0;

  {
    CPTXYAxis *x = axisSet.xAxis;
    x.majorIntervalLength = CPTDecimalFromInt(oneDay);
    x.minorTicksPerInterval = 1;
    x.labelRotation = 0.7;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM-dd";
    CPTTimeFormatter *timeFormatter = [[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter];
    
    NSDate *refDate = [dateTimeFormatter dateFromString:@"2011-06-01 12:00"];
    timeFormatter.referenceDate = refDate;
    x.labelFormatter = timeFormatter;

    x.isFloatingAxis = YES;
    x.constraints = CPTMakeConstraints(CPTConstraintFixed,
                                       CPTConstraintFixed);
    
    x.majorGridLineStyle = gridLineStyle;
    x.titleTextStyle = axisTitleTextStyle;
    x.titleOffset = 45.0;
    x.title = @"Date";
  }
  {
    CPTXYAxis *y = axisSet.yAxis;
    y.majorIntervalLength = CPTDecimalFromInt(1);
    y.minorTicksPerInterval = 2;
    y.isFloatingAxis = YES;
    y.constraints = CPTMakeConstraints(CPTConstraintFixed,
                                       CPTConstraintFixed);

    y.majorGridLineStyle = gridLineStyle;
    y.titleTextStyle = axisTitleTextStyle;
    y.titleOffset = 35.0;
    y.title = @"Exceptions";
  }
}


- (void)addAnimationToPlot:(CPTPlot *)plot {
	plot.opacity = 0.0f;
	plot.cachePrecision = CPTPlotCachePrecisionDecimal;
	
	CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeInAnimation.duration = 1.0f;
	fadeInAnimation.removedOnCompletion = NO;
	fadeInAnimation.fillMode = kCAFillModeForwards;
	fadeInAnimation.toValue = [NSNumber numberWithFloat:1.0];
	[plot addAnimation:fadeInAnimation forKey:@"animateOpacity"];
}


- (void)configurePlot:(CPTScatterPlot *)plot withTitle:(NSString *)title color:(CPTColor *)color {
  plot.dataSource = self;
  plot.identifier = title;

  // Line style
  CPTMutableLineStyle *lineStyle = [plot.dataLineStyle mutableCopy];
	lineStyle.lineWidth = 3.f;
  lineStyle.lineColor = color;
  plot.dataLineStyle = lineStyle;
	
  // Fill style
  CPTGradient *gradient = [CPTGradient gradientWithBeginningColor:color endingColor:[CPTColor whiteColor]];
  gradient.angle = -90.0f;
  CPTFill *areaGradientFill = [CPTFill fillWithGradient:gradient];
  plot.areaFill = areaGradientFill;
  plot.areaBaseValue = [[NSDecimalNumber zero] decimalValue];

  [self addAnimationToPlot:plot];
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
  graph.plotAreaFrame.cornerRadius = 5.0;
}


- (void)addLegend:(CPTXYGraph *)graph {
  CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
  CPTXYAxis *x = axisSet.xAxis;
  
  CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
	textStyle.fontName = @"Helvetica";
	textStyle.fontSize = 12.0;

  graph.legend = [CPTLegend legendWithGraph:graph];
	graph.legend.textStyle = textStyle;
	graph.legend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
	graph.legend.borderLineStyle = x.axisLineStyle;
	graph.legendAnchor = CPTRectAnchorTop;
	graph.legendDisplacement = CGPointMake(0, -10.0);
}


- (void)createGraph {
  CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
  self.graphView.hostedGraph = graph;
	
  [self configureGraph:graph];

  [self configurePlotSpace:(CPTXYPlotSpace *)graph.defaultPlotSpace];
	
  [self configureAxes:(CPTXYAxisSet *)graph.axisSet];
	
  {
    NSUInteger count = 10;
    NSArray *warnings = [[DataStore sharedDataStore] dummyData:count];

    // warnings
    CPTScatterPlot *plot1 = [[CPTScatterPlot alloc] init];
    [self configurePlot:plot1 withTitle:@"Warnings" color:[CPTColor orangeColor]];
    [self.data setObject:warnings forKey:plot1.identifier];
  
    // exceptions
    CPTScatterPlot *plot2 = [[CPTScatterPlot alloc] init];
    [self configurePlot:plot2 withTitle:@"Exceptions" color:[CPTColor redColor]];
    NSArray *exceptions = [[DataStore sharedDataStore] dummyData:count];
    NSArray *sum = [Tuple ySumArray:exceptions andArray:warnings];
    [self.data setObject:sum forKey:plot2.identifier];

    [graph addPlot:plot2];
    [graph addPlot:plot1];
  }

  [self addLegend:graph];
}


#pragma mark - CPPlotDataSource


-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
  NSArray *data = [self.data objectForKey:plot.identifier];
  return [data count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index  {
  NSArray *data = [self.data objectForKey:plot.identifier];
  Tuple *t = [data objectAtIndex:index];
  if (fieldEnum == CPTCoordinateX) {
    return t.x;
  } else {
    return t.y;
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


#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  self.data = [NSMutableDictionary dictionary];
  [self createGraph];
}


- (void)viewDidUnload {
  [self setGraphView:nil];
  [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


@end
