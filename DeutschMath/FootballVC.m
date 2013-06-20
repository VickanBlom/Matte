//
//  FootballVC.m
//  DeutschMath
//
//  Created by Fredrik Carlsson on 6/17/13.
//  Copyright (c) 2013 appbyran. All rights reserved.
//

#import "FootballVC.h"
#import "NumberView.h"

@interface FootballVC ()

@end

@implementation FootballVC
{
    NSMutableArray* answers;
    NSMutableArray* partials;
    
    CGSize answerSize;
    CGSize partialSize;
    
    NSNumber* chosen1;
    
    // for the clock
    CADisplayLink* clockLink;
    int numCorrect;
    NSDate* startDate;
}

int const minPossible = 10;
int const maxPossible = 100;

int const numAnswers = 9;
int const maxAnswerTries = 1000;
int const maxPartialTries = 100;

CGSize const numberFrameSize = {40,40};

+(id)new {
    [NumberView setFrameSize:numberFrameSize];
    return [[FootballVC alloc] initWithNibName:@"FootballView" bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    answerSize = _answerView.frame.size;
    partialSize = _partialView.frame.size;
    
    [self reinitialize];

}

- (void)reinitialize {
    [self reinitializeNumbers];
    [self reinitializeNumberViews];
    
    numCorrect = 0;
    if ( clockLink ) {
        [clockLink invalidate];
        clockLink = nil;
    }
    clockLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(timeIncrement)];
    [clockLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    startDate = [NSDate date];
    _timeLabel.text = @"0";
}

- (void)timeIncrement {
    
    NSDate* now = [NSDate date];
    float dt = (float)[now timeIntervalSinceDate:startDate];
    
    int mins = (int)dt/60;
    int secs = (int)dt - 60*mins;
    
    NSString* time = @"";
    if ( mins > 0 ) {
        time = [time stringByAppendingFormat:@"%d:",mins];
        if ( secs < 10 ) {
            time = [time stringByAppendingString:@"0"];
        }
    }
    time = [time stringByAppendingFormat:@"%d",secs];
    _timeLabel.text = time;
}

-(void)reinitializeNumberViews {
    
    NSArray* answerChildren = [_answerView subviews];
    for (int i=0; i<answerChildren.count; i++) {
        [(UIView*)[answerChildren objectAtIndex:i] removeFromSuperview];
    }
    NSArray* partialChildren = [_partialView subviews];
    for (int i=0; i<partialChildren.count; i++) {
        [(UIView*)[partialChildren objectAtIndex:i] removeFromSuperview];
    }
    
    CGPoint maxPt = CGPointMake(_answerView.frame.size.width - numberFrameSize.width, _answerView.frame.size.height - numberFrameSize.height);
    NSMutableArray* currXs = [NSMutableArray arrayWithCapacity:numAnswers];
    NSMutableArray* currYs = [NSMutableArray arrayWithCapacity:numAnswers];
    for (int i=0; i<answers.count; i++) {
        NumberView* nv = [NumberView newWithNumber:[answers objectAtIndex:i] isAnswer:YES delegate:self];
        [_answerView addSubview:nv];
        
        CGPoint trPt = [self newPositionWithMax:maxPt currXs:currXs currYs:currYs];
        [currXs addObject:[NSNumber numberWithFloat:trPt.x]];
        [currYs addObject:[NSNumber numberWithFloat:trPt.y]];
        nv.transform = CGAffineTransformMakeTranslation(trPt.x, trPt.y);
    }
    
    maxPt = CGPointMake(_partialView.frame.size.width - numberFrameSize.width,  _partialView.frame.size.height - numberFrameSize.height);
    currXs = [NSMutableArray arrayWithCapacity:2*numAnswers];
    currYs = [NSMutableArray arrayWithCapacity:2*numAnswers];
    for (int i=0; i<partials.count; i++) {
        NumberView* nv = [NumberView newWithNumber:[partials objectAtIndex:i] isAnswer:NO delegate:self];
        [_partialView addSubview:nv];
        
        CGPoint trPt = [self newPositionWithMax:maxPt currXs:currXs currYs:currYs];
        [currXs addObject:[NSNumber numberWithFloat:trPt.x]];
        [currYs addObject:[NSNumber numberWithFloat:trPt.y]];
        nv.transform = CGAffineTransformMakeTranslation(trPt.x, trPt.y);
    }
}

-(CGPoint)newPositionWithMax:(CGPoint)maxPt currXs:(NSArray*)currXs currYs:(NSArray*)currYs {
    
    float trX,trY;
    BOOL validPt = NO;
    for (int i=0; i<100 && !validPt; i++) {
        NSLog(@"try #%d",i);
        trX = (float)arc4random_uniform((u_int32_t)maxPt.x);
        trY = (float)arc4random_uniform((u_int32_t)maxPt.y);
        
        validPt = YES;
        for (int j=0; j<currXs.count; j++) {
            float currX = [[currXs objectAtIndex:j] floatValue];
            float currY = [[currYs objectAtIndex:j] floatValue];
            if ( fabsf(currX-trX)<numberFrameSize.width && fabsf(currY-trY)<numberFrameSize.height ) {
                validPt = NO;
                break;
            }
        }
    }
    return CGPointMake(trX, trY);
}

- (void)reinitializeNumbers {
    
    answers = [NSMutableArray arrayWithCapacity:numAnswers];
    partials = [NSMutableArray arrayWithCapacity:2*numAnswers];
    
    int numTries = 0;
    while ( answers.count<numAnswers && numTries<maxAnswerTries ) {
        numTries++;
        [self addNumberCombo];
    }

}

-(void)addNumberCombo {
    
    int newAnswer = minPossible+(int)arc4random_uniform( (u_int32_t)(maxPossible-minPossible) );
    
    // check to see if we already have this one
    for (int i=0; i<answers.count; i++) {
        if ( newAnswer == [[answers objectAtIndex:i] intValue] ) {
            return;
        }
    }
    
    // IOS BUG -- this next gets stuck in infinite loop
//    NSArray* asd = [NSArray array];
//    for (int i=0; i<asd.count-1; i++) {
//        NSLog(@"blaasdf");
//    }
    
    // check to see if we already have two partials that sum up to the new answer
    int numP = partials.count;
    int numA = answers.count;
    for (int i=0; i<numP-1; i++) {
        int p1 = [[partials objectAtIndex:i] intValue];
        for (int j=i; j<numP; j++) {
            int p2 = [[partials objectAtIndex:j] intValue];
            if ( newAnswer == p1 + p2 ) {
                return;
            }
        }
    }
    
    // ok, we now know we have a unique value, now we try to create valid partials
    int partial1, partial2;
    BOOL validPartial = NO;
    for (int i=0; i<maxPartialTries && !validPartial; i++) {
        
        validPartial = YES;
        partial1 = 1 + (int)arc4random_uniform( (u_int32_t)(newAnswer-1) );  // arc4 does not include upper bound
        partial2 = newAnswer - partial1;
        
        for (int j=0; j<numA; j++) {
            int prevAnswer = [[answers objectAtIndex:j] intValue];
            for (int k=0; k<numP; k++) {
                int prevPartial = [[partials objectAtIndex:k] intValue];
                
                // make sure we do not have multiple ways to make the same sum available
                if ( prevAnswer==prevPartial+partial1 || prevAnswer==prevPartial+partial2 || prevPartial==partial1 || prevPartial==partial2 ) {
                    validPartial = NO;
                    break;
                }
            }
            if ( !validPartial ) {
                break;
            }
        }
        
        // make sure the two partials are not the same (indexOfObject: searches using isEqual:)
        validPartial &= ( partial1 != partial2 );
    }
    
    if ( !validPartial ) {
        // just try again;
        return;
    }
    
    // we have a valid solution
    [answers addObject:[NSNumber numberWithInt:newAnswer]];
    [partials addObject:[NSNumber numberWithInt:partial1]];
    [partials addObject:[NSNumber numberWithInt:partial2]];
}


#pragma mark - NumberViewDelegate

-(void)number:(NSNumber *)num wasSelected:(BOOL)sel {
    
    if (!sel) {
        chosen1 = nil;
        return;
    }
    
    if ( !chosen1 ) {
        chosen1 = num;
        return;
    }
    
    // we have two of them chosen
    int ind1 = [partials indexOfObject:chosen1];
    int ind2 = [partials indexOfObject:num];
    
    if (ind1>ind2) {
        int temp = ind1;
        ind1 = ind2;
        ind2 = temp;
    }
    
    BOOL valid = ( ind1%2==0 && ind2==ind1+1 );
    
    if ( !valid ) {
        NSArray* pvs = _partialView.subviews;
        for (NumberView* nv in pvs) {
            if ( [nv number]==chosen1 || [nv number]==num ) {
                [nv deselect];
            }
        }
        chosen1 = nil;
        
        startDate = [startDate dateByAddingTimeInterval:-10];
        float scale = 1.2;
        float tran = _timeLabel.frame.size.width * (scale-1) * 0.5;
        [UIView animateWithDuration:.24 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
            _timeLabel.transform = CGAffineTransformMake(scale, 0, 0, scale, -tran, 0);
//            _timeLabel.transform = CGAffineTransformMakeScale(1.2, 1.2);
        } completion:^(BOOL comp){
            [UIView animateWithDuration:.24 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
                _timeLabel.transform = CGAffineTransformIdentity;
            } completion:nil];
        }];
    }
    else {
        NSArray* pvs = _partialView.subviews;
        for (NumberView* nv in pvs) {
            if ( [nv number]==chosen1 || [nv number]==num ) {
                [nv fade];
            }
        }
        chosen1 = nil;
        NSNumber* answer = [answers objectAtIndex:ind1/2];
        NSArray* avs = _answerView.subviews;
        for (NumberView* nv in avs) {
            if ( [nv number]==answer ) {
                [nv fade];
            }
        }
        
        numCorrect += 1;
        if ( numCorrect == answers.count ) {
            [clockLink invalidate];
            clockLink = nil;
        }
    }
}

                 


- (IBAction)buttonPressed:(id)sender {
    
    if ( sender == _backButton ) {
        [self.navigationController popViewControllerAnimated:YES];
        [clockLink invalidate];
        clockLink = nil;
    }
    if ( sender == _resetButton ) {
        [clockLink invalidate];
        clockLink = nil;
        [self reinitialize];
    }
}
                 
                 
    
@end
































