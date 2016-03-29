//
//  CaculatorMaker.h
//  BSRollView
//
//  Created by erice on 16/3/25.
//  Copyright © 2016年 erice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaculatorMaker : NSObject

@property (nonatomic, assign) int result ;

// add

- (CaculatorMaker *(^)(int))add;

- (CaculatorMaker *(^)(int))resume;

- (CaculatorMaker *(^)(int))sub;
@end
