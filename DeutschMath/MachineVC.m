//
//  MachineVC.m
//  DeutschMath
//
//  Created by Fredrik Carlsson on 6/19/13.
//  Copyright (c) 2013 appbyran. All rights reserved.
//

#import "MachineVC.h"

#define SECOND @"sec"
#define MINUTE @"min"
#define HOUR   @"hr"

#define GRAM  @"g"
#define KILO  @"kg"
#define TON   @"ton"

#define CENT  @"cent"
#define EURO  @"€"

#define MILLIMETER @"mm"
#define METER      @"m"
#define KILOMETER  @"km"


typedef enum {
    ct_time,
    ct_mass,
    ct_money,
    ct_distance,
    ct_numCT
}CalcType;

@interface MachineVC ()

@end

@implementation MachineVC
{
    CalcType ct;
    int bottomIndex;
    BOOL convertUP;
    int multiplier;
    
    int answer;
    
    UIButton* coverButton;
}

+ (id)new {
    NSString* nibName = @"MachineView";
    return [[MachineVC alloc] initWithNibName:nibName bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect kf = _keyboardView.frame;
    kf.origin = CGPointMake(0, self.view.frame.size.height);
    _keyboardView.frame = kf;
    [self.view addSubview:_keyboardView];
//    _keyboardView.transform = CGAffineTransformMakeTranslation(0, self.view.frame.size.height);
    
//    CGRect vf = self.view.frame;
//    vf.size = CGSizeMake(vf.size.width, vf.size.height+kf.size.height);
//    self.view.frame = vf;
    
    [self reinitialize];
}

-(void) reinitialize {
    
    _outputValueLabel.text = @"";

    ct = (CalcType)arc4random_uniform( (u_int32_t)ct_numCT );
    convertUP = arc4random_uniform(2)==0;
    bottomIndex = [self newBottomIndex:ct];
    NSString* bottomUnit = [self unitForCalcType:ct unitIndex:bottomIndex];
    NSString* topUnit = [self unitForCalcType:ct unitIndex:bottomIndex+1];
    multiplier = [self multiplierForCalcType:ct];
    int topValue = (int)arc4random_uniform(200);
    int bottomValue = topValue * multiplier;
    answer = ( convertUP ? topValue : bottomValue );
    
    _inputUnitLabel.text = ( convertUP ? bottomUnit : topUnit );
    _outputUnitLabel.text = ( convertUP ? topUnit : bottomUnit );
    _multiplierLabel.text = [NSString stringWithFormat:@"%d",multiplier];
    _inputValueLabel.text = [NSString stringWithFormat:@"%d",(convertUP?bottomValue:topValue)];
    _outputValueLabel.text = @"";
    _outputValueLabel.textColor = [UIColor blackColor];
}


- (IBAction)buttonPressed:(id)sender {
    
    if ( sender == _backButton ) {
        return;
    }
    
    if ( sender == _doneButton ) {
        return;
    }
    
    if ( sender == _operatorButton ) {
        return;
    }
    
    if ( sender == _multiplierButton ) {
        return;
    }
    
    if ( sender == _valueButton ) {
        [self addCoverButton];
        [UIView animateWithDuration:.3 animations:^(void){
            _tranView.transform = CGAffineTransformMakeTranslation(0, -_keyboardView.frame.size.height);
            _keyboardView.transform = CGAffineTransformMakeTranslation(0, -_keyboardView.frame.size.height);
        }];
        return;
    }
}
- (IBAction)keyButtonPressed:(id)sender {
    
    NSString* currText = _outputValueLabel.text;
    
    if ( sender == _keyBack ) {
        if ( currText && currText.length>0 ) {
            currText = [currText substringToIndex:currText.length-1];
            _outputValueLabel.text = currText;
        }
        return;
    }
    
    if ( sender == _keyDot ) {
        return;
    }
    
    if ( sender == _keyDone ) {
        [self removeCoverButton];
        return;
    }
    
    // otherwise we have a number button
    UIButton* butt = (UIButton*)sender;
    int tag = butt.tag;
    currText = [currText stringByAppendingFormat:@"%d",tag];
    _outputValueLabel.text = currText;
}

-(void)addCoverButton {
    if ( !coverButton ) {
        coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        coverButton.autoresizingMask = self.view.autoresizingMask;
        coverButton.frame = _tranView.frame;
        coverButton.backgroundColor = [UIColor clearColor];
        [coverButton addTarget:self action:@selector(removeCoverButton) forControlEvents:UIControlEventTouchUpInside];
        [_tranView addSubview:coverButton];
    }
}

-(void)removeCoverButton {
    
    if ( coverButton ) {
        [coverButton removeFromSuperview];
        coverButton = nil;
    }
    [UIView animateWithDuration:0.3 animations:^(void){
        _tranView.transform = CGAffineTransformIdentity;
        _keyboardView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        [self validateAnswer];
    }];
}

-(void)validateAnswer {
    
    NSString* answerStr = _outputValueLabel.text;
    if ( !answerStr ) {
        return;
    }
    
    // remove any leading zeros
    while ( answerStr && answerStr.length>0 && [[answerStr substringToIndex:1] isEqualToString:@"0"] ) {
        answerStr = [answerStr substringFromIndex:1];
    }
    
    if ( answerStr.length == 0 ) {
        return;
    }
    
    if ( [answerStr isEqualToString:[NSString stringWithFormat:@"%d",answer]] ) {
        _outputValueLabel.textColor = [UIColor colorWithRed:.3 green:.7 blue:.3 alpha:1];
    }
    else {
        _outputValueLabel.textColor = [UIColor colorWithRed:.7 green:.3 blue:.7 alpha:1];
    }
}


#pragma mark - stuff for blah

-(int)newBottomIndex:(CalcType)caty {
    
    int rv = 0;
    switch (caty) {
        case ct_time:
            rv = (int)arc4random_uniform((u_int32_t)2);
            break;
        case ct_mass:
            rv = (int)arc4random_uniform((u_int32_t)2);
            break;
        case ct_money:
//            rv = (int)arc4random_uniform((u_int32_t)1);
            break;
        case ct_distance:
            rv = (int)arc4random_uniform((u_int32_t)2);
            break;
        default:
            break;
    }
    return rv;
}

-(NSString*)unitForCalcType:(CalcType)caty unitIndex:(int)unind {
    
    NSString* rv = @"";
    switch (caty) {
        case ct_time:
            rv = ( unind==0 ? SECOND : (unind==1 ? MINUTE : HOUR) );
            break;
        case ct_mass:
            rv = ( unind==0 ? GRAM : (unind==1 ? KILO : TON) );
            break;
        case ct_money:
            rv = ( unind==0 ? CENT : EURO );
            break;
        case ct_distance:
            rv = ( unind==0 ? MILLIMETER : (unind==1 ? METER : KILOMETER) );
            break;
        default:
            break;
    }
    return rv;
}

-(int)multiplierForCalcType:(CalcType)caty {
    
    int rv = 1;
    switch (caty) {
        case ct_time:
            rv = 60;
            break;
        case ct_mass:
            rv = 1000;
            break;
        case ct_money:
            rv = 100;
            break;
        case ct_distance:
            rv = 1000;
            break;
        default:
            break;
    }
    return rv;

}
@end
