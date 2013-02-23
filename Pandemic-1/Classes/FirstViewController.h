//
//  FirstViewController.h
//  Painter
//
//  Created by Class Account on 2/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FirstViewController : UIViewController {
	DotsConfigViewController *mydotsConfigViewController;
}
@property (nonatomic, retain) DotsConfigViewController *mydotsConfigViewController;
- (IBAction)goToConfigureView:(id)sender;

@end
