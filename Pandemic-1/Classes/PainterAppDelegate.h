//
//  PainterAppDelegate.h
//  Painter
//
//  Created by Class Account on 2/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Wrapper.h"

@interface PainterAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;

	// global variables
	float xradius;
	float yradius;
	float dalpha;
	float dred, dgreen, dblue;
	float thickness;
	CGContextRef contextRef;
	
	float salpha;
	float sred, sgreen, sblue;
	float sthickness;	
	
	NSString *strokeFilename;
	NSString *dotsFilename;
	
	// pandemic global variables
	Wrapper *hero;
	float epsilon;	
}
@property CGContextRef contextRef;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property float xradius;
@property float yradius;
@property float dalpha;
@property float dred;
@property float dgreen;
@property float dblue;
@property (nonatomic, retain) NSString *dotsFilename;

@property float salpha;
@property float sred;
@property float sgreen;
@property float sblue;
@property float sthickness;
@property (nonatomic, retain) NSString *strokeFilename;

@property (nonatomic, retain) Wrapper *hero;
@property float epsilon;

@end
