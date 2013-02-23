//
//  SecondUIView.h
//  Painter
//
//  Created by Class Account on 2/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SecondUIView : UIView {
	NSMutableArray *strokes;
	NSMutableArray *savestrokes;
}
@property (nonatomic, retain) NSMutableArray *strokes;
@property (nonatomic, retain) NSMutableArray *savestrokes;
- (IBAction)clearCanvas:(id)sender;
- (IBAction)saveCanvas:(id)sender;
- (IBAction)loadCanvas:(id)sender;
- (float)getNumbersFromTextFields:(NSString *)textField;

@end
