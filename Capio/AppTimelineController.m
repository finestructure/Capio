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

- (void)createGraph {
  // Create graph from theme
  self.graph = [[CPXYGraph alloc] initWithFrame:CGRectZero];
	CPTheme *theme = [CPTheme themeNamed:kCPPlainWhiteTheme];
  [self.graph applyTheme:theme];
  self.graphView.hostedGraph = self.graph;
	
  self.graph.paddingLeft = 10.0;
	self.graph.paddingTop = 10.0;
	self.graph.paddingRight = 10.0;
	self.graph.paddingBottom = 10.0;
  
  // Setup plot space
  float x_offset = -1;
  float x_range = 10;
  float y_offset = x_offset;
  float y_range = x_range;
  CPXYPlotSpace *plotSpace = (CPXYPlotSpace *)self.graph.defaultPlotSpace;
  plotSpace.allowsUserInteraction = YES;
  plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(x_offset) length:CPDecimalFromFloat(x_range - x_offset)];
  plotSpace.yRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(y_offset) length:CPDecimalFromFloat(y_range - y_offset)];
	
  // Configure axes
  CPXYAxisSet *axisSet = (CPXYAxisSet *)self.graph.axisSet;
  {
    CPXYAxis *x = axisSet.xAxis;
    x.majorIntervalLength = CPDecimalFromInt(1);
    x.minorTicksPerInterval = 2;
  }
  {
    CPXYAxis *y = axisSet.yAxis;
    y.majorIntervalLength = CPDecimalFromInt(1);
    y.minorTicksPerInterval = 2;
  }
	
  // Create plot
	CPScatterPlot *plot = [[CPScatterPlot alloc] init];
  plot.dataSource = self;
  
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
  
  // Add some initial data
	NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:100];
	NSUInteger i;
	for ( i = 0; i <= x_range; i++ ) {
		id x = [NSNumber numberWithFloat:i];
		id y = [NSNumber numberWithFloat:10*fabs(rand()/(float)RAND_MAX)];
		[contentArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
	}
	self.data = contentArray;
}


#pragma mark - CPPlotDataSource


-(NSUInteger)numberOfRecordsForPlot:(CPPlot *)plot {
  return [self.data count];
}

-(NSNumber *)numberForPlot:(CPPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index  {
  NSDecimalNumber *num = [[self.data objectAtIndex:index] valueForKey:(fieldEnum == CPScatterPlotFieldX ? @"x" : @"y")];
  NSLog(@"num: %.1f", [num floatValue]);
  return num;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
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
