//
//  JKDemoViewController.m
//  JKDemo
//
//  Created by jackyjiao on 12/8/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import "JKDemoViewController.h"
#import "JKTableViewCell.h"

#define ROW_NAME_SCAN_BLE   @"扫描BLE周边"
#define ROW_NAME_SCAN_MFI   @"扫描MFI"

#define ROW_NAME_CALC       @"计算器"
#define ROW_NAME_ANIMATION  @"动画"
#define ROW_NAME_PHOTOS     @"相册"

#define ROW_NAME_LOGOUT     @"退出登录"
#define ROW_NAME_GEN_NOTIFY @"产生ANCS通知"

@interface JKDemoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, copy) NSArray <NSArray *> *dataSource;

@end

@implementation JKDemoViewController

- (void)loadView {
    self.view                 = [[UIView alloc] initWithFrame:APPLICATION_BOUNDS];
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self buildDataSourceAndReload];
}

#pragma mark - DataSource
- (void)buildDataSourceAndReload {
    NSMutableArray *mDataSource        = [NSMutableArray array];
    NSMutableArray *mSectionDataSource = nil;

    mSectionDataSource = [NSMutableArray arrayWithObjects:ROW_NAME_SCAN_BLE, ROW_NAME_SCAN_MFI, nil];
    [mDataSource addObject:[mSectionDataSource mutableCopy]];

    mSectionDataSource = [NSMutableArray arrayWithObjects:ROW_NAME_CALC, ROW_NAME_ANIMATION, ROW_NAME_PHOTOS, nil];
    [mDataSource addObject:[mSectionDataSource mutableCopy]];

    mSectionDataSource = [NSMutableArray arrayWithObjects:ROW_NAME_LOGOUT, ROW_NAME_GEN_NOTIFY, nil];
    [mDataSource addObject:[mSectionDataSource mutableCopy]];

    self.dataSource = [mDataSource mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - views' getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setBackgroundColor:DEFAULT_BACKGROUND_COLOR];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
//        [_tableView setSeparatorColor:UIColorFromHex(0xE0E0E0)];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, DEFAULT_PADDING_LEFT, 0, 0)];
        [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_tableView setScrollIndicatorInsets:UIEdgeInsetsMake(DEFAULT_NAVIGATION_BAR_HEIGHT, 0, 0, 0)];
    }
    return _tableView;
}

#pragma mark TableView header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return DEFAULT_TABLE_VIEW_HEADER_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return DEFAULT_TABLE_VIEW_FOOTER_HEIGHT;
}

#pragma mark TableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = NSStringFromClass([self class]);

    JKTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        cell = [[JKTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }

    NSString *cellName = self.dataSource[indexPath.section][indexPath.row];
    cell.textLabel.text  = cellName;
    cell.imageView.image = [UIImage tc_imageWithColor:RANDOM_COLOR size:CGSizeMake(30, 30)];

    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DEFAULT_TABLE_VIEW_ROW_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    //该方法响应列表中行的点击事件
}

@end
