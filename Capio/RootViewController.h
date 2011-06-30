//
//  RootViewController.h
//  MGSplitView
//
//  Created by Matt Gemmell on 26/07/2010.
//  Copyright Instinctive Code 2010.
//

#import <UIKit/UIKit.h>

@class AppOverview;

@interface RootViewController : UITableViewController {
    AppOverview *detailViewController;
}

@property (nonatomic, retain) IBOutlet AppOverview *detailViewController;

- (void)selectFirstRow;

@end
