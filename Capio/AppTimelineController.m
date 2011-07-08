//
//  AppTimelineController.m
//  Capio
//
//  Created by Sven A. Schmidt on 07.07.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import "AppTimelineController.h"


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
  plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(10)];
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


- (void)configurePlot:(CPTScatterPlot *)plot {
  plot.dataSource = self;

  // Line style
  CPTMutableLineStyle *lineStyle = [plot.dataLineStyle mutableCopy];
	lineStyle.lineWidth = 3.f;
  lineStyle.lineColor = [CPTColor redColor];
  plot.dataLineStyle = lineStyle;
	
  // Fill style
	CPTColor *fillColor = [CPTColor redColor];
  CPTGradient *gradient = [CPTGradient gradientWithBeginningColor:fillColor endingColor:[CPTColor whiteColor]];
  gradient.angle = -90.0f;
  CPTFill *areaGradientFill = [CPTFill fillWithGradient:gradient];
  plot.areaFill = areaGradientFill;
  plot.areaBaseValue = [[NSDecimalNumber zero] decimalValue];
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


- (NSArray *)dummyData {
  NSTimeInterval oneDay = 24 * 60 * 60;
  NSMutableArray *newData = [NSMutableArray array];
	NSUInteger i;
	for ( i = 0; i <= 10; i++ ) {
		NSTimeInterval x = oneDay*i;
		id y = [NSDecimalNumber numberWithFloat:10*fabs(rand()/(float)RAND_MAX)];
		[newData addObject:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [NSDecimalNumber numberWithFloat:x],
      [NSNumber numberWithInt:CPTScatterPlotFieldX], 
      y,
      [NSNumber numberWithInt:CPTScatterPlotFieldY], 
      nil]];
	}
  return newData;
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

  /*
  CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
	textStyle.fontName = @"Helvetica-Bold";
	textStyle.fontSize = 14.0;

  CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
  CPTXYAxis *x = axisSet.xAxis;
  
  graph.legend = [CPTLegend legendWithGraph:graph];
	graph.legend.textStyle = x.titleTextStyle;
	graph.legend.fill = [CPTFill fillWithColor:[CPTColor darkGrayColor]];
	graph.legend.borderLineStyle = x.axisLineStyle;
	graph.legend.cornerRadius = 5.0;
	graph.legend.swatchSize = CGSizeMake(25.0, 25.0);
	graph.legendAnchor = CPTRectAnchorBottom;
	graph.legendDisplacement = CGPointMake(0.0, 12.0);
   */
}


- (void)createGraph {
  CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
  self.graphView.hostedGraph = graph;
	
  [self configureGraph:graph];

  [self configurePlotSpace:(CPTXYPlotSpace *)graph.defaultPlotSpace];
	
  [self configureAxes:(CPTXYAxisSet *)graph.axisSet];
	
  CPTScatterPlot *plot = [[CPTScatterPlot alloc] init];
  [graph addPlot:plot];

  [self configurePlot:plot];

  [self addAnimationToPlot:plot];
}


#pragma mark - CPPlotDataSource


-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
  return [self.data count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index  {
  NSDecimalNumber *num = [[self.data objectAtIndex:index] objectForKey:[NSNumber numberWithInt:fieldEnum]];
  NSLog(@"num: %.1f", [num floatValue]);
  return num;
}


#pragma mark - Plot Space Delegate Methods

-(CPTPlotRange *)plotSpace:(CPTPlotSpace *)space willChangePlotRangeTo:(CPTPlotRange *)newRange forCoordinate:(CPTCoordinate)coordinate {
  if (coordinate == CPTCoordinateY) {
    CPTPlotRange *maxRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromInt(12)];
    CPTPlotRange *changedRange = [newRange copy];
    [changedRange shiftEndToFitInRange:maxRange];
    [changedRange shiftLocationToFitInRange:maxRange];
    newRange = changedRange;
  }
  return newRange;
}



#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  [self createGraph];
  self.data = [self dummyData];
}


- (void)viewDidUnload {
  [self setGraphView:nil];
  [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


@end
