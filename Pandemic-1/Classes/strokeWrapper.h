//
//  strokeWrapper.h
//  Painter
//
//  Created by Class Account on 2/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface strokeWrapper : NSObject {
	float thickness;
	float xradius;
	float yradius;
	float alpha;
	float red;
	float green;
	float blue;
	CGPoint point;	
}
@property float thickness;
@property float xradius;
@property float yradius;
@property float alpha;
@property float red;
@property float green;
@property float blue;
@property CGPoint point;
@end
