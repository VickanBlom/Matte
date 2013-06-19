//
//  NumberView.h
//  DeutschMath
//
//  Created by Fredrik Carlsson on 6/18/13.
//  Copyright (c) 2013 appbyran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NumberViewDelegate.h"

@interface NumberView : UIView


+ (void) setFrameSize:(CGSize)newSize;
+ (id)newWithNumber:(NSNumber*)num isAnswer:(BOOL)isAnswer delegate:(id<NumberViewDelegate>)del;
- (id)initWithNumber:(NSNumber*)num isAnswer:(BOOL)isAnswer delegate:(id<NumberViewDelegate>)del;
- (void)fade;
-(NSNumber*)number;
-(void)deselect;

@end
