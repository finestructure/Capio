//
//  MetricOverviewController.h
//  Capio
//
//  Created by Sven A. Schmidt on 19.07.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CorePlot-CocoaTouch.h"

@interface MetricOverviewController : UIViewController <CPTPlotDataSource, CPTPlotSpaceDelegate> {
  CPTGraphHostingView *_graphView;
  UILabel *_serverName;
  UILabel *_reportDate;
}

@property (nonatomic, strong) NSMutableDictionary *data;
@property (nonatomic, strong) CPTXYGraph *graph;
@property (strong, nonatomic) NSDictionary *detailItem;
@property (strong, nonatomic) NSDictionary *processed;

@property (nonatomic, strong) IBOutlet CPTGraphHostingView *graphView;
@property (strong, nonatomic) IBOutletCollection(UISwitch) NSArray *metricSwitches;
@property (strong, nonatomic) IBOutlet UILabel *serverName;
@property (strong, nonatomic) IBOutlet UILabel *reportDate;

- (void)drawLegend;
- (void)drawMetric:(NSUInteger)index;
- (NSString *)metricTitle:(NSUInteger)index;
- (CPTColor *)metricColor:(NSUInteger)index;

- (IBAction)metricToggled:(id)sender;

@end
