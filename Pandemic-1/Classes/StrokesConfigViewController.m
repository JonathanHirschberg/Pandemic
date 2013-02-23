//
//  StrokesConfigViewController.m
//  Painter
//
//  Created by Class Account on 2/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StrokesConfigViewController.h"
#import "PainterAppDelegate.h"

@implementation StrokesConfigViewController
@synthesize thicknessTextField;
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

- (IBAction)changeThickness:(id)sender {
	PainterAppDelegate *appDelegate = (PainterAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.sthickness = [self getNumbersFromTextFields:thicknessTextField.text];
	thicknessTextField.text = [[NSString alloc] initWithFormat:@"%.2f", appDelegate.sthickness];
}
- (IBAction)changeAlpha:(id)sender {
	PainterAppDelegate *appDelegate = (PainterAppDelegate *)[[UIApplication sharedApplication] delegate];
	if([self getNumbersFromTextFields:alphaTextField.text] > 1.0) {
		alphaTextField.text = @"1.0";
	}
	if([self getNumbersFromTextFields:alphaTextField.text] < 0.0) {
		alphaTextField.text = @"0.0";
	}	
	appDelegate.salpha = [self getNumbersFromTextFields:alphaTextField.text];
	AlphaSlider.value = appDelegate.salpha;
	CGContextSetAlpha(appDelegate.contextRef, appDelegate.salpha);
	RGBMixerImage.backgroundColor = [UIColor colorWithRed:appDelegate.sred green:appDelegate.sgreen blue:appDelegate.sblue alpha:appDelegate.salpha];
}

- (IBAction)changeSliderAlpha:(id)sender {
	PainterAppDelegate *appDelegate = (PainterAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.salpha = AlphaSlider.value;
	alphaTextField.text = [[NSString alloc] initWithFormat:@"%.2f", appDelegate.salpha];
	CGContextSetAlpha(appDelegate.contextRef, appDelegate.salpha);
	RGBMixerImage.backgroundColor = [UIColor colorWithRed:appDelegate.sred green:appDelegate.sgreen blue:appDelegate.sblue alpha:appDelegate.salpha];
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
	appDelegate.sred = [self getNumbersFromTextFields:RTextField.text];
	appDelegate.sgreen = [self getNumbersFromTextFields:GTextField.text];
	appDelegate.sblue = [self getNumbersFromTextFields:BTextField.text];
	appDelegate.salpha = [self getNumbersFromTextFields:alphaTextField.text];
	
	CGContextSetRGBFillColor(appDelegate.contextRef, appDelegate.sred, appDelegate.sgreen, appDelegate.sblue, appDelegate.salpha);
	RSlider.value = appDelegate.sred;
	GSlider.value = appDelegate.sgreen;
	BSlider.value = appDelegate.sblue;
	RGBMixerImage.backgroundColor = [UIColor colorWithRed:appDelegate.sred green:appDelegate.sgreen blue:appDelegate.sblue alpha:appDelegate.salpha];
}

- (IBAction)sliderSetRGB:(id)sender {
	PainterAppDelegate *appDelegate = (PainterAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.sred = RSlider.value;
	appDelegate.sgreen = GSlider.value;
	appDelegate.sblue = BSlider.value;
	appDelegate.salpha = [self getNumbersFromTextFields:alphaTextField.text];
	
	CGContextSetRGBFillColor(appDelegate.contextRef, appDelegate.sred, appDelegate.sgreen, appDelegate.sblue, appDelegate.salpha);
	RTextField.text = [[NSString alloc] initWithFormat:@"%.2f", appDelegate.sred];
	GTextField.text = [[NSString alloc] initWithFormat:@"%.2f", appDelegate.sgreen];
	BTextField.text = [[NSString alloc] initWithFormat:@"%.2f", appDelegate.sblue];
	RGBMixerImage.backgroundColor = [UIColor colorWithRed:appDelegate.sred green:appDelegate.sgreen blue:appDelegate.sblue alpha:appDelegate.salpha];
}

- (IBAction)changeFilename:(id)sender {
	PainterAppDelegate *appDelegate = (PainterAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.strokeFilename = FilenameTextField.text;
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

- (IBAction)dismissConfigureView:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
	//	[[self view] removeFromSuperview];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	if (theTextField == thicknessTextField) {
		[thicknessTextField resignFirstResponder];
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
