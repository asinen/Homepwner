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
#import "BNRImageStore.h"
#import "BNRImageViewController.h"

@interface BNRItemsViewController () <UIPopoverControllerDelegate, UIDataSourceModelAssociation>
@property (nonatomic, strong) UIPopoverController *imagePopover;

//@property (nonatomic, strong) IBOutlet UIView *headerView;

@end

@implementation BNRItemsViewController

- (IBAction)addNewItem:(id)sender
{
    BNRItem *newItem = [[BNRItemStore sharedStore] creatItem];
//    NSInteger lastRow = [[[BNRItemStore sharedStore] allItems] indexOfObject:newItem];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
//    
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc] initForNewItem:YES];
    
    detailViewController.item = newItem;
    
    detailViewController.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    navController.restorationIdentifier = NSStringFromClass([navController class]);
    
    navController.modalPresentationStyle = UIModalPresentationFormSheet;

    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:navController animated:YES completion:nil];
}


- (instancetype) init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = NSLocalizedString(@"Homepwner", @"Name of application");
        
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        
        navItem.rightBarButtonItem = bbi;
        
        navItem.leftBarButtonItem = self.editButtonItem;
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(updateTableViewForDynamicTypeSize) name:UIContentSizeCategoryDidChangeNotification object:nil];
        
        [nc addObserver:self selector:@selector(localeChanged:) name:NSCurrentLocaleDidChangeNotification object:nil];
    }
    return self;
}

- (void)localeChanged: (NSNotification *)note
{
    [self.tableView reloadData];
}

- (void)dealloc
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}
- (instancetype) initWithStyle:(UITableViewStyle)style
{
    return [self init];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNRItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BNRItemCell" forIndexPath:indexPath];
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    if (indexPath.row < [items count]) {
        BNRItem *item = items[indexPath.row];
        cell.nameLabel.text = item.itemName;
        cell.serialNumberLabel.text = item.serialNumber;
        
        static NSNumberFormatter *currencyFormatter = nil;
        if (currencyFormatter == nil) {
            currencyFormatter = [[NSNumberFormatter alloc] init];
            currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
        }
        cell.valueLabel.text = [currencyFormatter stringFromNumber:@(item.valueInDollars)];
        if (item.valueInDollars > 50) {
            cell.valueLabel.textColor = [UIColor greenColor];
        } else
            cell.valueLabel.textColor = [UIColor redColor];
        cell.thumbnailView.image = item.thumbnail;
        
        __weak BNRItemCell *weakCell = cell;
        cell.actionBlock = ^{
            NSLog(@"Going to show iamge for %@", item);
            
            BNRItemCell *strongCell = weakCell;
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                NSString *itemKey = item.itemKey;
                
                UIImage *img = [[BNRImageStore sharedStore] imageForKey:itemKey];
                if (!img) {
                    return;
                }
                
                CGRect rect = [self.view convertRect:strongCell.thumbnailView.bounds fromView:strongCell.thumbnailView];
                
                BNRImageViewController *ivc = [[BNRImageViewController alloc] init];
                ivc.image = img;
                
                self.imagePopover =[[UIPopoverController alloc] initWithContentViewController:ivc];
                self.imagePopover.delegate = self;
                self.imagePopover.popoverContentSize = CGSizeMake(600, 600);
                [self.imagePopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
        };
    }
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"BNRItemCell" bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:@"BNRItemCell"];
    
    self.tableView.restorationIdentifier = @"BNRItemsViewControllerTableView";
    
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
        BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc] initForNewItem:NO];
        
        NSArray *items = [[BNRItemStore sharedStore] allItems];
        BNRItem *selectedItem = items[indexPath.row];
        
        detailViewController.item = selectedItem;
        
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateTableViewForDynamicTypeSize];
}

- (void)updateTableViewForDynamicTypeSize
{
    static NSDictionary *cellHeightDictionary;
    
    if (!cellHeightDictionary) {
        cellHeightDictionary = @{UIContentSizeCategoryExtraSmall: @44,
                                 UIContentSizeCategorySmall: @44,
                                 UIContentSizeCategoryMedium: @44,
                                 UIContentSizeCategoryLarge: @44,
                                 UIContentSizeCategoryExtraLarge: @55,
                                 UIContentSizeCategoryExtraExtraLarge: @65,
                                 UIContentSizeCategoryExtraExtraExtraLarge: @75
                                 };
    }
    
    NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
        
    NSNumber *cellHeight = cellHeightDictionary[userSize];
    [self.tableView setRowHeight:cellHeight.floatValue];
    [self.tableView reloadData];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.imagePopover = nil;
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    return [[self alloc] init];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [coder encodeBool:self.isEditing forKey:@"TableViewIsEditing"];
    
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    self.editing = [coder decodeBoolForKey:@"TableViewIsEditing"];
    
    [super decodeRestorableStateWithCoder:coder];
}

- (NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)idx inView:(UIView *)view
{
    NSString *identifier = nil;
    if (idx && view) {
        BNRItem *item = [[BNRItemStore sharedStore] allItems][idx.row];
        identifier = item.itemKey;
    }
    
    return identifier;
}

- (NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)identifier inView:(UIView *)view
{
    NSIndexPath *indexPath = nil;
    
    if (identifier && view) {
        NSArray *items = [[BNRItemStore sharedStore] allItems];
        for (BNRItem *item in items) {
            if ([identifier isEqualToString:item.itemKey]) {
                int row = [items indexOfObjectIdenticalTo:item];
                indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                break;
            }
        }
    }
    
    return indexPath;
}

@end

