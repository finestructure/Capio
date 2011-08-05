//
//  ConfigViewController.m
//  Capio
//
//  Created by Sven A. Schmidt on 27.07.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIView+RoundedCorners.h"

#import "Constants.h"
#import "SettingsController.h"
#import "GeneralSettingsController.h"
#import "WebViewController.h"



@implementation SettingsController

@synthesize categories = _sections;

@synthesize masterView = _masterView;
@synthesize detailView = _detailView;
@synthesize masterViewController = _masterViewController;
@synthesize detailViewController = _detailViewController;
@synthesize tableView = _tableView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      UIImage *img = [UIImage imageNamed:@"gear.png"];
      UITabBarItem *tab = [[UITabBarItem alloc] initWithTitle:@"Settings" image:img tag:2];
      self.tabBarItem = tab;
      
      self.categories = [NSArray arrayWithObjects:
                         @"General",
                         @"CouchDB Server",
                         @"Webview Test",
                         @"Calendar",
                         @"Force",
                         @"Treemap",
                         nil];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  id vc = [[GeneralSettingsController alloc] initWithNibName:@"GeneralSettings" bundle:nil];
  self.detailViewController = vc;
  NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
  [self.tableView selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionNone];
  
  CGRect masterFrame = CGRectMake(0, 0, self.masterView.frame.size.width, self.masterView.frame.size.height); 
  
  [self.masterViewController.view setFrame:masterFrame];
  [self.masterViewController.view setRoundedCorners:UIViewRoundedCornerUpperRight radius:6.0];
  [self.detailViewController.view setRoundedCorners:UIViewRoundedCornerUpperLeft radius:6.0];
  
  [self.detailView addSubview:self.detailViewController.view];
  [self.masterView addSubview:self.masterViewController.view];
}

- (void)viewDidUnload {
  [self setMasterView:nil];
  [self setDetailView:nil];
  [self setMasterViewController:nil];
  [self setDetailViewController:nil];
  [self setTableView:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


#pragma mark - BonjourBrowserDelegate


- (NSString *)copyStringFromTXTDict:(NSDictionary *)dict which:(NSString*)which {
	// Helper for getting information from the TXT data
	NSData* data = [dict objectForKey:which];
	NSString *resultString = nil;
	if (data) {
		resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	}
	return resultString;
}


- (void) bonjourBrowser:(BonjourBrowser*)browser didResolveInstance:(NSNetService*)service {
	// Construct the URL including the port number
	// Also use the path, username and password fields that can be in the TXT record
	NSDictionary* dict = [NSNetService dictionaryFromTXTRecordData:[service TXTRecordData]];
	NSString *host = [service hostName];
	
	NSString* user = [self copyStringFromTXTDict:dict which:@"u"];
	NSString* pass = [self copyStringFromTXTDict:dict which:@"p"];
	
	NSString* portStr = @"";
	
	// Note that [NSNetService port:] returns an NSInteger in host byte order
	NSInteger port = [service port];
	if (port != 0 && port != 80)
    portStr = [[NSString alloc] initWithFormat:@":%d",port];
	
	NSString* path = [self copyStringFromTXTDict:dict which:@"path"];
	if (!path || [path length]==0) {
    path = [[NSString alloc] initWithString:@"/"];
	} else if (![[path substringToIndex:1] isEqual:@"/"]) {
    NSString *tempPath = [[NSString alloc] initWithFormat:@"/%@",path];
    path = tempPath;
	}
	
	NSString* url = [[NSString alloc] initWithFormat:@"http://%@%@%@%@%@%@%@",
                      user?user:@"",
                      pass?@":":@"",
                      pass?pass:@"",
                      (user||pass)?@"@":@"",
                      host,
                      portStr,
                      path];
	
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *previousUrl = [defaults stringForKey:kCouchServiceUrl];
  
  if (! [previousUrl isEqualToString:url]) {
    [defaults setValue:service.name forKey:kCouchServiceName];
    NSLog(@"Stored kCouchServiceName: %@", service.name);
    [defaults setValue:url forKey:kCouchServiceUrl];
    NSLog(@"Stored kCouchServiceUrl: %@", url);
    [defaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:kCouchServiceUrlChanged object:self];
  }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.categories count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ConfigCategoryCell"];
  
  cell.textLabel.text = [self.categories objectAtIndex:indexPath.row];
  
  return cell;
}


#pragma mark - Table view delegate

- (WebViewController *)webControllerForPath:(NSString *)resource {
  WebViewController *vc = [[WebViewController alloc] initWithNibName:@"WebView" bundle:nil];
  vc.webView.delegate = self;
  
  NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], resource];
  NSLog(@"Path: %@", path);
  NSURL *url = [NSURL fileURLWithPath:path];
  //NSURL *url = [NSURL URLWithString:@"http://mbostock.github.com/d3/ex/calendar.html"];
  
  vc.url = url;
  
  return vc;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.detailViewController.view removeFromSuperview];
  switch (indexPath.row) {
    case 0: {
      id vc = [[GeneralSettingsController alloc] initWithNibName:@"GeneralSettings" bundle:nil];
      self.detailViewController = vc;
      break;
    }
    case 1: {
      BonjourBrowser *browser = [[BonjourBrowser alloc] initForType:@"_http._tcp"
                                                           inDomain:@"local"
                                                      customDomains:nil
                                           showDisclosureIndicators:NO
                                                   showCancelButton:NO];
      browser.navigationBar.barStyle = UIBarStyleBlack;
      browser.delegate = self;
      self.detailViewController = browser;
      break;
    }
    case 2: {
      WebViewController *vc = [[WebViewController alloc] initWithNibName:@"WebView" bundle:nil];
      vc.webView.delegate = self;
      self.detailViewController = vc;

      NSString *path = [[NSBundle mainBundle] pathForResource:@"app_overview" ofType:@"html"];
      NSURL *url = [NSURL fileURLWithPath:path];
      vc.url = url;
      
      break;
    }
    case 3: {
      self.detailViewController = [self webControllerForPath:@"d3/examples/calendar/dji.html"];
      break;
    }
    case 4: {
      self.detailViewController = [self webControllerForPath:@"d3/examples/force/force.html"];
      break;
    }
    case 5: {
      self.detailViewController = [self webControllerForPath:@"d3/examples/treemap/treemap.html"];
      break;
    }
    default:
      break;
  }
  [self.detailView addSubview:self.detailViewController.view];
}


#pragma mark - UIWebViewDelegate


- (void)webViewDidStartLoad:(UIWebView *)webView {
  NSLog(@"webViewDidStartLoad");
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  NSLog(@"Error: %@", error);
}


@end
