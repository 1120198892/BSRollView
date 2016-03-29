//
//  ViewController.m
//  BSRollView
//
//  Created by erice on 16/3/22.
//  Copyright © 2016年 erice. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+Caculator.h"
#import "CaculatorMaker.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   
    
    
    int  result2 =[NSObject makeCalculate:^(CaculatorMaker *make) {
        
         make.add(1).add(2).add(3).add(4).resume(4).sub(2);
    }];
    
    
    NSLog(@"result :%d",result2);
}



@end
