//
//  ViewController.m
//  DeutschMath
//
//  Created by Fredrik Carlsson on 6/17/13.
//  Copyright (c) 2013 appbyran. All rights reserved.
//

#import "ViewController.h"
#import "FootballVC.h"

#define CELL_ID @"cellID"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource , UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"number of rows in section");
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"number of sections");
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_ID];
    }
    cell.textLabel.text = @"Football";
    
    NSLog(@"made a cell");
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int row = indexPath.row;
    
    if ( row == 0 ) {
        // Open the football game
        FootballVC* fvc = [FootballVC new];
        [self.navigationController pushViewController:fvc animated:YES];
    }
}

@end
