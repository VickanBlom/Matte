//
//  NumberView.m
//  DeutschMath
//
//  Created by Fredrik Carlsson on 6/18/13.
//  Copyright (c) 2013 appbyran. All rights reserved.
//

#import "NumberView.h"

#define CIRCLE @"circle"

@implementation NumberView
{
    id<NumberViewDelegate> nvDelegate;
    NSNumber* number;
    
    UILabel* label;
    UIButton* button;
    UIImageView* circle;
}

static CGSize frameSize;
+ (void) setFrameSize:(CGSize)newSize {
    frameSize = newSize;
}


+ (id)newWithNumber:(NSNumber*)num isAnswer:(BOOL)isAnswer delegate:(id<NumberViewDelegate>)del {
    return [[NumberView alloc] initWithNumber:num isAnswer:isAnswer delegate:del];
}

- (id)initWithNumber:(NSNumber*)num isAnswer:(BOOL)isAnswer delegate:(id<NumberViewDelegate>)del {
    
    CGRect frame = CGRectMake(0, 0, frameSize.width, frameSize.height);
    self = [super initWithFrame:frame];
    if ( self ) {
        self.backgroundColor = [UIColor clearColor];
        nvDelegate = del;
        number = num;
        
        label = [[UILabel alloc] initWithFrame:frame];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [number stringValue];
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
        
        circle = [[UIImageView alloc] initWithFrame:frame];
        circle.image = [UIImage imageNamed:CIRCLE];
        circle.hidden = YES;
        [self addSubview:circle];
        
        if ( !isAnswer ) {
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = frame;
            button.backgroundColor = [UIColor clearColor];
            [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
    }
    return self;
}

-(NSNumber*)number {
    return number;
}

-(void)deselect {
    circle.hidden = YES;
}

- (void)buttonPressed:(id)sender {
    
    BOOL selecting = circle.hidden;
    circle.hidden = !selecting;
    [nvDelegate number:number wasSelected:selecting];
}

-(void)fade {
    if ( button ) {
        [button removeFromSuperview];
    }
    else {
        circle.hidden = NO;
    }
    [UIView animateWithDuration:.4 animations:^(void){self.alpha=0.4;}];
}

@end
