//
//  PeriListViewController.m
//  TabDemo
//
//  Created by jackyjiao on 1/12/16.
//  Copyright © 2016 Tencent. All rights reserved.
//

#import "PeriListViewController.h"
#import "PeripheralViewController.h"
#import "DMBLECentralManager.h"

@interface PeriListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView        *noEAView;
@property (nonatomic, strong) UITableView   *tableView;

@end

@implementation PeriListViewController

- (void)dealloc {
    [[DMBLECentralManager sharedManager] stopScan];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView {
    self.view                 = [[UIView alloc] initWithFrame:APPLICATION_BOUNDS];
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    self.title                = @"扫描BLE";
    [self.view addSubview:self.noEAView];
    [self.view addSubview:self.tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(periListUpdateNotification:) name:JKPeriListUpdateNotification object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[DMBLECentralManager sharedManager] startScan];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[DMBLECentralManager sharedManager] stopScan];
    [super viewDidDisappear:animated];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setBackgroundColor:DEFAULT_BACKGROUND_COLOR];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, DEFAULT_PADDING_LEFT, 0, 0)];
        [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    return _tableView;
}

- (UIView *)noEAView {
    if (_noEAView == nil) {
        // 如果没有任何东西的时候，显示这个提示。
        _noEAView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [_noEAView setBackgroundColor:[UIColor whiteColor]];
        UILabel *noEALabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, self.view.frame.size.width, 50)];
        [noEALabel setText:@"没有发现BLE周边设备"];
        [noEALabel setTextAlignment:NSTextAlignmentCenter];
        [_noEAView addSubview:noEALabel];
        [_noEAView setHidden:NO];
    }
    return _noEAView;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return DEFAULT_TABLE_VIEW_HEADER_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return DEFAULT_TABLE_VIEW_FOOTER_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[DMBLECentralManager sharedManager].periArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"PeriItemInfoCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    DMPeripheral *dmPeripheral = [DMBLECentralManager sharedManager].periArray[indexPath.row];
    CBPeripheral *peri = dmPeripheral.peripheral;
    NSUUID *tmpUUID = peri.identifier;
    NSDictionary <NSString *, id> *advertisementData = dmPeripheral.advertisementData;
    
    NSString *name = peri.name ? peri.name : @"Unnamed";
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", name, advertisementData[@"kCBAdvDataManufacturerData"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)", tmpUUID.UUIDString, dmPeripheral.RSSI];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DMPeripheral *dmPeripheral = [DMBLECentralManager sharedManager].periArray[indexPath.row];
    PeripheralViewController *periVC = [[PeripheralViewController alloc] init];
    periVC.dmPeripheral = dmPeripheral;
    [self.navigationController pushViewController:periVC animated:YES];
}


#pragma mark - notify
- (void)periListUpdateNotification:(NSNotification *)notification {
    JLog(@"get Notification with url %@", [notification object]);
    
    if ([[DMBLECentralManager sharedManager].periArray count] == 0) {
        [self.noEAView setHidden:NO];
    } else {
        [self.noEAView setHidden:YES];
    }
    [self.tableView reloadData];
}

@end
