//
//  FirstUIView.h
//  Painter
//
//  Created by Class Account on 2/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FirstUIView : UIView {
	NSMutableArray *people;
	NSMutableArray *agents;
	NSMutableArray *deathStrokes;
	NSMutableArray *dyingStrokes;
	NSMutableArray *savepoints;
	NSTimer *gametimer;
	BOOL pickedup;
	BOOL gameover;
	int populationCount; // displayed by healthyLabel
	int populationTotalCount;
	int populationInitialCount; // total population but does not change
	int agentCount;
	int agentTotalCount; // displayed by agentsLabel
	int infectedCount; // displayed by infectedLabel
	int deceasedCount; // displayed by deceasedLabel
	int peopleSpeed;
	int agentSpeed;
	int agentMaxInfected;
	int soulsHarvested;
	int soulQuota;
	UILabel *healthyLabel;
	UILabel *infectLabel;
	UILabel *deceasedLabel;
	UILabel *agentsLabel;
	UILabel *soulsHarvestedLabel;
	UILabel *soulsNeeded;
	UILabel *gameOverLabel;
	CGFloat step;
}
@property (nonatomic, retain) NSMutableArray *people;
@property (nonatomic, retain) NSMutableArray *agents;
@property (nonatomic, retain) NSMutableArray *deathStrokes;
@property (nonatomic, retain) NSMutableArray *dyingStrokes;
@property (nonatomic, retain) NSMutableArray *savepoints;
@property (nonatomic, retain) NSTimer *gametimer;
@property (nonatomic, retain) IBOutlet UILabel *healthyLabel;
@property (nonatomic, retain) IBOutlet UILabel *infectLabel;
@property (nonatomic, retain) IBOutlet UILabel *deceasedLabel;
@property (nonatomic, retain) IBOutlet UILabel *agentsLabel;
@property (nonatomic, retain) IBOutlet UILabel *soulsHarvestedLabel;
@property (nonatomic, retain) IBOutlet UILabel *soulsNeeded;
@property (nonatomic, retain) IBOutlet UILabel *gameOverLabel;
@property BOOL pickedup;
@property BOOL gameover;
@property int populationCount;
@property int populationTotalCount;
@property int populationInitialCount;
@property int agentCount;
@property int agentTotalCount;
@property int infectedCount;
@property int deceasedCount;
@property int peopleSpeed;
@property int agentSpeed;
@property int agentMaxInfected;
@property int soulsHarvested;
@property int soulQuota;
@property CGFloat step;
- (IBAction)clearCanvas:(id)sender;
- (IBAction)saveCanvas:(id)sender;
- (IBAction)loadCanvas:(id)sender;
- (float)getNumbersFromTextFields:(NSString *)textField;
- (void)initializeTimer;
- (void)drawMap;
- (void)drawPeople;
- (void)drawAgents;
- (void)drawHero;
- (void)drawDeathStrokes;
- (void)drawDyingStrokes;
- (void)populate;
- (void)addPerson;
- (void)summonAll;
- (void)summonOne;
- (void)elapseTime;

// gameplay functions
- (void)movePeople;
- (void)moveAgents;
- (BOOL)collisionHeroAgent:(int)agentIndex; // detect if hero collides with this agent
- (BOOL)collisionAgentPerson:(int)agentIndex person:(int)personIndex; // detect if this agent collides with a person
- (void)infectPerson:(int)agentIndex person:(int)personIndex; // detect if this agent collides with a person
- (void)vanquishAgent:(int)agentIndex;
- (void)darkRite:(int)agentIndex;
- (void)drawWin;
- (void)drawLose;

// utility functions
- (int)randomIntBetween:(int)min andMax:(int)max;
- (float)calculateEuclideanDistance:(CGPoint)point1 SecondPoint:(CGPoint)point2;
- (CGPoint)determineNextAgentLocation:(int)agentIndex;

@end
