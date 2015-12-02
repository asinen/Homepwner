//
//  BNRItem.m
//  RandomItems
//
//  Created by 倪之欣 on 15/10/23.
//  Copyright © 2015年 倪之欣. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem

- (NSString *) description
{
    return [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d, recorded on %@", self.itemName, self.serialNumber, self.valueInDollars, self.dateCreated];
}

- (instancetype)initWithItemName: (NSString *) name valueInDollars:(int)value serialNumber:(NSString *)sNumber
{
    self = [super init];
    
    if (self) {
        _itemName = name;
        _serialNumber = sNumber;
        _valueInDollars = value;
        
        _dateCreated = [[NSDate alloc] init];
        
        NSUUID *uuid = [[NSUUID alloc] init];
        NSString *key = [uuid UUIDString];
        _itemKey = key;
    }
    
    return self;
}

- (instancetype)initWithItemName:(NSString *)name
{
    return [self initWithItemName:name valueInDollars:0 serialNumber:@""];
}

- (instancetype)init
{
    return [self initWithItemName:@"Item"];
}

- (instancetype)initWithItemName:(NSString *)name serialNumber:(NSString *)sNumber
{
    return [self initWithItemName:name valueInDollars:0 serialNumber:sNumber];
}

+ (instancetype)randomItem
{
    NSArray *randomAdjectiveList = @[@"Fluffy", @"Rusty", @"Shiny", @"Asine"];
    NSArray *randomNounList = @[@"Bear", @"Spork", @"Mac"];
    
    NSInteger adjectiveIndex = arc4random() % [randomAdjectiveList count];
    NSInteger nounIndex = arc4random() % [randomNounList count];
    
    NSString *randomName = [NSString stringWithFormat:@"%@ %@", [randomAdjectiveList objectAtIndex:adjectiveIndex], [randomNounList objectAtIndex:nounIndex]];
    
    int randomValue = arc4random() % 100;
    
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c", '0'+ arc4random() % 10, 'A' + arc4random() % 26, '0'+ arc4random() % 10, 'A' + arc4random() % 26, '0'+ arc4random() % 10];
    
    BNRItem *newItem = [[BNRItem alloc] initWithItemName:randomName valueInDollars:randomValue serialNumber:randomSerialNumber];
    
    return newItem;
}

- (void)dealloc
{
    NSLog(@"Destroyed: %@", self);
}

@end
