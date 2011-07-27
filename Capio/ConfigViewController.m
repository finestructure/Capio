//
//  ConfigViewController.m
//  Capio
//
//  Created by Sven A. Schmidt on 27.07.11.
//  Copyright 2011 abstracture GmbH & Co. KG. All rights reserved.
//

#import "ConfigViewController.h"
#import "Constants.h"


@implementation ConfigViewController
@synthesize navigationController = _navigationController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      UIImage *img = [UIImage imageNamed:@"gear.png"];
      UITabBarItem *tab = [[UITabBarItem alloc] initWithTitle:@"Configuration" image:img tag:2];
      self.tabBarItem = tab;
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

  BonjourBrowser *browser = [[BonjourBrowser alloc] initForType:@"_http._tcp"
                                                       inDomain:@"local"
                                                  customDomains:nil
                                       showDisclosureIndicators:NO
                                               showCancelButton:NO];
  browser.navigationBar.barStyle = UIBarStyleBlack;

  self.navigationController = browser;
  browser.delegate = self;
  [self.view addSubview:browser.view];
}

- (void)viewDidUnload
{
  [self setNavigationController:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:kCouchServiceUrlChanged object:self];
  }
}

@end
