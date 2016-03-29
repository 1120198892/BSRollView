//
//  CaculatorMaker.m
//  BSRollView
//
//  Created by erice on 16/3/25.
//  Copyright © 2016年 erice. All rights reserved.
//

#import "CaculatorMaker.h"

@implementation CaculatorMaker

- (CaculatorMaker*(^)(int))add{
 
    return ^CaculatorMaker*(int value){
     
        _result += value;
        
        return self;
    };

}

- (CaculatorMaker *(^)(int))sub{

    return ^CaculatorMaker *(int value){
    
        _result *= value ;
        
        return self;
        
    };
    
}

- (CaculatorMaker *(^)(int))resume{
    
   
    return ^CaculatorMaker*(int value){
    
        _result -= value;
        
        return self;
    };
    
};



@end
