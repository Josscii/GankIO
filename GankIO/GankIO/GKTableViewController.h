//
//  GKTableViewController.h
//  GankIO
//
//  Created by Josscii on 16/9/15.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKPullRefresher.h"

@interface GKTableViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) GKPullRefresher *pullRefresher;
@property (nonatomic, strong) 

@end
