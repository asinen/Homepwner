//
//  BNRImageStore.h
//  Homepwner
//
//  Created by 倪之欣 on 15/11/12.
//  Copyright © 2015年 倪之欣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BNRImageStore : NSObject
+ (instancetype)sharedStore;

- (void)setImage: (UIImage *)image forKey: (NSString *)key;
- (UIImage *)imageForKey: (NSString *)key;
- (void)deleteImageForKey: (NSString *)key;
@end
