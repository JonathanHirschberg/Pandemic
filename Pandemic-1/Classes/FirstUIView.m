//
//  FirstUIView.m
//  Painter
//
//  Created by Class Account on 2/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PainterAppDelegate.h"
#import "FirstUIView.h"
#import "Wrapper.h"
#import "strokeWrapper.h"
#import "agentWrapper.h"
#import "dyingStrokeWrapper.h"
#define cdFilename @"dotscanvasdata.plist"

@implementation FirstUIView
@synthesize people;
@synthesize agents;
@synthesize dyingStrokes;
@synthesize deathStrokes;
@synthesize savepoints;
@synthesize pickedup;
@synthesize populationCount; // number of healthy people on the screen: should stay at 80 unless not enough healthy people total
@synthesize populationTotalCount; // number of healthy people total in the simulation.  goes down only when you have to add a new person to the screen in order to get a populationCount of 80.
@synthesize populationInitialCount; // starting population count, does not change
@synthesize agentCount; // number of agents on screen.  goes down when an agent dies or performs the dark rite.
@synthesize agentTotalCount; // number of agents total in the simulation.  goes down only when an agent gets replaced after dying.
@synthesize infectedCount; // increases when a dark agent infects someone.
@synthesize deceasedCount; // increases when a person is killed or his soul is stolen.
@synthesize soulsHarvested; // increases when a person's soul is stolen.
@synthesize gametimer;
@synthesize peopleSpeed;
@synthesize agentSpeed;
@synthesize agentMaxInfected;
@synthesize healthyLabel;
@synthesize infectLabel;
@synthesize deceasedLabel;
@synthesize agentsLabel;
@synthesize soulsHarvestedLabel;
@synthesize soulsNeeded;
@synthesize gameOverLabel;
@synthesize gameover;
@synthesize step;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void) populate {
	people = [[NSMutableArray alloc] init];
	populationInitialCount = 256;
	populationCount = 80;
	populationTotalCount = populationInitialCount-populationCount;
//	NSLog([[NSString alloc] initWithFormat:@"populationTotalCount %d", populationTotalCount]);
//	NSLog([[NSString alloc] initWithFormat:@"populationCount %d", populationCount]);
//	NSLog([[NSString alloc] initWithFormat:@"populationInitialCount %d", populationInitialCount]);
	peopleSpeed = 1;
	for(int i = 0; i < populationCount; i++) {
		Wrapper *awrapper = [[Wrapper alloc] init];
		awrapper.xradius = 7;
		awrapper.yradius = 7;
		awrapper.alpha = 1.0;
		awrapper.red = 1.0;
		awrapper.green = 1.0;
		awrapper.blue = 1.0;
		CGPoint point;
		point.x = arc4random() % (int)self.bounds.size.width;
		point.y = arc4random() % (int)self.bounds.size.height;
		awrapper.point = point;
		[people addObject:awrapper];
		[awrapper release];		
	}
}

- (void) addPerson {
	populationCount++;
	populationTotalCount--;

	Wrapper *awrapper = [[Wrapper alloc] init];
	awrapper.xradius = 7;
	awrapper.yradius = 7;
	awrapper.alpha = 1.0;
	awrapper.red = 1.0;
	awrapper.green = 1.0;
	awrapper.blue = 1.0;
	CGPoint point;
	point.x = arc4random() % (int)self.bounds.size.width;
	point.y = arc4random() % (int)self.bounds.size.height;
	awrapper.point = point;
	[people addObject:awrapper];
	[awrapper release];
}

- (void) summonAll {
	agents = [[NSMutableArray alloc] init];
	agentCount = 5;
	agentTotalCount = 50;//20;
	agentSpeed = 2;
	agentMaxInfected = 5;
	for(int i = 0; i < agentCount; i++) {
		agentWrapper *awrapper = [[agentWrapper alloc] init];
		awrapper.xradius = 15;
		awrapper.yradius = 15;
		awrapper.alpha = 1.0;
		awrapper.red = 0.5;
		awrapper.green = 0.0;
		awrapper.blue = 0.0;
		CGPoint point;
		point.x = arc4random() % (int)self.bounds.size.width;
		point.y = arc4random() % (int)self.bounds.size.height;
		awrapper.point = point;
		awrapper.infected = [[NSMutableArray alloc] init];
		[agents addObject:awrapper];
		[awrapper release];		
	}
}

- (void) summonOne {
	agentWrapper *awrapper = [[agentWrapper alloc] init];
	awrapper.xradius = 15;
	awrapper.yradius = 15;
	awrapper.alpha = 1.0;
	awrapper.red = 0.5;
	awrapper.green = 0.0;
	awrapper.blue = 0.0;
	CGPoint point;
	point.x = arc4random() % (int)self.bounds.size.width;
	point.y = arc4random() % (int)self.bounds.size.height;
	awrapper.point = point;
	awrapper.infected = [[NSMutableArray alloc] init];
	[agents addObject:awrapper];
	[awrapper release];		
}

- (void) initializeTimer { // from http://stackoverflow.com/questions/1116817/do-cocoa-applications-have-a-main-loop/1116839
	const float framerate = 20;
	const float frequency = 1.0f/framerate;
	gametimer = [NSTimer scheduledTimerWithTimeInterval:frequency 
				target:self selector:@selector(elapseTime) 
				userInfo:nil repeats:YES];
}

