//
//  dyingStrokeWrapper.h
//  Painter
//
//  Created by Class Account on 2/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface dyingStrokeWrapper : NSObject {
	float alpha;
	float red;
	float green;
	float blue;
	NSMutableArray *stroke;
}
@property float alpha;
@property float red;
@property float green;
@property float blue;
@property (nonatomic, retain) NSMutableArray *stroke;

@end
