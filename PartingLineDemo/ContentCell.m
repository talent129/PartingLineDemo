//
//  ContentCell.m
//  PartingLineDemo
//
//  Created by luckyCoderCai on 2017/8/16.
//  Copyright © 2017年 luckyCoderCai. All rights reserved.
//

#import "ContentCell.h"
#import "ComeOnModel.h"
#import "Masonry.h"
#import "UIColor+Category.h"

@interface ContentCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation ContentCell

#pragma mark -lazy load
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.layer.cornerRadius = 25;
        _imgView.layer.masksToBounds = YES;
        _imgView.backgroundColor = [UIColor grayColor];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imgView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self _initView];
    }
    return self;
}

- (void)_initView
{
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.nameLabel];
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.centerX.equalTo(self.contentView);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgView.mas_bottom).mas_offset(10);
        make.leading.and.trailing.equalTo(@0);
    }];
    
}

- (void)setModel:(ComeOnModel *)model
{
    _model = model;
    self.imgView.image = [UIImage imageNamed:model.encouragerHeadUrl];
    self.nameLabel.text = model.encouragerName;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //1. frame 需要collectionView宽度 屏幕宽度 + 0.5 否则最右侧显示该颜色竖线
//    UIView *horLineView = [[UIView alloc] init];
//    horLineView.backgroundColor = [UIColor redColor];
//    [self.contentView addSubview:horLineView];
//    horLineView.frame = CGRectMake(0, self.bounds.size.height - 0.5, self.bounds.size.width, 0.5);
//    
//    UIView *verLineView = [[UIView alloc] init];
//    verLineView.backgroundColor = [UIColor redColor];
//    [self.contentView addSubview:verLineView];
//    verLineView.frame = CGRectMake(self.bounds.size.width - 0.5, 0, 0.5, self.bounds.size.height);
    
    //2. autolayout 需要collectionView宽度 屏幕宽度 + 0.5 否则6s、7等机型有竖线不显示
    UIView *horLineView = [[UIView alloc] init];
    horLineView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:horLineView];
    [horLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.bottom.and.trailing.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
    UIView *verLineView = [[UIView alloc] init];
    verLineView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:verLineView];
    [verLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.trailing.equalTo(@0);
        make.width.equalTo(@0.5);
    }];
    
    //3. CALayer 需要collectionView宽度 屏幕宽度 + 0.5 否则最右侧显示该颜色竖线 但6s、7等机型竖线均显示 不存在2. autolayout情况
//    CALayer *bottomLineLayer = [[CALayer alloc] init];
//    bottomLineLayer.frame = CGRectMake(0, self.bounds.size.height - 0.5, self.bounds.size.width, 0.5);
////    bottomLineLayer.backgroundColor = [UIColor colorWithRed:230/255.0 green:233/255.0 blue:237/255.0 alpha:1].CGColor;
//    bottomLineLayer.backgroundColor = [UIColor redColor].CGColor;
//    [self.contentView.layer addSublayer:bottomLineLayer];
//    
//    CALayer *rightLineLayer = [[CALayer alloc] init];
//    rightLineLayer.frame = CGRectMake(self.bounds.size.width - 0.5, 0, 0.5, self.bounds.size.height);
////    rightLineLayer.backgroundColor = [UIColor colorWithRed:230/255.0 green:233/255.0 blue:237/255.0 alpha:1].CGColor;
//    rightLineLayer.backgroundColor = [UIColor redColor].CGColor;
//    [self.contentView.layer addSublayer:rightLineLayer];
    
}

@end
