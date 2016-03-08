//
//  ViewController.m
//  RuntimerDemo
//
//  Created by 孙云 on 16/3/8.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
@interface ViewController ()
//属性测试使用
@property(nonatomic,copy)NSString *test;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //一些基本的方法
    [self loadBaseMethod];
    //获取类的所有的方法
    [self loadAllRoad];
    //获取类的所有的属性
    [self loadAllProperty];
    /***********黑魔法用于不改变源代码的基础上去修改原来的实现的功能***********/
    //黑魔法(交换方法)
    [self swizzOne];
    //第二种交换方法
    [self swizzTwo];
    
    //label的测试
}
- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    NSLog(@"<%s %i> 输出的是我，哈哈哈",__func__,__LINE__);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  一些基本的方法输出
 */
- (void)loadBaseMethod{

  //获取本类的类名
    NSLog(@"这个类的大名为 %s",class_getName([ViewController class]));
    
    //判断这个类是不是元类
    NSLog(@"快说你是不是元类===%@",class_isMetaClass([ViewController class]) ? @"是" : @"不是");
    //这个类的大小
    NSLog(@"告诉我的你的体重 === %zu",class_getInstanceSize([ViewController class]));
    //判断一个类是否含有某个方法
    NSLog(@"你是否拥有我写的这个方法===%@",class_respondsToSelector([ViewController class],@selector(init)) ? @"拥有" : @"不拥有");
    //返回方法名
    NSLog(@"我输入的方法的名字为 === %s",sel_getName(@selector(init)));
    //判断两个方法是否一样
    NSLog(@"我写的两个方法是否一样===%@",sel_isEqual(@selector(init),@selector(load)) ? @"一样" : @"不一样");
    /*************有需要的自己去查api，不可能全部列出,我的水平没到*************/
    
}
/**
 *  显示所有运用的方法
 */
- (void)loadAllRoad{

    unsigned int count = 0;
    Method *methodList = class_copyMethodList([ViewController class], &count);
    for (NSInteger i = 0; i < count; i++) {
        NSString *name = NSStringFromSelector(method_getName(methodList[i]));
        NSLog(@"本类的运行的所有方法 ＝＝%@",name);
    }
}
/**
 *  显示所有的本类的属性
 */
- (void)loadAllProperty{

    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList([ViewController class], &count);
    for (NSInteger i = 0; i < count; i++) {
        NSString *name = @(ivar_getName(ivarList[i]));
        NSLog(@"本类的属性有== %@",name);
    }
}
/**
 *  用于交换的方法
 */
- (void)changeViewDidAppear{

    NSLog(@"<%i %s>输出的是我，嘎嘎",__LINE__,__func__);
}
- (void)changeViewDidAppear2{

    NSLog(@"<%i %s>第二种交换的输出",__LINE__,__func__);
}
/**
 *  第一种黑魔法使用
 */
- (void)swizzOne{

   //获取方法
    Method oldMeth = class_getInstanceMethod([ViewController class],@selector(viewDidAppear:));
    Method newMeth = class_getInstanceMethod([ViewController class], @selector(changeViewDidAppear));
    method_exchangeImplementations(oldMeth, newMeth);
}
/**
 *  第二种黑魔法
 */
- (void)swizzTwo{

    //获取方法
    Method oldMeth = class_getInstanceMethod([ViewController class],@selector(viewDidAppear:));
    Method newMeth = class_getInstanceMethod([ViewController class], @selector(changeViewDidAppear2));
    IMP old = method_getImplementation(oldMeth);
    IMP new = method_getImplementation(newMeth);
    method_setImplementation(oldMeth, new);
    method_setImplementation(newMeth, old);
}
@end
