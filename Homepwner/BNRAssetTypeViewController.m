//
//  BNRAssetTypeViewController.m
//  Homepwner
//
//  Created by 倪之欣 on 15/12/30.
//  Copyright © 2015年 倪之欣. All rights reserved.
//

#import "BNRAssetTypeViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"

@interface BNRAssetTypeViewController () <UIAlertViewDelegate, UITextFieldDelegate>

@property (nonatomic) UIAlertView *addAssetAlert;
@property (nonatomic) NSMutableArray *itemsOfType;

@end

@implementation BNRAssetTypeViewController

- (instancetype)init
{
    return [super initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewAsset)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)addNewAsset{
    NSLog(@"Adding new asset!");
    
    if (!_addAssetAlert) {
        _addAssetAlert = [[UIAlertView alloc] initWithTitle:@"New Asset" message:@"Enter New Asset Name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK!", nil];
        
        self.addAssetAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    }
    
    [self.addAssetAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            NSLog(@"Index %i %@", buttonIndex, [self.addAssetAlert buttonTitleAtIndex:buttonIndex]);
            [self.addAssetAlert resignFirstResponder];
            break;
        case 1:
            NSLog(@"Index %i %@", buttonIndex, [self.addAssetAlert buttonTitleAtIndex:buttonIndex]);
            
            UITextField *textField = [self.addAssetAlert textFieldAtIndex:0];
            if ( textField.text.length > 0 )
                [[BNRItemStore sharedStore] createAssetWithName:textField.text];
            [self.tableView reloadData];
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Asset Types";
    }
    else return @"All items of selected Asset Type";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [[[BNRItemStore sharedStore] allAssetTypes] count];
    } else {
        NSArray *allItems = [[[BNRItemStore sharedStore] allItems] mutableCopy];
        self.itemsOfType = [[NSMutableArray alloc] init];
        
        if (!self.item.assetType) {
            return 0;
        }
        
        for (BNRItem *item in allItems) {
            
            if (item.assetType == self.item.assetType) {
                [self.itemsOfType addObject:item];
            }
        }
        return [self.itemsOfType count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                                                forIndexPath:indexPath];
        NSArray *allAssets = [[BNRItemStore sharedStore] allAssetTypes];
        NSManagedObject *assetType = allAssets[indexPath.row];
        
        // Use key-value coding to get the asset type's label
        NSString *assetLabel = [assetType valueForKey:@"label"];
        cell.textLabel.text = assetLabel;
        
        // Checkmark the one that is currently selected
        if (assetType == self.item.assetType) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return cell;
    } else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                                                forIndexPath:indexPath];
        //NSArray *allItems = [[BNRItemStore sharedStore] allItems];
        BNRItem *item = self.itemsOfType[indexPath.row];
        
        
        cell.textLabel.text = item.itemName;
        
        return cell;

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        NSArray *allAssets = [[BNRItemStore sharedStore] allAssetTypes];
        NSManagedObject *assetType = allAssets[indexPath.row];
        self.item.assetType = assetType;
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
