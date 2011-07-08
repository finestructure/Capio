//
//  AppTimelineController.m
//  Capio
//
//  Created by Sven A. Schmidt on 07.07.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import "AppTimelineController.h"


@implementation AppTimelineController

@synthesize graph = _graph;
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
  plotSpace.allowsUserInteraction = YES;
  NSTimeInterval oneDay = 24 * 60 * 60;
  NSTimeInterval xLow = 0.0f;
  plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xLow) length:CPTDecimalFromFloat(oneDay*10)];
  plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-1) length:CPTDecimalFromFloat(10)];
}


- (void)configureAxes {
  NSTimeInterval oneDay = 24 * 60 * 60;
  NSDateFormatter *dateTimeFormatter = [[NSDateFormatter alloc] init];
  [dateTimeFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
  
  CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
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
  }
  {
    CPTXYAxis *y = axisSet.yAxis;
    y.majorIntervalLength = CPTDecimalFromInt(1);
    y.minorTicksPerInterval = 2;
  }
}


- (void)configurePlot:(CPTScatterPlot *)plot {
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
	// Animate in the new plot, as an example
	plot.opacity = 0.0f;
	plot.cachePrecision = CPTPlotCachePrecisionDecimal;
  [self.graph addPlot:plot];
	
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


- (void)createGraph {
  self.graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
	CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
  [self.graph applyTheme:theme];
  self.graphView.hostedGraph = self.graph;
	
  self.graph.paddingLeft = 10.0;
	self.graph.paddingTop = 10.0;
	self.graph.paddingRight = 10.0;
	self.graph.paddingBottom = 10.0;
  
  [self configurePlotSpace:(CPTXYPlotSpace *)self.graph.defaultPlotSpace];
	
  [self configureAxes];
	
  CPTScatterPlot *plot = [[CPTScatterPlot alloc] init];
  plot.dataSource = self;

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
