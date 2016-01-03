//
//  BNRDetailViewController.h
//  Homepwner
//
//  Created by 倪之欣 on 15/11/3.
//  Copyright © 2015年 倪之欣. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BNRItem;

@interface BNRDetailViewController : UIViewController <UIViewControllerRestoration>

- (instancetype)initForNewItem:(BOOL)isNew;

@property (nonatomic, strong) BNRItem *item;
@property (nonatomic, copy) void (^dismissBlock)(void);

@end
