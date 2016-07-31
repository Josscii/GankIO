//
//  GKRealStuffViewController.m
//  GankIO
//
//  Created by Josscii on 16/7/23.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import "GKRealStuffViewController.h"
#import "GKRealStuffCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "GKRealStuffViewModel.h"

static NSString * const cellReuseIndentifier = @"GKRealStuffCell";

@interface GKRealStuffViewController ()

@property (nonatomic, strong) GKRealStuffViewModel *viewModel;

@end

@implementation GKRealStuffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: -48 * 60 * 60];
    
    self.viewModel = [[GKRealStuffViewModel alloc] initWithDate:date];
    
    @weakify(self)
    [self.viewModel.requestDataSignal subscribeNext:^(id x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
    
    [self configureLayout];
}

- (void)configureLayout {
    self.tableView.estimatedRowHeight = 68;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.realStuffs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GKRealStuffCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIndentifier forIndexPath:indexPath];
    
    [cell configreCellWithRealStuff:self.viewModel.realStuffs[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
