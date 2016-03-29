//
//  NSObject+Caculator.h
//  BSRollView
//
//  Created by erice on 16/3/25.
//  Copyright © 2016年 erice. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CaculatorMaker;
@interface NSObject (Caculator)

+ (float)makeCalculate:(void(^)(CaculatorMaker*make))block;

@end
