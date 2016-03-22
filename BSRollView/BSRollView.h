//
//  BSRollView.h
//  BSRollView
//
//  Created by erice on 16/3/22.
//  Copyright © 2016年 erice. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^BSRollClickedAction)(NSInteger index);

@interface BSRollView : UIView


@property (nonatomic, assign) NSTimeInterval rollDelay;

@property (nonatomic, strong) UIImage *placeholderImage;


// imageArray  可以是本地图片的名称， 也可以是 网络图片的链接
- (instancetype) initWithFrame:(CGRect)frame WithImages:(NSArray *)imageArray clickedAtIndex:(BSRollClickedAction)rollBlock;


@end
