//
//  GKSearchViewController.m
//  GankIO
//
//  Created by Josscii on 16/9/6.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import "GKSearchViewController.h"
#import "GKSearchResultViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "GKAppConstants.h"
#import "KINWebBrowser/KINWebBrowserViewController.h"
#import "GKPullRefresher.h"

@interface GKSearchViewController ()

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) GKSearchResultViewController *searchResultViewController;

@end

@implementation GKSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.searchResultViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchResultViewController"];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultViewController];
    self.searchController.searchResultsUpdater = (id<UISearchResultsUpdating>)self.searchResultViewController;
    self.searchController.searchBar.delegate = (id<UISearchBarDelegate>)self.searchResultViewController;
    
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.definesPresentationContext = YES;
    
    // search bar
    self.navigationItem.titleView = self.searchController.searchBar;
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    
    // notification
    @weakify(self)
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:GKDidSelectRealStuffNotification object:nil]
      takeUntil:[self rac_willDeallocSignal]]
     subscribeNext:^(NSNotification *notifi) {
         @strongify(self)
         NSString *url = notifi.userInfo[@"url"];
         KINWebBrowserViewController *webBrowser = [KINWebBrowserViewController webBrowser];
         webBrowser.hidesBottomBarWhenPushed = YES;
         [self.navigationController pushViewController:webBrowser animated:YES];
         [webBrowser loadURLString:url];
     }];
}


@end
