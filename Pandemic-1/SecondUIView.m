//
//  SecondUIView.m
//  Painter
//
//  Created by Class Account on 2/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SecondUIView.h"
#import "PainterAppDelegate.h"
#import "strokeWrapper.h"
#define csFilename @"strokecanvasdata.plist"

@implementation SecondUIView
@synthesize strokes;
@synthesize savestrokes;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


- (void) awakeFromNib {
	strokes = [[NSMutableArray alloc] init];
	savestrokes = [[NSMutableArray alloc] init];
}


- (void)drawRect:(CGRect)rect {
	PainterAppDelegate *appDelegate = (PainterAppDelegate *)[[UIApplication sharedApplication] delegate];
	//	NSLog([[NSString alloc] initWithFormat:@"Points count: %d", [strokes count]]);
	appDelegate.contextRef = UIGraphicsGetCurrentContext();
	
	for(int i = 0; i < [strokes count]; i++){
		CGContextSetRGBStrokeColor(appDelegate.contextRef, [[[strokes objectAtIndex:i] objectAtIndex:0] red], 
								   [[[strokes objectAtIndex:i] objectAtIndex:0] green], 
								   [[[strokes objectAtIndex:i] objectAtIndex:0] blue], 
								   [[[strokes objectAtIndex:i] objectAtIndex:0] alpha]);
		CGContextSetLineWidth(appDelegate.contextRef, [[[strokes objectAtIndex:i] objectAtIndex:0] thickness]);
		CGPoint startpoint = [[[strokes objectAtIndex:i] objectAtIndex:0] point];
		CGContextMoveToPoint(appDelegate.contextRef, startpoint.x, startpoint.y);
		for(int j = 0; j < [[strokes objectAtIndex:i] count]; j++){
			// Drawing code
			CGContextSetRGBStrokeColor(appDelegate.contextRef, [[[strokes objectAtIndex:i] objectAtIndex:j] red], 
									[[[strokes objectAtIndex:i] objectAtIndex:j] green],
									[[[strokes objectAtIndex:i] objectAtIndex:j] blue],
									[[[strokes objectAtIndex:i] objectAtIndex:j] alpha]);
			CGContextSetLineWidth(appDelegate.contextRef, [[[strokes objectAtIndex:i] objectAtIndex:j] thickness]);
			CGPoint point = [[[strokes objectAtIndex:i] objectAtIndex:j] point];
			CGContextAddLineToPoint(appDelegate.contextRef, point.x, point.y);
//			NSLog(@"Drawing stuff");
		
//			NSLog([[NSString alloc] initWithFormat:@"Point Coordinates: %d, %d", point.x, point.y]);
		}
		CGContextStrokePath(appDelegate.contextRef);
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	PainterAppDelegate *appDelegate = (PainterAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSArray *alltouches = [[NSArray alloc] initWithArray:[touches allObjects]];
	for(int d = 0; d < [alltouches count]; d++) {
		NSMutableArray *stroke = [[NSMutableArray alloc] init];
		CGPoint point = [[alltouches objectAtIndex:d] locationInView:self];
		
		strokeWrapper *awrapper = [[strokeWrapper alloc] init];
		awrapper.thickness = appDelegate.sthickness;
		awrapper.alpha = appDelegate.salpha;
		awrapper.red = appDelegate.sred;
		awrapper.green = appDelegate.sgreen;
		awrapper.blue = appDelegate.sblue;
		awrapper.point = point;
		[stroke addObject:awrapper];		
		[awrapper release];
		[strokes addObject:stroke];
		[stroke release];
	}
	[alltouches release];
	[self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	PainterAppDelegate *appDelegate = (PainterAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSArray *alltouches = [[NSArray alloc] initWithArray:[touches allObjects]];
	for(int d = 0; d < [alltouches count]; d++) {
		CGPoint prevpoint = [[alltouches objectAtIndex:d] previousLocationInView:self];
		CGPoint point = [[alltouches objectAtIndex:d] locationInView:self];
		for(int e = 0; e < [strokes count]; e++) {
			strokeWrapper *awrapper = [[strokeWrapper alloc] init];
			awrapper.thickness = appDelegate.sthickness;
			awrapper.alpha = appDelegate.salpha;
			awrapper.red = appDelegate.sred;
			awrapper.green = appDelegate.sgreen;
			awrapper.blue = appDelegate.sblue;	
			CGPoint endpoint = [[[strokes objectAtIndex:e] lastObject] point];
			if(endpoint.x == prevpoint.x && endpoint.y == prevpoint.y) {
				awrapper.point = point;
				[[strokes objectAtIndex:e] addObject:awrapper];
				[awrapper release];
				break;
			}
		}
	}
	[alltouches release];
	[self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
}

// function borrowed from iphonedevbook.com, chapter 11
- (NSString *)csdataFilePath {
	PainterAppDelegate *appDelegate = (PainterAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:csFilename];
}

- (IBAction)clearCanvas:(id)sender {
	[strokes removeAllObjects];
	[savestrokes removeAllObjects];
	[self setNeedsDisplay];
}

- (float)getNumbersFromTextFields:(NSString *)textField {
	NSScanner *scanner = [NSScanner scannerWithString:textField];
	float rtn;
	if([scanner scanFloat:&rtn]) { // valid float number
		return rtn;
	}
	return 0;
}

- (IBAction)saveCanvas:(id)sender {
	for(int i = 0; i < [strokes count]; i++){
		NSMutableArray *savestrokearray = [[NSMutableArray alloc]init];
		for(int j = 0; j < [[strokes objectAtIndex:i] count]; j++){
			NSMutableArray *datasavepoint = [[NSMutableArray alloc]init];
			NSString *savethickness = [[NSString alloc] initWithFormat:@"%.2f", [[[strokes objectAtIndex:i] objectAtIndex:j] thickness]];
			NSString *savealpha = [[NSString alloc] initWithFormat:@"%.2f", [[[strokes objectAtIndex:i] objectAtIndex:j] alpha]];
			NSString *savered = [[NSString alloc] initWithFormat:@"%.2f", [[[strokes objectAtIndex:i] objectAtIndex:j] red]];
			NSString *savegreen = [[NSString alloc] initWithFormat:@"%.2f", [[[strokes objectAtIndex:i] objectAtIndex:j] green]];
			NSString *saveblue = [[NSString alloc] initWithFormat:@"%.2f", [[[strokes objectAtIndex:i] objectAtIndex:j] blue]];
			NSString *savepointx = [[NSString alloc] initWithFormat:@"%.2f", [[[strokes objectAtIndex:i] objectAtIndex:j] point].x];
			NSString *savepointy = [[NSString alloc] initWithFormat:@"%.2f", [[[strokes objectAtIndex:i] objectAtIndex:j] point].y];
			[datasavepoint addObject:savethickness];
			[datasavepoint addObject:savealpha];
			[datasavepoint addObject:savered];
			[datasavepoint addObject:savegreen];
			[datasavepoint addObject:saveblue];
			[datasavepoint addObject:savepointx];
			[datasavepoint addObject:savepointy];
			[savestrokearray addObject:datasavepoint];
			[datasavepoint release];
		}
		[savestrokes addObject:savestrokearray];
		[savestrokearray release];
	}
	[savestrokes writeToFile:[self csdataFilePath] atomically:YES];
}

- (IBAction)loadCanvas:(id)sender {
	[strokes removeAllObjects];
	[savestrokes removeAllObjects];
	NSArray *loadpoints = [[NSMutableArray alloc] initWithContentsOfFile:[self csdataFilePath]];
		
	for(int i = 0; i < [loadpoints count]; i++){
		NSMutableArray *loadstrokearray = [[NSMutableArray alloc] init];
		for(int j = 0; j < [[loadpoints objectAtIndex:i] count]; j++){
			strokeWrapper *awrapper = [[strokeWrapper alloc] init];
			awrapper.thickness = [self getNumbersFromTextFields:[[[loadpoints objectAtIndex:i] objectAtIndex:j] objectAtIndex:0]];
			awrapper.alpha = [self getNumbersFromTextFields:[[[loadpoints objectAtIndex:i] objectAtIndex:j] objectAtIndex:1]];
			awrapper.red = [self getNumbersFromTextFields:[[[loadpoints objectAtIndex:i] objectAtIndex:j] objectAtIndex:2]];
			awrapper.green = [self getNumbersFromTextFields:[[[loadpoints objectAtIndex:i] objectAtIndex:j] objectAtIndex:3]];
			awrapper.blue = [self getNumbersFromTextFields:[[[loadpoints objectAtIndex:i] objectAtIndex:j] objectAtIndex:4]];
			CGPoint point;
			point.x = [self getNumbersFromTextFields:[[[loadpoints objectAtIndex:i] objectAtIndex:j] objectAtIndex:5]];
			point.y = [self getNumbersFromTextFields:[[[loadpoints objectAtIndex:i] objectAtIndex:j] objectAtIndex:6]];
			awrapper.point = point;
			[loadstrokearray addObject:awrapper];
			[awrapper release];
		}
		[strokes addObject:loadstrokearray];
		[loadstrokearray release];
	}
	[loadpoints release];
	[self setNeedsDisplay];
}

- (void)dealloc {
	[strokes release];
	[savestrokes release];
    [super dealloc];
}


@end
