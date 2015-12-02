//
//  BNRItemStore.m
//  Homepwner
//
//  Created by 倪之欣 on 15/11/1.
//  Copyright © 2015年 倪之欣. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@interface BNRItemStore ()

@property (nonatomic) NSMutableArray *privateItems;

@end

@implementation BNRItemStore
+ (instancetype) sharedStore
{
    static BNRItemStore *sharedStroe = nil;
    
    if (!sharedStroe) {
        sharedStroe = [[self alloc] initPrivate];
    }
    
    return sharedStroe;
}

- (instancetype) init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[BNRItemStore sharedStore" userInfo:nil];
    
    return nil;
}

- (instancetype) initPrivate
{
    self = [super init];
    
    if (self) {
        _privateItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)allItems
{
    return self.privateItems;
}

- (BNRItem *)creatItem
{
    BNRItem *item = [BNRItem randomItem];
    [self.privateItems addObject:item];
    return item;
}

- (void)removeItem:(BNRItem *)item
{
    NSString *key = item.itemKey;
    [[BNRImageStore sharedStore] deleteImageForKey:key];
    
    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }
    
    BNRItem *item = self.privateItems[fromIndex];
    
    [self.privateItems removeObjectAtIndex:fromIndex];
    [self.privateItems insertObject:item atIndex:toIndex];
}
@end
