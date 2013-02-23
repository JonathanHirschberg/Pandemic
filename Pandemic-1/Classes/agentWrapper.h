//
//  agentWrapper.h
//  Painter
//
//  Created by Class Account on 2/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface agentWrapper : NSObject {
	float xradius;
	float yradius;
	float alpha;
	float red;
	float green;
	float blue;
	CGPoint point;
	NSMutableArray *infected;
}
@property float xradius;
@property float yradius;
@property float alpha;
@property float red;
@property float green;
@property float blue;
@property CGPoint point;
@property (nonatomic, retain) NSMutableArray *infected;

@end
