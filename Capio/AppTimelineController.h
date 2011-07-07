//
//  AppTimelineController.h
//  Capio
//
//  Created by Sven A. Schmidt on 07.07.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CorePlot-CocoaTouch.h"


@interface AppTimelineController : UIViewController<CPPlotDataSource> {
  CPGraphHostingView *_graphView;
}

@property (nonatomic, strong) CPXYGraph *graph;
@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) IBOutlet CPGraphHostingView *graphView;

@end
