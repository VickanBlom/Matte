//
//  NumberViewDelegate.h
//  DeutschMath
//
//  Created by Fredrik Carlsson on 6/18/13.
//  Copyright (c) 2013 appbyran. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NumberViewDelegate <NSObject>

-(void)number:(NSNumber*)num wasSelected:(BOOL)sel;

@end
