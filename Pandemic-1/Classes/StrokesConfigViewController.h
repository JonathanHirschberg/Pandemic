//
//  StrokesConfigViewController.h
//  Painter
//
//  Created by Class Account on 2/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StrokesConfigViewController : UIViewController {
	UITextField *thicknessTextField;
	UITextField *alphaTextField;
	UITextField *RTextField;
	UITextField *GTextField;
	UITextField *BTextField;
	UITextField *FilenameTextField;
	UISlider *RSlider;
	UISlider *GSlider;
	UISlider *BSlider;
	UISlider *AlphaSlider;
	UILabel *RGBMixerImage;
	CGContextRef contextRef;
}
@property (nonatomic, retain) IBOutlet UITextField *thicknessTextField;
@property (nonatomic, retain) IBOutlet UITextField *alphaTextField;
@property (nonatomic, retain) IBOutlet UITextField *RTextField;
@property (nonatomic, retain) IBOutlet UITextField *GTextField;
@property (nonatomic, retain) IBOutlet UITextField *BTextField;
@property (nonatomic, retain) IBOutlet UITextField *FilenameTextField;
@property (nonatomic, retain) IBOutlet UISlider *RSlider;
@property (nonatomic, retain) IBOutlet UISlider *GSlider;
@property (nonatomic, retain) IBOutlet UISlider *BSlider;
@property (nonatomic, retain) IBOutlet UISlider *AlphaSlider;
@property (nonatomic, retain) IBOutlet UILabel *RGBMixerImage;
@property CGContextRef contextRef;
- (IBAction)changeThickness:(id)sender;
- (IBAction)changeAlpha:(id)sender;
- (IBAction)changeSliderAlpha:(id)sender;
- (IBAction)setRGB:(id)sender;
- (IBAction)sliderSetRGB:(id)sender;
- (IBAction)dismissConfigureView:(id)sender;
- (float)getNumbersFromTextFields:(NSString *)textField;
- (IBAction)changeFilename:(id)sender;

@end
