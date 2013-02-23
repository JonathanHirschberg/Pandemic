//
//  DotsConfigViewController.m
//  Painter
//
//  Created by Class Account on 2/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DotsConfigViewController.h"
#import "PainterAppDelegate.h"

@implementation DotsConfigViewController
@synthesize xradiusTextField;
@synthesize yradiusTextField;
@synthesize alphaTextField;
@synthesize RTextField;
@synthesize GTextField;
@synthesize	BTextField;
@synthesize FilenameTextField;
@synthesize RSlider;
@synthesize GSlider;
@synthesize BSlider;
@synthesize AlphaSlider;
@synthesize contextRef;
@synthesize RGBMixerImage;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction)changeRadius:(id)sender {
	PainterAppDelegate *appDelegate = (PainterAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.xradius = [self getNumbersFromTextFields:xradiusTextField.text];
	appDelegate.yradius = [self getNumbersFromTextFields:yradiusTextField.text];
	xradiusTextField.text = [[NSString alloc] initWithFormat:@"%.2f", appDelegate.xradius];
	yradiusTextField.text = [[NSString alloc] initWithFormat:@"%.2f", appDelegate.yradius];
}

- (IBAction)changeAlpha:(id)sender {
	PainterAppDelegate *appDelegate = (PainterAppDelegate *)[[UIApplication sharedApplication] delegate];
	if([self getNumbersFromTextFields:alphaTextField.text] > 1.0) {
		alphaTextField.text = @"1.0";
	}
	if([self getNumbersFromTextFields:alphaTextField.text] < 0.0) {
		alphaTextField.text = @"0.0";
	}
	appDelegate.dalpha = [self getNumbersFromTextFields:alphaTextField.text];
	AlphaSlider.value = appDelegate.dalpha;
	CGContextSetAlpha(appDelegate.contextRef, appDelegate.dalpha);
	RGBMixerImage.backgroundColor = [UIColor colorWithRed:appDelegate.dred green:appDelegate.dgreen blue:appDelegate.dblue alpha:appDelegate.dalpha];
}

- (IBAction)changeSliderAlpha:(id)sender {
	PainterAppDelegate *appDelegate = (PainterAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.dalpha = AlphaSlider.value;
	alphaTextField.text = [[NSString alloc] initWithFormat:@"%.2f", appDelegate.dalpha];
	CGContextSetAlpha(appDelegate.contextRef, appDelegate.dalpha);
	RGBMixerImage.backgroundColor = [UIColor colorWithRed:appDelegate.dred green:appDelegate.dgreen blue:appDelegate.dblue alpha:appDelegate.dalpha];
}

- (IBAction)setRGB:(id)sender {
	PainterAppDelegate *appDelegate = (PainterAppDelegate *)[[UIApplication sharedApplication] delegate];
	if([self getNumbersFromTextFields:RTextField.text] > 1.0) {
		RTextField.text = @"1.0";
	}
	if([self getNumbersFromTextFields:GTextField.text] > 1.0) {
		GTextField.text = @"1.0";
	}
	if([self getNumbersFromTextFields:BTextField.text] > 1.0) {
		BTextField.text = @"1.0";
	}
	if([self getNumbersFromTextFields:RTextField.text] < 0.0) {
		RTextField.text = @"0.0";
	}
	if([self getNumbersFromTextFields:GTextField.text] < 0.0) {
		GTextField.text = @"0.0";
	}
	if([self getNumbersFromTextFields:BTextField.text] < 0.0) {
		BTextField.text = @"0.0";
	}
	appDelegate.dred = [self getNumbersFromTextFields:RTextField.text];
	appDelegate.dgreen = [self getNumbersFromTextFields:GTextField.text];
	appDelegate.dblue = [self getNumbersFromTextFields:BTextField.text];
	appDelegate.dalpha = [self getNumbersFromTextFields:alphaTextField.text];

	CGContextSetRGBFillColor(appDelegate.contextRef, appDelegate.dred, appDelegate.dgreen, appDelegate.dblue, appDelegate.dalpha);
	RSlider.value = appDelegate.dred;
	GSlider.value = appDelegate.dgreen;
	BSlider.value = appDelegate.dblue;
	RGBMixerImage.backgroundColor = [UIColor colorWithRed:appDelegate.dred green:appDelegate.dgreen blue:appDelegate.dblue alpha:appDelegate.dalpha];
}

- (IBAction)sliderSetRGB:(id)sender {
	PainterAppDelegate *appDelegate = (PainterAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.dred = RSlider.value;
	appDelegate.dgreen = GSlider.value;
	appDelegate.dblue = BSlider.value;
	appDelegate.dalpha = [self getNumbersFromTextFields:alphaTextField.text];
	
	CGContextSetRGBFillColor(appDelegate.contextRef, appDelegate.dred, appDelegate.dgreen, appDelegate.dblue, appDelegate.dalpha);
	RTextField.text = [[NSString alloc] initWithFormat:@"%.2f", appDelegate.dred];
	GTextField.text = [[NSString alloc] initWithFormat:@"%.2f", appDelegate.dgreen];
	BTextField.text = [[NSString alloc] initWithFormat:@"%.2f", appDelegate.dblue];
	RGBMixerImage.backgroundColor = [UIColor colorWithRed:appDelegate.dred green:appDelegate.dgreen blue:appDelegate.dblue alpha:appDelegate.dalpha];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (float)getNumbersFromTextFields:(NSString *)textField {
	NSScanner *scanner = [NSScanner scannerWithString:textField];
	float rtn;
	if([scanner scanFloat:&rtn]) { // valid float number
		return rtn;
	}
	return 0;
}

- (IBAction)changeFilename:(id)sender {
	PainterAppDelegate *appDelegate = (PainterAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.dotsFilename = FilenameTextField.text;
}

- (IBAction)dismissConfigureView:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
//	[[self view] removeFromSuperview];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	if (theTextField == xradiusTextField) {
		[xradiusTextField resignFirstResponder];
	}
	if (theTextField == yradiusTextField) {
		[yradiusTextField resignFirstResponder];
	}
	if (theTextField == alphaTextField) {
		[alphaTextField resignFirstResponder];
	}
	if (theTextField == RTextField) {
		[RTextField resignFirstResponder];
	}
	if (theTextField == GTextField) {
		[GTextField resignFirstResponder];
	}
	if (theTextField == BTextField) {
		[BTextField resignFirstResponder];
	}
	if (theTextField == FilenameTextField) {
		[FilenameTextField resignFirstResponder];
	}
	return YES;
}

- (void)dealloc {
    [super dealloc];
}


@end