- (void) awakeFromNib {
	[self initializeTimer];
	[self populate];
	[self summonAll];
	deathStrokes = [[NSMutableArray alloc] init];
	dyingStrokes = [[NSMutableArray alloc] init];
	pickedup = FALSE;
	gameover = FALSE;
	savepoints = [[NSMutableArray alloc] init];	
	deceasedCount = 0;
	infectedCount = 0;
	soulsHarvested = 0;
	soulQuota = 128;
	step = 0.1;
}

- (void) elapseTime {
	if(gameover == FALSE) {
		[self movePeople];
		[self moveAgents];
	}
}

- (void)drawMap {
	PainterAppDelegate *appDelegate = (PainterAppDelegate *)[[UIApplication sharedApplication] delegate];
	CGImageRef imageRef = [[UIImage imageNamed:@"city.bmp"] CGImage];
	CGContextDrawImage(appDelegate.contextRef, CGRectMake(0, 0, (int)self.bounds.size.width, (int)self.bounds.size.height), imageRef);
}

- (void)drawHero {
	PainterAppDelegate *appDelegate = (PainterAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.contextRef = UIGraphicsGetCurrentContext();
	CGContextSetRGBFillColor(appDelegate.contextRef, appDelegate.hero.red, appDelegate.hero.green, 
							 appDelegate.hero.blue, appDelegate.hero.alpha);
	CGContextFillEllipseInRect(appDelegate.contextRef, CGRectMake(appDelegate.hero.point.x - (appDelegate.hero.xradius/2), appDelegate.hero.point.y - (appDelegate.hero.yradius/2), appDelegate.hero.xradius,
																  appDelegate.hero.yradius));
	CGContextStrokeEllipseInRect(appDelegate.contextRef, CGRectMake(appDelegate.hero.point.x - (appDelegate.hero.xradius/2), appDelegate.hero.point.y - (appDelegate.hero.yradius/2), appDelegate.hero.xradius,
																	appDelegate.hero.yradius));
}

- (void)drawPeople {
	PainterAppDelegate *appDelegate = (PainterAppDelegate *)[[UIApplication sharedApplication] delegate];
	for(int i = 0; i < [people count]; i++){
		CGPoint point = [[people objectAtIndex:i] point];
		appDelegate.contextRef = UIGraphicsGetCurrentContext();
		CGContextSetRGBFillColor(appDelegate.contextRef, [[people objectAtIndex:i] red], [[people objectAtIndex:i] green], 
								 [[people objectAtIndex:i] blue], [[people objectAtIndex:i] alpha]);
		CGContextFillEllipseInRect(appDelegate.contextRef, CGRectMake(point.x, point.y, [[people objectAtIndex:i] xradius],
																	  [[people objectAtIndex:i] yradius]));
		CGContextStrokeEllipseInRect(appDelegate.contextRef, CGRectMake(point.x, point.y, [[people objectAtIndex:i] xradius],
																		[[people objectAtIndex:i] yradius]));
	}	
}

- (void)drawAgents {
	PainterAppDelegate *appDelegate = (PainterAppDelegate *)[[UIApplication sharedApplication] delegate];
	for(int i = 0; i < [agents count]; i++){
		CGPoint point = [[agents objectAtIndex:i] point];
		appDelegate.contextRef = UIGraphicsGetCurrentContext();
		CGContextSetRGBFillColor(appDelegate.contextRef, [[agents objectAtIndex:i] red], [[agents objectAtIndex:i] green], 
								 [[agents objectAtIndex:i] blue], [[agents objectAtIndex:i] alpha]);
		CGContextFillEllipseInRect(appDelegate.contextRef, CGRectMake(point.x, point.y, [[agents objectAtIndex:i] xradius],
																	  [[agents objectAtIndex:i] yradius]));
		CGContextStrokeEllipseInRect(appDelegate.contextRef, CGRectMake(point.x, point.y, [[agents objectAtIndex:i] xradius],
																		[[agents objectAtIndex:i] yradius]));
		
		for(int j = 0; j < [[[agents objectAtIndex:i] infected] count]; j++){
			CGPoint point = [[[[agents objectAtIndex:i] infected] objectAtIndex:j] point];
			appDelegate.contextRef = UIGraphicsGetCurrentContext();
//			NSLog(@"got this far");
			CGContextSetRGBFillColor(appDelegate.contextRef, [[[[agents objectAtIndex:i] infected] objectAtIndex:j] red], [[[[agents objectAtIndex:i] infected] objectAtIndex:j] green], 
									 [[[[agents objectAtIndex:i] infected] objectAtIndex:j] blue], [[[[agents objectAtIndex:i] infected] objectAtIndex:j] alpha]);
			CGContextFillEllipseInRect(appDelegate.contextRef, CGRectMake(point.x, point.y, [[[[agents objectAtIndex:i] infected] objectAtIndex:j] xradius],
																		  [[[[agents objectAtIndex:i] infected] objectAtIndex:j] yradius]));
			CGContextStrokeEllipseInRect(appDelegate.contextRef, CGRectMake(point.x, point.y, [[[[agents objectAtIndex:i] infected] objectAtIndex:j] xradius],
																			[[[[agents objectAtIndex:i] infected] objectAtIndex:j] yradius]));
		}	
	}	
}

- (void)drawDyingStrokes {
	PainterAppDelegate *appDelegate = (PainterAppDelegate *)[[UIApplication sharedApplication] delegate];
	//	NSLog([[NSString alloc] initWithFormat:@"Points count: %d", [strokes count]]);
	appDelegate.contextRef = UIGraphicsGetCurrentContext();
	for(int i = 0; i < [dyingStrokes count]; i++){
		NSMutableArray *deathStroke = [[NSMutableArray alloc] initWithArray:[[dyingStrokes objectAtIndex:i] stroke]];
		if([[dyingStrokes objectAtIndex:i] red] > 0.0 && [[dyingStrokes objectAtIndex:i] green] > 0.0 && [[dyingStrokes objectAtIndex:i] blue] > 0.0 && [[dyingStrokes objectAtIndex:i] alpha] < 1.0) {
//			NSLog([[NSString alloc] initWithFormat:@"drawing dying strokes %f", rgb]);
			CGContextSetRGBStrokeColor(appDelegate.contextRef, [[dyingStrokes objectAtIndex:i] red], 
									   [[dyingStrokes objectAtIndex:i] green], [[dyingStrokes objectAtIndex:i] blue],
									   [[dyingStrokes objectAtIndex:i] alpha]);
			CGContextSetLineWidth(appDelegate.contextRef, [[[[dyingStrokes objectAtIndex:i] stroke] objectAtIndex:0] xradius]);
			CGPoint startpoint = [[[[dyingStrokes objectAtIndex:i] stroke] objectAtIndex:0] point];
			CGContextMoveToPoint(appDelegate.contextRef, startpoint.x, startpoint.y);
		
//			NSLog(@"I made it this far");
			for(int j = 0; j < [[[dyingStrokes objectAtIndex:i] stroke] count]; j++){
				// Drawing code
				CGContextSetRGBStrokeColor(appDelegate.contextRef, [[dyingStrokes objectAtIndex:i] red], 
										   [[dyingStrokes objectAtIndex:i] green], [[dyingStrokes objectAtIndex:i] blue],
										   [[dyingStrokes objectAtIndex:i] alpha]);
				CGContextSetLineWidth(appDelegate.contextRef, [[[[dyingStrokes objectAtIndex:i] stroke] objectAtIndex:j] xradius]);
				CGPoint point = [[[[dyingStrokes objectAtIndex:i] stroke] objectAtIndex:j] point];
				CGContextAddLineToPoint(appDelegate.contextRef, point.x, point.y);
				//			NSLog(@"Drawing stuff");
			
				//			NSLog([[NSString alloc] initWithFormat:@"Point Coordinates: %d, %d", point.x, point.y]);
			}
			CGContextStrokePath(appDelegate.contextRef);
			dyingStrokeWrapper *dsw = [[dyingStrokeWrapper alloc] init];
			dsw.alpha = [[dyingStrokes objectAtIndex:i] alpha] + step;
			dsw.red = [[dyingStrokes objectAtIndex:i] red] - step;
			dsw.green = [[dyingStrokes objectAtIndex:i] green] - step;
			dsw.blue = [[dyingStrokes objectAtIndex:i] blue] - step;
			dsw.stroke = [[NSMutableArray alloc] initWithArray:deathStroke];
			[dyingStrokes removeObjectAtIndex:i];
			[dyingStrokes addObject:dsw];
			[dsw release];
		}
		else {
//			NSLog(@"I removed the dying stroke and added the death stroke");
//			NSLog([[NSString alloc] initWithFormat:@"[dyingStrokes count] = %d", [dyingStrokes count]]);
			[dyingStrokes removeObjectAtIndex:i];
			[deathStrokes addObject:deathStroke];
		}
	}

//	[dyingStrokes removeAllObjects];
}

- (void)drawDeathStrokes {
	PainterAppDelegate *appDelegate = (PainterAppDelegate *)[[UIApplication sharedApplication] delegate];
	//	NSLog([[NSString alloc] initWithFormat:@"Points count: %d", [strokes count]]);
	appDelegate.contextRef = UIGraphicsGetCurrentContext();
//	NSLog(@"made it this far");
	for(int i = 0; i < [deathStrokes count]; i++){
		CGContextSetRGBStrokeColor(appDelegate.contextRef, [[[deathStrokes objectAtIndex:i] objectAtIndex:0] red], 
								   [[[deathStrokes objectAtIndex:i] objectAtIndex:0] green], 
								   [[[deathStrokes objectAtIndex:i] objectAtIndex:0] blue], 
								   [[[deathStrokes objectAtIndex:i] objectAtIndex:0] alpha]);
		CGContextSetLineWidth(appDelegate.contextRef, [[[deathStrokes objectAtIndex:i] objectAtIndex:0] xradius]);
		CGPoint startpoint = [[[deathStrokes objectAtIndex:i] objectAtIndex:0] point];
		CGContextMoveToPoint(appDelegate.contextRef, startpoint.x, startpoint.y);
		for(int j = 0; j < [[deathStrokes objectAtIndex:i] count]; j++){
			// Drawing code
			CGContextSetRGBStrokeColor(appDelegate.contextRef, [[[deathStrokes objectAtIndex:i] objectAtIndex:j] red], 
									   [[[deathStrokes objectAtIndex:i] objectAtIndex:j] green],
									   [[[deathStrokes objectAtIndex:i] objectAtIndex:j] blue],
									   [[[deathStrokes objectAtIndex:i] objectAtIndex:j] alpha]);
			CGContextSetLineWidth(appDelegate.contextRef, [[[deathStrokes objectAtIndex:i] objectAtIndex:j] xradius]);
			CGPoint point = [[[deathStrokes objectAtIndex:i] objectAtIndex:j] point];
			CGContextAddLineToPoint(appDelegate.contextRef, point.x, point.y);
			//			NSLog(@"Drawing stuff");
			
			//			NSLog([[NSString alloc] initWithFormat:@"Point Coordinates: %d, %d", point.x, point.y]);
		}
		CGContextStrokePath(appDelegate.contextRef);
	}
}

- (void)drawLose {
	gameOverLabel.textColor = [UIColor redColor];
	gameOverLabel.backgroundColor = [UIColor blackColor];
	gameOverLabel.text = @"You Lose!";
}

- (void)drawWin {
	gameOverLabel.textColor = [UIColor greenColor];
	gameOverLabel.backgroundColor = [UIColor blackColor];
	gameOverLabel.text = @"You Win!";
}

- (void)drawRect:(CGRect)rect {
	[self drawMap];
	[self drawPeople];
	[self drawAgents];
	[self drawHero];
	[self drawDeathStrokes];
	[self drawDyingStrokes];
	int healthYellowThreshold = (int)(populationInitialCount*0.5);
	int healthRedThreshold = (int)(populationInitialCount*0.25);
	int soulsYellowThreshold = (int)(soulQuota*0.5);
	int soulsRedThreshold = (int)(soulQuota*0.75);
	
	if(healthyLabel.textColor != [UIColor yellowColor] && (populationTotalCount+populationCount) <= healthYellowThreshold && (populationTotalCount+populationCount) > healthRedThreshold) {
		healthyLabel.textColor = [UIColor yellowColor];
	}
	if(healthyLabel.textColor != [UIColor redColor] && (populationTotalCount+populationCount) <= healthRedThreshold) {
		healthyLabel.textColor = [UIColor redColor];
	}
	healthyLabel.text = [[NSString alloc] initWithFormat:@"%d", populationTotalCount + populationCount];
	infectLabel.text = [[NSString alloc] initWithFormat:@"%d", infectedCount];
	deceasedLabel.text = [[NSString alloc] initWithFormat:@"%d", deceasedCount];
	agentsLabel.text = [[NSString alloc] initWithFormat:@"%d", agentTotalCount];
	if(soulsHarvestedLabel.textColor != [UIColor yellowColor] && soulsHarvested >= soulsYellowThreshold && soulsHarvested < soulsRedThreshold) {
		soulsHarvestedLabel.textColor = [UIColor yellowColor];
	}
	if(soulsHarvestedLabel.textColor != [UIColor redColor] && soulsHarvested >= soulsRedThreshold) {
		soulsHarvestedLabel.textColor = [UIColor redColor];
	}
	soulsHarvestedLabel.text = [[NSString alloc] initWithFormat:@"%d/%d", soulsHarvested, soulQuota];
	
	if((populationTotalCount+populationCount) == 0 || soulsHarvested >= soulQuota) {
		[self drawLose];
		gameover = TRUE;
	}
	if(agentTotalCount == 0) {
		[self drawWin];
		gameover = TRUE;
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	PainterAppDelegate *appDelegate = (PainterAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSArray *alltouches = [[NSArray alloc] initWithArray:[touches allObjects]];
	NSLog(@"How touching");
	for(int d = 0; d < [alltouches count]; d++) {
		CGPoint point = [[alltouches objectAtIndex:d] locationInView:self];
//		NSLog([[NSString alloc] initWithFormat:@"point.x: %f appDelegate.hero.point.x: %f", point.x, appDelegate.hero.point.x]);
//		NSLog([[NSString alloc] initWithFormat:@"point.y: %f appDelegate.hero.point.y: %f", point.y, appDelegate.hero.point.y]);
		if(point.x <= (appDelegate.hero.point.x + appDelegate.hero.xradius) && point.x >= appDelegate.hero.point.x &&
		   point.y <= (appDelegate.hero.point.y + appDelegate.hero.yradius) && point.y >= appDelegate.hero.point.y ) {
			appDelegate.hero.point = point;
			pickedup = TRUE;
			break;
		}
	}
	// test collision with agents
	for(int i = 0; i < [agents count]; i++) {
		if([self collisionHeroAgent:i]) {
			[self vanquishAgent:i];
			break;
		}
	}
	[self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	PainterAppDelegate *appDelegate = (PainterAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSArray *alltouches = [[NSArray alloc] initWithArray:[touches allObjects]];
	for(int d = 0; d < [alltouches count]; d++) {
		CGPoint point = [[alltouches objectAtIndex:d] locationInView:self];
//		NSLog([[NSString alloc] initWithFormat:@"point.x: %f appDelegate.hero.point.x: %f", point.x, appDelegate.hero.point.x]);
//		NSLog([[NSString alloc] initWithFormat:@"point.y: %f appDelegate.hero.point.y: %f", point.y, appDelegate.hero.point.y]);
		if(pickedup == TRUE) {
			appDelegate.hero.point = point;
		}
	}
	for(int i = 0; i < [agents count]; i++) {
		if([self collisionHeroAgent:i]) {
			[self vanquishAgent:i];
			break;
		}
	}
	[self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	pickedup = FALSE;
}

// borrowed from iphonedevbook.com, chapter 11
- (NSString *)cddataFilePath {
//	PainterAppDelegate *appDelegate = (PainterAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
//	NSLog(appDelegate.dotsFilename);
    return [documentsDirectory stringByAppendingPathComponent:cdFilename];
}

- (IBAction)clearCanvas:(id)sender {
	[people removeAllObjects];
	[savepoints removeAllObjects];
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
	for(int i = 0; i < [people count]; i++){
		NSMutableArray *datasavepoint = [[NSMutableArray alloc]init];
		NSString *savexradius = [[NSString alloc] initWithFormat:@"%.2f", [[people objectAtIndex:i] xradius]];
		NSString *saveyradius = [[NSString alloc] initWithFormat:@"%.2f", [[people objectAtIndex:i] yradius]];
		NSString *savealpha = [[NSString alloc] initWithFormat:@"%.2f", [[people objectAtIndex:i] alpha]];
		NSString *savered = [[NSString alloc] initWithFormat:@"%.2f", [[people objectAtIndex:i] red]];
		NSString *savegreen = [[NSString alloc] initWithFormat:@"%.2f", [[people objectAtIndex:i] green]];
		NSString *saveblue = [[NSString alloc] initWithFormat:@"%.2f", [[people objectAtIndex:i] blue]];
		NSString *savepointx = [[NSString alloc] initWithFormat:@"%.2f", [[people objectAtIndex:i] point].x];
		NSString *savepointy = [[NSString alloc] initWithFormat:@"%.2f", [[people objectAtIndex:i] point].y];
		[datasavepoint addObject:savexradius];
		[datasavepoint addObject:saveyradius];
		[datasavepoint addObject:savealpha];
		[datasavepoint addObject:savered];
		[datasavepoint addObject:savegreen];
		[datasavepoint addObject:saveblue];
		[datasavepoint addObject:savepointx];
		[datasavepoint addObject:savepointy];
		[savepoints addObject:datasavepoint];
		[datasavepoint release];
	}
//	NSLog([self cddataFilePath]);
	[savepoints writeToFile:[self cddataFilePath] atomically:YES];
}

- (IBAction)loadCanvas:(id)sender {
	[people removeAllObjects];
	[savepoints removeAllObjects];
	NSArray *loadpoints = [[NSMutableArray alloc] initWithContentsOfFile:[self cddataFilePath]];
	
	for(int i = 0; i < [loadpoints count]; i++){
//		NSLog(@"starting");
		Wrapper *awrapper = [[Wrapper alloc] init];
		awrapper.xradius = [self getNumbersFromTextFields:[[loadpoints objectAtIndex:i] objectAtIndex:0]];
		awrapper.yradius = [self getNumbersFromTextFields:[[loadpoints objectAtIndex:i] objectAtIndex:1]];
		awrapper.alpha = [self getNumbersFromTextFields:[[loadpoints objectAtIndex:i] objectAtIndex:2]];
		awrapper.red = [self getNumbersFromTextFields:[[loadpoints objectAtIndex:i] objectAtIndex:3]];
		awrapper.green = [self getNumbersFromTextFields:[[loadpoints objectAtIndex:i] objectAtIndex:4]];
		awrapper.blue = [self getNumbersFromTextFields:[[loadpoints objectAtIndex:i] objectAtIndex:5]];
		CGPoint point;
		point.x = [self getNumbersFromTextFields:[[loadpoints objectAtIndex:i] objectAtIndex:6]];
		point.y = [self getNumbersFromTextFields:[[loadpoints objectAtIndex:i] objectAtIndex:7]];
		awrapper.point = point;
		[people addObject:awrapper];
		[awrapper release];
	}
	[loadpoints release];
	[self setNeedsDisplay];
}

// from http://www.iphonedevsdk.com/forum/iphone-sdk-development/3400-button-create-random-image.html
- (int)randomIntBetween:(int)min andMax:(int)max {
	int range = max - min;
	int baseRand = arc4random() % range;
	int rtn = baseRand + min;
	return rtn;
}

- (float)calculateEuclideanDistance:(CGPoint)point1 SecondPoint:(CGPoint)point2 {
	float distx = point2.x - point1.x;
	float disty = point2.y - point1.y;
	return sqrt(pow(distx, 2) + pow(disty, 2));
}

- (CGPoint)determineNextAgentLocation:(int)agentIndex {
	float mindistance = 1000;
	float currentdistance = 0;
	int peopleIndex = 0;
	CGPoint point;
	if([people count] > 0) {
		for(int i = 0; i < [people count]; i++) {
			currentdistance = [self calculateEuclideanDistance:[[agents objectAtIndex:agentIndex] point] SecondPoint:[[people objectAtIndex:i] point]];
			if(currentdistance < mindistance) {
				mindistance = currentdistance;
				peopleIndex = i;
//				NSLog([[NSString alloc] initWithFormat:@"%f", mindistance]);
			}
		}
		float numsteps = mindistance/agentSpeed;
		if(numsteps < 1) { // too close, so just move right there
			point.x = [[people objectAtIndex:peopleIndex] point].x;
			point.y = [[people objectAtIndex:peopleIndex] point].y;
		}
		float distx = [[people objectAtIndex:peopleIndex] point].x - [[agents objectAtIndex:agentIndex] point].x;
		float disty = [[people objectAtIndex:peopleIndex] point].y - [[agents objectAtIndex:agentIndex] point].y;
		float stepx = distx/numsteps;
		float stepy = disty/numsteps;
		point.x = [[agents objectAtIndex:agentIndex] point].x + stepx;
		point.y = [[agents objectAtIndex:agentIndex] point].y + stepy;
	}
	else {
		point.x = [[agents objectAtIndex:agentIndex] point].x;
		point.y = [[agents objectAtIndex:agentIndex] point].y;
	}
	return point;
}

// gameplay functions
- (void)movePeople {
	for(int i = 0; i < [people count]; i++) {
//		NSLog(@"Moving");
		Wrapper *awrapper = [[Wrapper alloc] init];
		awrapper.xradius = [[people objectAtIndex:i] xradius];
		awrapper.yradius = [[people objectAtIndex:i] yradius];
		awrapper.alpha = [[people objectAtIndex:i] alpha];
		awrapper.red = [[people objectAtIndex:i] red];
		awrapper.green = [[people objectAtIndex:i] green];
		awrapper.blue = [[people objectAtIndex:i] blue];
		CGPoint point;

		int moveAmtx, moveAmty, rtnx, rtny;
//		BOOL isValid = FALSE;
//		while(!isValid) {
		moveAmtx = [self randomIntBetween:(-peopleSpeed) andMax:peopleSpeed+1];
		moveAmty = [self randomIntBetween:(-peopleSpeed) andMax:peopleSpeed+1];
		rtnx = [[people objectAtIndex:i] point].x + moveAmtx;
		rtny = [[people objectAtIndex:i] point].y + moveAmty;
//		NSLog([[NSString alloc] initWithFormat:@"newposx: %d", rtnx]);
//		NSLog([[NSString alloc] initWithFormat:@"newposy: %d", rtny]);			
//		NSLog([[NSString alloc] initWithFormat:@"boundx: %d", (int)self.bounds.size.width]);
//		NSLog([[NSString alloc] initWithFormat:@"boundy: %d", (int)self.bounds.size.height]);
		if(rtnx <= 0) {
			rtnx = 0;
		}
		if(rtnx >= (int)self.bounds.size.width) {
			rtnx = (int)self.bounds.size.width;
		}
		if(rtny <= 0) {
			rtny = 0;
		}
		if(rtny >= (int)self.bounds.size.height) {
			rtny = (int)self.bounds.size.height;
		}
//			if(rtnx >= 0 && rtnx <= (int)self.bounds.size.width && rtny >= 0 && rtny <= (int)self.bounds.size.height) {
//				isValid = TRUE;
//			}
//		}
		
		point.x = rtnx;
		point.y = rtny;
		awrapper.point = point;
		[people replaceObjectAtIndex:i withObject:awrapper];
		[awrapper release];
	}
	// infected movements
	for(int j = 0; j < [agents count]; j++) {
		for(int k = 0; k < [[[agents objectAtIndex:j] infected] count]; k++) {
			//		NSLog(@"Moving");
			Wrapper *awrapper = [[Wrapper alloc] init];
			awrapper.xradius = [[[[agents objectAtIndex:j] infected] objectAtIndex:k] xradius];
			awrapper.yradius = [[[[agents objectAtIndex:j] infected] objectAtIndex:k] yradius];
			awrapper.alpha = [[[[agents objectAtIndex:j] infected] objectAtIndex:k] alpha];
			awrapper.red = [[[[agents objectAtIndex:j] infected] objectAtIndex:k] red];
			awrapper.green = [[[[agents objectAtIndex:j] infected] objectAtIndex:k] green];
			awrapper.blue = [[[[agents objectAtIndex:j] infected] objectAtIndex:k] blue];
			CGPoint point;
		
			int moveAmtx, moveAmty, rtnx, rtny;
			moveAmtx = [self randomIntBetween:(-peopleSpeed) andMax:peopleSpeed+1];
			moveAmty = [self randomIntBetween:(-peopleSpeed) andMax:peopleSpeed+1];
			rtnx = [[[[agents objectAtIndex:j] infected] objectAtIndex:k] point].x + moveAmtx;
			rtny = [[[[agents objectAtIndex:j] infected] objectAtIndex:k] point].y + moveAmty;
			if(rtnx <= 0) {
				rtnx = 0;
			}
			if(rtnx >= (int)self.bounds.size.width) {
				rtnx = (int)self.bounds.size.width;
			}
			if(rtny <= 0) {
				rtny = 0;
			}
			if(rtny >= (int)self.bounds.size.height) {
				rtny = (int)self.bounds.size.height;
			}
		
			point.x = rtnx;
			point.y = rtny;
			awrapper.point = point;
			[[[agents objectAtIndex:j] infected] replaceObjectAtIndex:k withObject:awrapper];
			[awrapper release];
		}
	}
	[self setNeedsDisplay];
}

- (void)moveAgents {
	if([people count] > 0) {
		for(int i = 0; i < [agents count]; i++) {
			//		NSLog(@"Moving");
			agentWrapper *awrapper = [[agentWrapper alloc] init];
			awrapper.xradius = [[agents objectAtIndex:i] xradius];
			awrapper.yradius = [[agents objectAtIndex:i] yradius];
			awrapper.alpha = [[agents objectAtIndex:i] alpha];
			awrapper.red = [[agents objectAtIndex:i] red];
			awrapper.green = [[agents objectAtIndex:i] green];
			awrapper.blue = [[agents objectAtIndex:i] blue];
			awrapper.infected = [[agents objectAtIndex:i] infected];
			//		CGPoint point;
		
			//		int moveAmtx, moveAmty, rtnx, rtny;
			//		BOOL isValid = FALSE;
			//		while(!isValid) {
			//		moveAmtx = [self randomIntBetween:(-agentSpeed) andMax:agentSpeed+1];
			//		moveAmty = [self randomIntBetween:(-agentSpeed) andMax:agentSpeed+1];
			//		rtnx = [[agents objectAtIndex:i] point].x + moveAmtx;
			//		rtny = [[agents objectAtIndex:i] point].y + moveAmty;
			//		NSLog([[NSString alloc] initWithFormat:@"newposx: %d", rtnx]);
			//		NSLog([[NSString alloc] initWithFormat:@"newposy: %d", rtny]);			
			//		NSLog([[NSString alloc] initWithFormat:@"boundx: %d", (int)self.bounds.size.width]);
			//		NSLog([[NSString alloc] initWithFormat:@"boundy: %d", (int)self.bounds.size.height]);
	/*		if(rtnx <= 0) {
				rtnx = 0;
			 }
			 if(rtnx >= (int)self.bounds.size.width) {
				rtnx = (int)self.bounds.size.width;
			 }
			if(rtny <= 0) {
				rtny = 0;
			}
			if(rtny >= (int)self.bounds.size.height) {
				rtny = (int)self.bounds.size.height;
			}
	 */		//			if(rtnx >= 0 && rtnx <= (int)self.bounds.size.width && rtny >= 0 && rtny <= (int)self.bounds.size.height) {
			//				isValid = TRUE;
			//			}
			//		}
			
			//		point.x = rtnx;
			//		point.y = rtny;
			awrapper.point = [self determineNextAgentLocation:i];
			[agents replaceObjectAtIndex:i withObject:awrapper];
			[awrapper release];
			for(int j = 0; j < [people count]; j++) {
				if([self collisionAgentPerson:i person:j]) {
					[self infectPerson:i person:j];
				}
			}
		}
	}
	[self setNeedsDisplay];
}

- (BOOL)collisionHeroAgent:(int)agentIndex { // detect if hero collides with this agent
	PainterAppDelegate *appDelegate = (PainterAppDelegate *)[[UIApplication sharedApplication] delegate];
	if(appDelegate.hero.point.x + appDelegate.hero.xradius/2 >= [[agents objectAtIndex:agentIndex] point].x - [[agents objectAtIndex:agentIndex] xradius] &&
	   appDelegate.hero.point.x /*- appDelegate.hero.xradius*/ <= [[agents objectAtIndex:agentIndex] point].x + [[agents objectAtIndex:agentIndex] xradius] &&
	   appDelegate.hero.point.y + appDelegate.hero.yradius/2 >= [[agents objectAtIndex:agentIndex] point].y - [[agents objectAtIndex:agentIndex] yradius] &&
	   appDelegate.hero.point.y /*- appDelegate.hero.yradius*/ <= [[agents objectAtIndex:agentIndex] point].y + [[agents objectAtIndex:agentIndex] yradius]) {
		return TRUE;
	}
	return FALSE;
}

- (BOOL)collisionAgentPerson:(int)agentIndex person:(int)personIndex { // detect if this agent collides with a person
	if([[people objectAtIndex:personIndex] point].x + [[people objectAtIndex:personIndex] xradius]/2 >= [[agents objectAtIndex:agentIndex] point].x - [[agents objectAtIndex:agentIndex] xradius] &&
	   [[people objectAtIndex:personIndex] point].x <= [[agents objectAtIndex:agentIndex] point].x + [[agents objectAtIndex:agentIndex] xradius] &&
	   [[people objectAtIndex:personIndex] point].y + [[people objectAtIndex:personIndex] xradius]/2 >= [[agents objectAtIndex:agentIndex] point].y - [[agents objectAtIndex:agentIndex] yradius] &&	
	   [[people objectAtIndex:personIndex] point].y <= [[agents objectAtIndex:agentIndex] point].y + [[agents objectAtIndex:agentIndex] yradius]) {
		return TRUE;
	}
	return FALSE;
}

- (void)infectPerson:(int)agentIndex person:(int)personIndex { // detect if this agent collides with a person
	populationCount--;
	infectedCount++;
	Wrapper *awrapper = [[Wrapper alloc] init];
	awrapper.xradius = [[people objectAtIndex:personIndex] xradius];
	awrapper.yradius = [[people objectAtIndex:personIndex] yradius];
	awrapper.alpha = 1.0;
	awrapper.red = 0.5;
	awrapper.green = 0.0;
	awrapper.blue = 0.0;
	CGPoint point;
	point.x = [[agents objectAtIndex:agentIndex] point].x;
	point.y = [[agents objectAtIndex:agentIndex] point].y;
//	NSLog(@"infecting");
	awrapper.point = point;
	[people removeObjectAtIndex:personIndex];
	[[[agents objectAtIndex:agentIndex] infected] addObject:awrapper];
	[awrapper release];
	
	if(populationCount < 80 && populationTotalCount > 0) {
		[self addPerson];
	}
	
	if([[[agents objectAtIndex:agentIndex] infected] count] == agentMaxInfected) {
		[self darkRite:agentIndex];
	}
/*	if([people count] == 0) {
		for(int i = 0; i < [agents count]; i++) {
			if([[[agents objectAtIndex:i] infected] count] > 0) {
				[self darkRite:i];
			}
		}
	}*/
	[self setNeedsDisplay];
}

- (void)darkRite:(int)agentIndex {
	NSLog(@"performing dark rite");
	dyingStrokeWrapper *dsw = [[dyingStrokeWrapper alloc] init];
	dsw.alpha = 0.0;
	dsw.red = 1.0;
	dsw.green = 1.0;
	dsw.blue = 1.0;
	dsw.stroke = [[NSMutableArray alloc] init];
	for(int i = 0; i < [[[agents objectAtIndex:agentIndex] infected] count]; i++) {
//		infectedCount--;
//		populationCount--;
		deceasedCount++;
		soulsHarvested++;
		Wrapper *awrapper = [[Wrapper alloc] init];
		awrapper.xradius = [[[[agents objectAtIndex:agentIndex] infected] objectAtIndex:i] xradius];
		awrapper.yradius = [[[[agents objectAtIndex:agentIndex] infected] objectAtIndex:i] yradius];
		awrapper.alpha = 1.0;
		awrapper.red = 0.0;
		awrapper.green = 0.0;
		awrapper.blue = 0.0;
		CGPoint point;
		point.x = [[[[agents objectAtIndex:agentIndex] infected] objectAtIndex:i] point].x;
		point.y = [[[[agents objectAtIndex:agentIndex] infected] objectAtIndex:i] point].y;
		awrapper.point = point;
		[[[agents objectAtIndex:agentIndex] infected] removeObjectAtIndex:i];
		[dsw.stroke addObject:awrapper];
		[awrapper release];
	}
	NSLog(@"darkrite completed");
//	NSLog(@"infecting");
	[dyingStrokes addObject:dsw];
	[dsw release];
	
	if(agentTotalCount > 10) { // new rules: last 10 guys do not commit suicide
		agentTotalCount--;
		NSLog(@"dark rite removing");
		[agents removeObjectAtIndex:agentIndex];
		if(agentTotalCount >= agentCount) {
			[self summonOne];
		}
	}

	NSLog(@"dark rite removed");
//	[[[agents objectAtIndex:agentIndex] infected] removeObjectAtIndex:i];
}

- (void)vanquishAgent:(int)agentIndex {
	NSLog(@"vanquished");
	for(int i = 0; i < [[[agents objectAtIndex:agentIndex] infected] count]; i++) {
//		populationCount++;
//		infectedCount--;
//		populationCount--;
		deceasedCount++;
/*		// restore the infected people
		Wrapper *awrapper = [[Wrapper alloc] init];
		awrapper.xradius = [[[[agents objectAtIndex:agentIndex] infected] objectAtIndex:i] xradius];
		awrapper.yradius = [[[[agents objectAtIndex:agentIndex] infected] objectAtIndex:i] yradius];
		awrapper.alpha = 1.0;
		awrapper.red = 1.0;
		awrapper.green = 1.0;
		awrapper.blue = 1.0;
		CGPoint point;
		point.x = [[[[agents objectAtIndex:agentIndex] infected] objectAtIndex:i] point].x;
		point.y = [[[[agents objectAtIndex:agentIndex] infected] objectAtIndex:i] point].y;
		awrapper.point = point;
		[people addObject:awrapper];
		[awrapper release];		*/
	}
/*	if([people count] < 80 && populationTotalCount > 0) {
		[self addPerson];
	}
*/	
	agentTotalCount--;
	NSLog(@"vanquished removing");
	[agents removeObjectAtIndex:agentIndex];
	if(agentTotalCount >= agentCount) {
		[self summonOne];
	}
}

- (void)dealloc {
	[people release];
	[savepoints release];
    [super dealloc];
}


@end