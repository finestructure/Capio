//
//  AppTimelineController.h
//  Capio
//
//  Created by Sven A. Schmidt on 07.07.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CorePlot-CocoaTouch.h"


@interface TimelineController : UIViewController <CPTPlotDataSource, CPTPlotSpaceDelegate> {
  CPTGraphHostingView *_graphView;
}

@property (nonatomic, strong) NSMutableDictionary *data;

@property (nonatomic, strong) IBOutlet CPTGraphHostingView *graphView;

@end
