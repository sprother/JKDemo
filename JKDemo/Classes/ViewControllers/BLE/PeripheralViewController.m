//
//  PeripheralViewController.m
//  JKDemo
//
//  Created by jackyjiao on 12/7/16.
//  Copyright © 2016 jackyjiao. All rights reserved.
//

#import "PeripheralViewController.h"
#import "DMBLECentralManager.h"

@interface PeripheralViewController ()<UITableViewDataSource, UITableViewDelegate, CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) UITableView          *tableView;

@end

@implementation PeripheralViewController

- (void)dealloc {
    [MBProgressHUD tc_hideDefaultIndicator];
    [[DMBLECentralManager sharedManager] cancelPeripheralConnection:self.dmPeripheral.peripheral];
    [DMBLECentralManager sharedManager].delegate = nil;
}

- (void)loadView {
    self.view                 = [[UIView alloc] initWithFrame:APPLICATION_BOUNDS];
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    self.title                = @"BLE信息";
    [self.view addSubview:self.tableView];
    
    [DMBLECentralManager sharedManager].delegate = self;
    [[DMBLECentralManager sharedManager] connectPeripheral:self.dmPeripheral.peripheral];
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
    return [self.dmPeripheral.peripheral.services count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dmPeripheral.peripheral.services[section].characteristics count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    CBService *tmpService = self.dmPeripheral.peripheral.services[section];
    return tmpService.UUID.UUIDString;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"PeripheralItemInfoCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    CBCharacteristic *chara = self.dmPeripheral.peripheral.services[indexPath.section].characteristics[indexPath.row];
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
        property = [NSString stringWithFormat:@"%ld", (unsigned long)chara.properties];
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld (isNotifying:%@)", (unsigned long)chara.properties, chara.isNotifying ? @"YES" : @"NO"];
    cell.textLabel.text = name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Connect
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {//无需响应
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    self.dmPeripheral.peripheralDelegate = self;
    [self.dmPeripheral discoverServices];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    [MBProgressHUD tc_hideDefaultIndicator];
    [MBProgressHUD tc_showBottomIndicatorMessage:@"Connect Fail"];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    [MBProgressHUD tc_hideDefaultIndicator];
    [MBProgressHUD tc_showBottomIndicatorMessage:@"Disconnect"];
}


#pragma mark - CBPeripheralDelegate
- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral {
}

- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray<CBService *> *)invalidatedServices {
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(nullable NSError *)error {
}

#pragma mark 发现服务后的回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error {
    for (CBService *service in peripheral.services) {
        JLog(@"3.0 discoverCharacteristics of Service found with UUID: %@, service %@ .", service.UUID, service);
        [peripheral discoverCharacteristics:nil forService:service];
    }
    [self.tableView reloadData];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(nullable NSError *)error {
}

#pragma mark 发现特性后的回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error {
    [self.tableView reloadData];
    [MBProgressHUD tc_hideDefaultIndicator];
}

#pragma mark 读特性/订阅成功后特性发生任何改变 的回调
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
}

#pragma mark 写特性后的回调
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
}

#pragma mark 订阅特性后的回调
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error {
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error {
}

@end
