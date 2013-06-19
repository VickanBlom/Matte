//
//  FootballVC.h
//  DeutschMath
//
//  Created by Fredrik Carlsson on 6/17/13.
//  Copyright (c) 2013 appbyran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NumberViewDelegate.h"
#import <QuartzCore/QuartzCore.h>


@interface FootballVC : UIViewController
<NumberViewDelegate>


@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIView *answerView;
@property (weak, nonatomic) IBOutlet UIView *partialView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (IBAction)buttonPressed:(id)sender;

@end
