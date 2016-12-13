//
//  PeripheralViewController.m
//  JKDemo
//
//  Created by jackyjiao on 12/7/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import "PeripheralViewController.h"

@interface PeripheralViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView          *tableView;

@end

@implementation PeripheralViewController

- (void)dealloc {
    [MBProgressHUD tc_hideDefaultIndicator];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[DMBLECentralManager sharedManager] cancelPeripheralConnection];
}

- (void)loadView {
    self.view                 = [[UIView alloc] initWithFrame:APPLICATION_BOUNDS];
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    self.title                = @"BLE信息";
    [self.view addSubview:self.tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(peripheralUpdateNotification:) name:JKPeripheralUpdateNotification object:nil];
    [[DMBLECentralManager sharedManager] connectPeripheral:self.peripheral];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MBProgressHUD tc_showDefaultIndicatorWithText:@"加载中"];
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


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[DMBLECentralManager sharedManager].periInfo count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dict = [DMBLECentralManager sharedManager].periInfo[section];
    NSArray *characteristicArray = dict[JKBLEKEYCharacteristics];
    return [characteristicArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *dict = [DMBLECentralManager sharedManager].periInfo[section];
    CBService *tmpService = dict[JKBLEKEYService];
    return tmpService.UUID.UUIDString;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"PeripheralItemInfoCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    NSDictionary *dict = [DMBLECentralManager sharedManager].periInfo[indexPath.section];
    NSArray *characteristicArray = dict[JKBLEKEYCharacteristics];
    CBCharacteristic *chara = characteristicArray[indexPath.row];
    NSString *name = chara.UUID.UUIDString;
    NSString *property = nil;
    if (chara.properties == CBCharacteristicPropertyRead) {
        property = @"Readable";
    }
    else if (chara.properties == CBCharacteristicPropertyWrite) {
        property = @"Writeable";
    }
    else if (chara.properties == CBCharacteristicPropertyNotify) {
        property = @"Notifiable";
    }
    else {
        property = [NSString stringWithFormat:@"%ld", chara.properties];
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld (isNotifying:%@)", chara.properties, chara.isNotifying ? @"YES" : @"NO"];
    cell.textLabel.text = name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - notify
- (void)peripheralUpdateNotification:(NSNotification *)notification {
    JLog(@"get Notification with url %@", [notification object]);
    [MBProgressHUD tc_hideDefaultIndicator];
    [self.tableView reloadData];
}

@end
