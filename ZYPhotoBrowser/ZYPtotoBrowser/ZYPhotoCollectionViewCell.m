//
//  ZYPhotoCollectionViewCell.m
//  jinxin
//
//  Created by ZhiYong_Huang on 16/4/10.
//  Copyright © 2016年 ZhiYong_Huang. All rights reserved.
//

#import "ZYPhotoCollectionViewCell.h"
#import "ZYPhotoBrowserConfig.h"
#import "ZYPhotoItem.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@interface ZYPhotoCollectionViewCell ()

@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, strong)UILabel *GIFLable;

@end

@implementation ZYPhotoCollectionViewCell


#pragma mark - 懒加载
-(void)setPhotoItem:(ZYPhotoItem *)photoItem {
    _photoItem = photoItem;
    if ([photoItem.bigImageURL rangeOfString:@".gif"].location != NSNotFound) {
        self.GIFLable.hidden = NO;
    } else {
        self.GIFLable.hidden = YES;
    }
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:photoItem.smallImageURL] placeholderImage:ZYPlaceholderImage];
}

-(UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(0);
        }];
    }
    return _imageView;
}

-(UILabel *)GIFLable {
    if (_GIFLable == nil) {
        _GIFLable = [[UILabel alloc] init];
        _GIFLable.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _GIFLable.text = @"GIF";
        _GIFLable.textColor = [UIColor whiteColor];
        _GIFLable.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_GIFLable];
        [_GIFLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(0);
        }];
    }
    return _GIFLable;
}

@end
