//
//  AppTimelineController.h
//  Capio
//
//  Created by Sven A. Schmidt on 07.07.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CorePlot-CocoaTouch.h"


@interface AppTimelineController : UIViewController<CPTPlotDataSource, CPTPlotSpaceDelegate> {
  CPTGraphHostingView *_graphView;
}

@property (nonatomic, strong) CPTXYGraph *graph;
@property (nonatomic, strong) NSArray *data;

@property (nonatomic, strong) IBOutlet CPTGraphHostingView *graphView;

@end
