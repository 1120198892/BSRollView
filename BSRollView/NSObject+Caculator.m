//
//  NSObject+Caculator.m
//  BSRollView
//
//  Created by erice on 16/3/25.
//  Copyright © 2016年 erice. All rights reserved.


#import "NSObject+Caculator.h"
#import "CaculatorMaker.h"


@implementation NSObject (Caculator)


+ (float)makeCalculate:(void(^)(CaculatorMaker*make))block{

    CaculatorMaker * mgr = [[CaculatorMaker alloc] init];
    
    block(mgr);
    
    return mgr.result;

}




@end
