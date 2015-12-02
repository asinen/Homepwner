//
//  BNRItem.h
//  RandomItems
//
//  Created by 倪之欣 on 15/10/23.
//  Copyright © 2015年 倪之欣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItem : NSObject

@property (nonatomic, copy)NSString *itemName;
@property (nonatomic, copy)NSString *serialNumber;
@property (nonatomic)int valueInDollars;
@property (nonatomic, strong)NSDate *dateCreated;
@property (nonatomic, copy)NSString *itemKey;

- (instancetype)initWithItemName: (NSString *) name valueInDollars:(int)value serialNumber:(NSString *)sNumber;
- (instancetype)initWithItemName: (NSString *)name;
- (instancetype)initWithItemName:(NSString *)name serialNumber:(NSString *)sNumber;

+ (instancetype)randomItem;
@end
