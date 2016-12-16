//
//  JKFindViewController.m
//  JKDemo
//
//  Created by jackyjiao on 12/8/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import "JKFindViewController.h"
#import "JKSearchResultController.h"
#import "JKSearchController.h"
#import "DMNumberPickerView.h"

@interface JKFindViewController () <UISearchBarDelegate>

@property (nonatomic, strong) JKSearchController *searchController;
@property (nonatomic, strong) JKSearchResultController   *searchResult;
@property (nonatomic, strong) DMNumberPickerView *numberPickerView;

@end

@implementation JKFindViewController

- (void)loadView {
    self.view                 = [[UIView alloc] initWithFrame:APPLICATION_BOUNDS];
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    self.title = @"发现";
    UIImage *image = [UIImage tc_imageWithColor:UIColorFromHex(0x303030) size:CGSizeMake(APPLICATION_SCREEN_WIDTH, DEFAULT_NAVIGATION_BAR_HEIGHT)];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = NO;
    [self.view addSubview:self.searchController.searchBar];
    //[self.view addSubview:self.numberPickerView];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.hidesBottomBarWhenPushed = NO;
    [super viewDidDisappear:animated];
}

#pragma mark - Getter -
- (JKSearchController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[JKSearchController alloc] initWithSearchResultsController:self.searchResult];
        [_searchController setSearchResultsUpdater:self.searchResult];
        [_searchController.searchBar setPlaceholder:@"输入数字"];
        [_searchController.searchBar setDelegate:self];
    }
    return _searchController;
}

- (UIViewController *)searchResult
{
    if (_searchResult == nil) {
        _searchResult = [[JKSearchResultController alloc] init];
    }
    return _searchResult;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.navigationController.navigationBar.translucent = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - NumberPickerView
- (DMNumberPickerView *)numberPickerView {
    if (_numberPickerView == nil) {
        _numberPickerView = [[DMNumberPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.tcWidth, (106+0))
                                                         defaultValue:100
                                                             maxValue:300];
        _numberPickerView.backgroundColor = UIColorFromHex(0x24212d);
        _numberPickerView.delegate = nil;
        _numberPickerView.tcTop    = self.searchController.searchBar.tcBottom + 10;
    }
    return _numberPickerView;
}


@end
