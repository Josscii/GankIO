//
//  GKRealStuffViewController.m
//  GankIO
//
//  Created by Josscii on 16/7/23.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import "GKRealStuffViewController.h"
#import "GKRealStuffCell.h"
#import "GKHttpClient.h"

static NSString * const cellReuseIndentifier = @"GKRealStuffCell";

@interface GKRealStuffViewController ()

@property (nonatomic, strong) NSArray *realStuffs;

@end

@implementation GKRealStuffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.realStuffs = @[];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow: -48 * 60 * 60];
    NSLog(@"%@", date);
    
    [[[[GKHttpClient sharedClient] getGankDataFromDay:date]
     map:^id(id value) {
         NSMutableArray *realStuffs = [NSMutableArray array];
         NSDictionary *json = value;
         NSArray *categories = json[@"category"];
         NSDictionary *result = json[@"results"];
         for (NSString *cate in categories) {
             NSArray *rs = result[cate];
             [realStuffs addObjectsFromArray:rs];
         }
         return realStuffs;
     }] subscribeNext:^(id x) {
         self.realStuffs = x;
         [self.tableView reloadData];
     }];
    
    [self configureLayout];
}

- (void)configureLayout {
    self.tableView.estimatedRowHeight = 68;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.realStuffs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GKRealStuffCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIndentifier forIndexPath:indexPath];
    
    [cell configreCellWithJSON:self.realStuffs[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
