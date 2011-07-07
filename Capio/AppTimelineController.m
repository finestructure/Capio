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
	CPTheme *theme = [CPTheme themeNamed:kCPDarkGradientTheme];
  [self.graph applyTheme:theme];
  self.graphView.hostedGraph = self.graph;
	
  self.graph.paddingLeft = 10.0;
	self.graph.paddingTop = 10.0;
	self.graph.paddingRight = 10.0;
	self.graph.paddingBottom = 10.0;
  
  // Setup plot space
  CPXYPlotSpace *plotSpace = (CPXYPlotSpace *)self.graph.defaultPlotSpace;
  plotSpace.allowsUserInteraction = YES;
  plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(1.0) length:CPDecimalFromFloat(2.0)];
  plotSpace.yRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(1.0) length:CPDecimalFromFloat(3.0)];
	
  // Axes
	CPXYAxisSet *axisSet = (CPXYAxisSet *)self.graph.axisSet;
  CPXYAxis *x = axisSet.xAxis;
  x.majorIntervalLength = CPDecimalFromString(@"0.5");
  x.orthogonalCoordinateDecimal = CPDecimalFromString(@"2");
  x.minorTicksPerInterval = 2;
 	NSArray *exclusionRanges = [NSArray arrayWithObjects:
                              [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(1.99) length:CPDecimalFromFloat(0.02)], 
                              [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(0.99) length:CPDecimalFromFloat(0.02)],
                              [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(2.99) length:CPDecimalFromFloat(0.02)],
                              nil];
	x.labelExclusionRanges = exclusionRanges;
	
  CPXYAxis *y = axisSet.yAxis;
  y.majorIntervalLength = CPDecimalFromString(@"0.5");
  y.minorTicksPerInterval = 5;
  y.orthogonalCoordinateDecimal = CPDecimalFromString(@"2");
	exclusionRanges = [NSArray arrayWithObjects:
                     [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(1.99) length:CPDecimalFromFloat(0.02)], 
                     [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(0.99) length:CPDecimalFromFloat(0.02)],
                     [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(3.99) length:CPDecimalFromFloat(0.02)],
                     nil];
	y.labelExclusionRanges = exclusionRanges;
	
  // Create a green plot area
	CPScatterPlot *dataSourceLinePlot = [[CPScatterPlot alloc] init];
  dataSourceLinePlot.identifier = @"Green Plot";
  
  CPMutableLineStyle *lineStyle = [dataSourceLinePlot.dataLineStyle mutableCopy];
	lineStyle.lineWidth = 3.f;
  lineStyle.lineColor = [CPColor greenColor];
	lineStyle.dashPattern = [NSArray arrayWithObjects:[NSNumber numberWithFloat:5.0f], [NSNumber numberWithFloat:5.0f], nil];
  dataSourceLinePlot.dataLineStyle = lineStyle;
  
  dataSourceLinePlot.dataSource = self;
	
	// Put an area gradient under the plot above
  CPColor *areaColor = [CPColor colorWithComponentRed:0.3 green:1.0 blue:0.3 alpha:0.8];
  CPGradient *areaGradient = [CPGradient gradientWithBeginningColor:areaColor endingColor:[CPColor clearColor]];
  areaGradient.angle = -90.0f;
  CPFill *areaGradientFill = [CPFill fillWithGradient:areaGradient];
  dataSourceLinePlot.areaFill = areaGradientFill;
  dataSourceLinePlot.areaBaseValue = CPDecimalFromString(@"1.75");
	
	// Animate in the new plot, as an example
	dataSourceLinePlot.opacity = 0.0f;
	dataSourceLinePlot.cachePrecision = CPPlotCachePrecisionDecimal;
  [self.graph addPlot:dataSourceLinePlot];
	
	CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeInAnimation.duration = 1.0f;
	fadeInAnimation.removedOnCompletion = NO;
	fadeInAnimation.fillMode = kCAFillModeForwards;
	fadeInAnimation.toValue = [NSNumber numberWithFloat:1.0];
	[dataSourceLinePlot addAnimation:fadeInAnimation forKey:@"animateOpacity"];
	
	// Create a blue plot area
	CPScatterPlot *boundLinePlot = [[CPScatterPlot alloc] init];
  boundLinePlot.identifier = @"Blue Plot";
  
  lineStyle = [boundLinePlot.dataLineStyle mutableCopy];
	lineStyle.miterLimit = 1.0f;
	lineStyle.lineWidth = 3.0f;
	lineStyle.lineColor = [CPColor blueColor];
  lineStyle = lineStyle;
  
  boundLinePlot.dataSource = self;
	boundLinePlot.cachePrecision = CPPlotCachePrecisionDouble;
	boundLinePlot.interpolation = CPScatterPlotInterpolationHistogram;
	[self.graph addPlot:boundLinePlot];
	
	// Do a blue gradient
	CPColor *areaColor1 = [CPColor colorWithComponentRed:0.3 green:0.3 blue:1.0 alpha:0.8];
  CPGradient *areaGradient1 = [CPGradient gradientWithBeginningColor:areaColor1 endingColor:[CPColor clearColor]];
  areaGradient1.angle = -90.0f;
  areaGradientFill = [CPFill fillWithGradient:areaGradient1];
  boundLinePlot.areaFill = areaGradientFill;
  boundLinePlot.areaBaseValue = [[NSDecimalNumber zero] decimalValue];    
	
	// Add plot symbols
	CPMutableLineStyle *symbolLineStyle = [CPMutableLineStyle lineStyle];
	symbolLineStyle.lineColor = [CPColor blackColor];
	CPPlotSymbol *plotSymbol = [CPPlotSymbol ellipsePlotSymbol];
	plotSymbol.fill = [CPFill fillWithColor:[CPColor blueColor]];
	plotSymbol.lineStyle = symbolLineStyle;
  plotSymbol.size = CGSizeMake(10.0, 10.0);
  boundLinePlot.plotSymbol = plotSymbol;
	
  // Add some initial data
	NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:100];
	NSUInteger i;
	for ( i = 0; i < 60; i++ ) {
		id x = [NSNumber numberWithFloat:1+i*0.05];
		id y = [NSNumber numberWithFloat:1.2*rand()/(float)RAND_MAX + 1.2];
		[contentArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
	}
	self.data = contentArray;
}


#pragma mark - CPPlotDataSource


-(NSUInteger)numberOfRecordsForPlot:(CPPlot *)plot {
  return [self.data count];
}

-(NSNumber *)numberForPlot:(CPPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index 
{
  NSDecimalNumber *num = nil;
  if ( index % 8 ) {
    num = [[self.data objectAtIndex:index] valueForKey:(fieldEnum == CPScatterPlotFieldX ? @"x" : @"y")];
    // Green plot gets shifted above the blue
    if ( [(NSString *)plot.identifier isEqualToString:@"Green Plot"] ) {
      if ( fieldEnum == CPScatterPlotFieldY ) {
        num = (NSDecimalNumber *)[NSDecimalNumber numberWithDouble:[num doubleValue] + 1.0];
      }
    }
  } else {
    num = [NSDecimalNumber notANumber];
  }
	
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
