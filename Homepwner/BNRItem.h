//
//  BNRItem.h
//  Homepwner
//
//  Created by 倪之欣 on 15/12/29.
//  Copyright © 2015年 倪之欣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BNRItem : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
- (void)setThumbnailFromImage: (UIImage *)image;

@end

NS_ASSUME_NONNULL_END

#import "BNRItem+CoreDataProperties.h"
