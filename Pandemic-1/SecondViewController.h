//
//  SecondViewController.h
//  Painter
//
//  Created by Class Account on 2/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SecondViewController : UIViewController {
	StrokesConfigViewController *mystrokesConfigViewController;
}
@property (nonatomic, retain) StrokesConfigViewController *mystrokesConfigViewController;
- (IBAction)goToStrokesConfigureView:(id)sender;

@end