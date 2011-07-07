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


- (void)configurePlotSpace:(CPXYPlotSpace *)plotSpace {
  plotSpace.allowsUserInteraction = YES;
  NSTimeInterval oneDay = 24 * 60 * 60;
  NSTimeInterval xLow = 0.0f;
  plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(xLow) length:CPDecimalFromFloat(oneDay*10)];
  plotSpace.yRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(-1) length:CPDecimalFromFloat(10)];
}


- (void)configureAxes {
  NSTimeInterval oneDay = 24 * 60 * 60;
  NSDateFormatter *dateTimeFormatter = [[NSDateFormatter alloc] init];
  [dateTimeFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
  
  CPXYAxisSet *axisSet = (CPXYAxisSet *)self.graph.axisSet;
  {
    CPXYAxis *x = axisSet.xAxis;
    x.majorIntervalLength = CPDecimalFromInt(oneDay);
    x.minorTicksPerInterval = 1;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = kCFDateFormatterShortStyle;
    CPTimeFormatter *timeFormatter = [[CPTimeFormatter alloc] initWithDateFormatter:dateFormatter];
    
    NSDate *refDate = [dateTimeFormatter dateFromString:@"2011-06-01 12:00"];
    timeFormatter.referenceDate = refDate;
    x.labelFormatter = timeFormatter;
  }
  {
    CPXYAxis *y = axisSet.yAxis;
    y.majorIntervalLength = CPDecimalFromInt(1);
    y.minorTicksPerInterval = 2;
  }
}


- (void)configurePlot:(CPScatterPlot *)plot {
  // Line style
  CPMutableLineStyle *lineStyle = [plot.dataLineStyle mutableCopy];
	lineStyle.lineWidth = 3.f;
  lineStyle.lineColor = [CPColor redColor];
  plot.dataLineStyle = lineStyle;
	
  // Fill style
	CPColor *fillColor = [CPColor redColor];
  CPGradient *gradient = [CPGradient gradientWithBeginningColor:fillColor endingColor:[CPColor whiteColor]];
  gradient.angle = -90.0f;
  CPFill *areaGradientFill = [CPFill fillWithGradient:gradient];
  plot.areaFill = areaGradientFill;
  plot.areaBaseValue = [[NSDecimalNumber zero] decimalValue];
}


- (void)addAnimationToPlot:(CPPlot *)plot {
	// Animate in the new plot, as an example
	plot.opacity = 0.0f;
	plot.cachePrecision = CPPlotCachePrecisionDecimal;
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
      [NSNumber numberWithInt:CPScatterPlotFieldX], 
      y,
      [NSNumber numberWithInt:CPScatterPlotFieldY], 
      nil]];
	}
  return newData;
}


- (void)createGraph {
  self.graph = [[CPXYGraph alloc] initWithFrame:CGRectZero];
	CPTheme *theme = [CPTheme themeNamed:kCPPlainWhiteTheme];
  [self.graph applyTheme:theme];
  self.graphView.hostedGraph = self.graph;
	
  self.graph.paddingLeft = 10.0;
	self.graph.paddingTop = 10.0;
	self.graph.paddingRight = 10.0;
	self.graph.paddingBottom = 10.0;
  
  [self configurePlotSpace:(CPXYPlotSpace *)self.graph.defaultPlotSpace];
	
  [self configureAxes];
	
  CPScatterPlot *plot = [[CPScatterPlot alloc] init];
  plot.dataSource = self;

  [self configurePlot:plot];

  [self addAnimationToPlot:plot];
}


#pragma mark - CPPlotDataSource


-(NSUInteger)numberOfRecordsForPlot:(CPPlot *)plot {
  return [self.data count];
}

-(NSNumber *)numberForPlot:(CPPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index  {
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
