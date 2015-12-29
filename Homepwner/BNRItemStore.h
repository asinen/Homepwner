//
//  BNRItemStore.h
//  Homepwner
//
//  Created by 倪之欣 on 15/11/1.
//  Copyright © 2015年 倪之欣. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BNRItem;

@interface BNRItemStore : NSObject
@property (nonatomic, readonly) NSArray *allItems;
+ (instancetype) sharedStore;
- (BNRItem *)creatItem;
- (void)removeItem:(BNRItem *)item;
- (void)moveItemAtIndex: (NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
- (BOOL)saveChanges;
- (NSArray *)allAssetTypes;
@end
