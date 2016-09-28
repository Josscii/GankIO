//
//  GKRealStuffsContainerCell.h
//  GankIO
//
//  Created by Josscii on 16/9/26.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RealStuff.h"
#import "GKPullRefresher.h"
#import "GKLoadingView.h"

@protocol GKRealStuffProtocol <NSObject>

- (void)loadNext;
- (void)loadPre;

@end

@interface GKRealStuffsContainerCell : UITableViewCell

@property (nonatomic, copy) NSArray *realStuffs;
@property (nonatomic, weak) id<GKRealStuffProtocol> delegate;

@property (nonatomic, strong) GKPullRefresher *pullHeader;
@property (nonatomic, strong) GKPullRefresher *pullFooter;
@property (nonatomic, strong) GKLoadingView *loadingView;
@property (nonatomic, strong) UITableView *tableView;

@end
