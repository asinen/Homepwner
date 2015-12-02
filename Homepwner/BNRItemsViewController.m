//
//  BNRItemsViewController.m
//  Homepwner
//
//  Created by 倪之欣 on 15/11/1.
//  Copyright © 2015年 倪之欣. All rights reserved.
//

#import "BNRItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"

@interface BNRItemsViewController ()

//@property (nonatomic, strong) IBOutlet UIView *headerView;

@end

@implementation BNRItemsViewController

- (IBAction)addNewItem:(id)sender
{
    BNRItem *newItem = [[BNRItemStore sharedStore] creatItem];
    NSInteger lastRow = [[[BNRItemStore sharedStore] allItems] indexOfObject:newItem];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
}


- (instancetype) init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Homepwner";
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        
        navItem.rightBarButtonItem = bbi;
        
        navItem.leftBarButtonItem = self.editButtonItem;
    }
    return self;
}

- (instancetype) initWithStyle:(UITableViewStyle)style
{
    return [self init];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    if (indexPath.row < [items count]) {
        BNRItem *item = items[indexPath.row];
        cell.textLabel.text = [item description];
    }else if (indexPath.row == [items count])
    {
        cell.textLabel.text = @"No more items!";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
}

- (void)tableView: (UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[BNRItemStore sharedStore] allItems];
        BNRItem *item = items[indexPath.row];
        [[BNRItemStore sharedStore] removeItem:item];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView: (UITableView *)tableView moveRowAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (proposedDestinationIndexPath.row == [[[BNRItemStore sharedStore] allItems] count]) {
        return sourceIndexPath;
    }else
        return proposedDestinationIndexPath;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [[[BNRItemStore sharedStore] allItems] count]) {
        return NO;
    }else
        return YES;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [[[BNRItemStore sharedStore] allItems] count]) {
        return NO;
    }else
        return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.row < [[[BNRItemStore sharedStore] allItems] count]) {
        BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc] init];
        
        NSArray *items = [[BNRItemStore sharedStore] allItems];
        BNRItem *selectedItem = items[indexPath.row];
        
        detailViewController.item = selectedItem;
        
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}
@end
