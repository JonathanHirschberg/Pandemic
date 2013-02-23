//
//  PainterAppDelegate.m
//  Painter
//
//  Created by Class Account on 2/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "PainterAppDelegate.h"

@implementation PainterAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize xradius;
@synthesize yradius;
@synthesize dalpha;
@synthesize dred;
@synthesize dgreen;
@synthesize dblue;

@synthesize salpha;
@synthesize sred;
@synthesize sgreen;
@synthesize sblue;
@synthesize sthickness;
@synthesize contextRef;

@synthesize hero;
@synthesize epsilon;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	// default values
	xradius = 5;
	yradius = 5;
	sthickness = 5;
	dalpha = 1.0;
	dred = 0.0;
	dgreen = 0.0;
	dblue = 0.0;
	dotsFilename = [[NSString alloc] initWithString:@"dotscanvasdata.plist"];
	
	salpha = 1.0;
	sred = 0.0;
	sgreen = 0.0;
	sblue = 0.0;
	strokeFilename = [[NSString alloc] initWithString:@"strokecanvasdata.plist"];
    // Add the tab bar controller's current view as a subview of the window

	// initialization of hero piece
	CGPoint point;
	point.x = 160;
	point.y = 230;
	hero = [[Wrapper alloc] init];
	hero.xradius = 15;
	hero.yradius = 15;
	hero.alpha = 1.0;
	hero.red = 1.0;
	hero.green = 1.0;
	hero.blue = 1.0;
	hero.point = point;
	
	epsilon = 5;

    [window addSubview:tabBarController.view];
}


/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

