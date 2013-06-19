//
//  ViewController.h
//  DeutschMath
//
//  Created by Fredrik Carlsson on 6/17/13.
//  Copyright (c) 2013 appbyran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
