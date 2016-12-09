//
//  ImageCollectViewController.m
//  TabDemo
//
//  Created by jackyjiao on 12/1/16.
//  Copyright © 2016 Tencent. All rights reserved.
//
#import <Photos/Photos.h>
#import "ImageCollectViewController.h"

@interface ImageCollectViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *picArray;
@property (nonatomic, assign) CGSize         picSize;
@property (nonatomic, assign) NSInteger      count;
@property (nonatomic, strong) PHFetchResult  *fetchResult;
@property (nonatomic, copy) NSString         *defaultTitle;

@end

@implementation ImageCollectViewController

- (id)init {
    if (self = [super init]) {
        self.picArray = [NSMutableArray arrayWithCapacity:1];
        CGFloat picWidth = ([[UIScreen mainScreen] bounds].size.width - 4*3 - 2*10) / 4;
        self.picSize = CGSizeMake(picWidth, picWidth);
        [self getImgs];
    }
    return self;
}

- (void)loadView {
    self.view                 = [[UIView alloc] initWithFrame:APPLICATION_BOUNDS];
    self.view.backgroundColor = [UIColor whiteColor];
    self.defaultTitle = @"相册";
    self.title        = @"加载中...";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
}

#pragma mark - views' getter
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        //确定是水平滚动，还是垂直滚动
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.itemSize                = _picSize;
        flowLayout.sectionInset            = UIEdgeInsetsMake(10, 10, 10, 10);//左右上下的距离
        flowLayout.minimumInteritemSpacing = 4;//这个必须设置，否则默认值为10，导致布局不一致  //item之间的距离
        flowLayout.minimumLineSpacing      = 4;

        _collectionView            = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_SCREEN_WIDTH, APPLICATION_SCREEN_HEIGHT-DEFAULT_NAVIGATION_BAR_HEIGHT) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate   = self;
        [_collectionView setBackgroundColor:[UIColor clearColor]];

        //注册Cell，必须要有
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    }
    return _collectionView;
}

#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.picArray count];
}

//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString      *CellIdentifier = @"UICollectionViewCell";
    UICollectionViewCell *cell           = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];

    cell.backgroundColor = [UIColor colorWithRed:((10 * indexPath.row) / 255.0) green:((20 * indexPath.row)/255.0) blue:((30 * indexPath.row)/255.0) alpha:1.0f];
    PHAsset *result = [self.picArray objectAtIndex:indexPath.row];
    //这里的逻辑很奇怪，返回的image尺寸老是错的
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode   = PHImageRequestOptionsResizeModeExact;//注意这里
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;//
    options.synchronous  = NO;
    [[PHImageManager defaultManager] requestImageForAsset:result
                                               targetSize:CGSizeMake(200, 200)
                                              contentMode:PHImageContentModeAspectFill
                                                  options:options
                                            resultHandler:^(UIImage *alaImg, NSDictionary *info) {
         // 得到一张 UIImage，展示到界面上
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.picSize.width, self.picSize.height)];
        img.contentMode = UIViewContentModeScaleAspectFit;
        cell.backgroundView = img;
        img.image = alaImg;
     }];

    return cell;
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //临时改变个颜色，看好，只是临时改变的。如果要永久改变，可以先改数据源，然后在cellForItemAtIndexPath中控制。（和UITableView差不多吧！O(∩_∩)O~）
    JLog(@"item======%@", indexPath);
}

//返回这个UICollectionView是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - Table view action
- (void)delayReload {
    JLog(@"collectionView delayReload.");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.title = self.defaultTitle;
    });
}

#pragma mark - get all picture
- (void)getImgs {
    BACK(^{
        if (!NSClassFromString(@"PHFetchResult")) {
            return;
        }
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];

        PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
        NSUInteger photoCount = [fetchResult countOfAssetsWithMediaType:PHAssetMediaTypeImage];
        if (photoCount == 0) {
            return;
        }
        self.fetchResult = fetchResult;
        JLog(@"fetchResult.");
        [self.fetchResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
             [self.picArray addObject:obj];
             if ((idx+1) >= photoCount) {
                 [self delayReload];
             }
         }];
    });
}

@end
