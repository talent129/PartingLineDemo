//
//  ViewController.m
//  PartingLineDemo
//
//  Created by luckyCoderCai on 2017/8/16.
//  Copyright © 2017年 luckyCoderCai. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "ContentCell.h"
#import "NullContentCell.h"
#import "ComeOnModel.h"
#import "UIColor+Category.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, strong) UILabel *topLeftLabel;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UILabel *topRightLabel;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *peopleArray;
@property (nonatomic, assign) NSInteger yu;

@end

@implementation ViewController

#pragma mark -lazy load
- (UILabel *)topLeftLabel
{
    if (!_topLeftLabel) {
        _topLeftLabel = [[UILabel alloc] init];
        _topLeftLabel.text = @"共有";
        _topLeftLabel.textColor = [UIColor colorWithHex:0x434A54 alpha:1];
        _topLeftLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _topLeftLabel;
}

- (UILabel *)totalLabel
{
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.textColor = [UIColor colorWithHex:0xED5565 alpha:1];
        _totalLabel.font = [UIFont boldSystemFontOfSize:15];
        _totalLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalLabel;
}

- (UILabel *)topRightLabel
{
    if (!_topRightLabel) {
        _topRightLabel = [[UILabel alloc] init];
        _topRightLabel.text = @"朋友给我点赞";
        _topRightLabel.textColor = [UIColor colorWithHex:0x434A54 alpha:1];
        _topRightLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _topRightLabel;
}

- (NSMutableArray *)peopleArray
{
    if (!_peopleArray) {
        _peopleArray = [NSMutableArray array];
    }
    return _peopleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"给我点赞";
    self.view.backgroundColor = [UIColor colorWithHex:0xf5f7fa alpha:1];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //初始化
    self.yu = 4;
    
    [self createUI];
    
    //模拟网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getEncourageListData];
    });
}

#pragma mark -数据
- (void)getEncourageListData
{
    for (int i = 0; i < 10; i ++) {
        ComeOnModel *model = [[ComeOnModel alloc] init];
        model.encouragerName = [NSString stringWithFormat:@"pic%d", i];
        model.encouragerHeadUrl = [NSString stringWithFormat:@"pic%d", i];
        [self.peopleArray addObject:model];
    }
    
    if (self.peopleArray.count % 4 != 0) {
        self.yu = self.peopleArray.count % 4;
        
        for (int i = 0; i < (4 - _yu); i ++) {
            ComeOnModel *model = [[ComeOnModel alloc] init];
            [self.peopleArray addObject:model];
        }
    }
    
    self.totalLabel.text = [NSString stringWithFormat:@"%ld位", self.peopleArray.count - (4 - _yu)];
    [self.collectionView reloadData];
}

#pragma mark -createUI
- (void)createUI
{
    [self.view addSubview:self.topLeftLabel];
    [self.view addSubview:self.totalLabel];
    [self.view addSubview:self.topRightLabel];
    
    [_topLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.top.equalTo(self.mas_topLayoutGuideBottom).mas_offset(20);
    }];
    
    [_totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_topLeftLabel.mas_trailing).mas_offset(3);
        make.centerY.equalTo(_topLeftLabel);
    }];
    
    [_topRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_totalLabel.mas_trailing).mas_offset(3);
        make.centerY.equalTo(_totalLabel);
    }];
    
    [self configureCollectionView];
}

- (void)configureCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //设置滑动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    CGFloat width = SCREEN_WIDTH / 4.0;
    flowLayout.itemSize = CGSizeMake(width, 110);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor colorWithHex:0xf5f7fa alpha:1];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom).mas_offset(50);
        make.left.bottom.equalTo(self.view);
        make.width.mas_equalTo(SCREEN_WIDTH + 0.5);
    }];
    [_collectionView registerClass:[ContentCell class] forCellWithReuseIdentifier:@"ContentCell"];
    [_collectionView registerClass:[NullContentCell class] forCellWithReuseIdentifier:@"NullContentCell"];
}

#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.peopleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item < self.peopleArray.count - (4 - _yu)) {
        
        static NSString *iden = @"ContentCell";
        ContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
        
        cell.model = self.peopleArray[indexPath.item];
        
        return cell;
    }else {
        
        static NSString *iden = @"NullContentCell";
        NullContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
        
        return cell;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
