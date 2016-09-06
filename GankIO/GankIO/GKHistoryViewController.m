//
//  GKHistoryViewController.m
//  GankIO
//
//  Created by Josscii on 16/8/13.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import "GKHistoryViewController.h"
#import "GKAppConstants.h"

@implementation GKHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"历史";
    self.tableView.backgroundColor = [UIColor whiteColor];
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.history.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.history[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GKDidPickAHistoryDayNotification object:nil userInfo:@{@"pickedIndex": @(indexPath.row)}];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
