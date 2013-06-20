//
//  MachineVC.h
//  DeutschMath
//
//  Created by Fredrik Carlsson on 6/19/13.
//  Copyright (c) 2013 appbyran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MachineVC : UIViewController

@property (weak, nonatomic) IBOutlet UIView *tranView;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *operatorButton;
@property (weak, nonatomic) IBOutlet UIButton *multiplierButton;
@property (weak, nonatomic) IBOutlet UIButton *valueButton;

- (IBAction)buttonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *wandleLabel;
@property (weak, nonatomic) IBOutlet UILabel *inputValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *inputUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *outputUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *outputValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *multiplierLabel;
@property (weak, nonatomic) IBOutlet UIImageView *operatorImage;


@property (strong, nonatomic) IBOutlet UIView *keyboardView;
@property (weak, nonatomic) IBOutlet UIButton *key0;
@property (weak, nonatomic) IBOutlet UIButton *key1;
@property (weak, nonatomic) IBOutlet UIButton *key2;
@property (weak, nonatomic) IBOutlet UIButton *key3;
@property (weak, nonatomic) IBOutlet UIButton *key4;
@property (weak, nonatomic) IBOutlet UIButton *key5;
@property (weak, nonatomic) IBOutlet UIButton *key6;
@property (weak, nonatomic) IBOutlet UIButton *key7;
@property (weak, nonatomic) IBOutlet UIButton *key8;
@property (weak, nonatomic) IBOutlet UIButton *key9;
@property (weak, nonatomic) IBOutlet UIButton *keyBack;
@property (weak, nonatomic) IBOutlet UIButton *keyDot;
@property (weak, nonatomic) IBOutlet UIButton *keyDone;

- (IBAction)keyButtonPressed:(id)sender;


@end
