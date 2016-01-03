//
//  BNRDetailViewController.m
//  Homepwner
//
//  Created by 倪之欣 on 15/11/3.
//  Copyright © 2015年 倪之欣. All rights reserved.
//

#import "BNRDetailViewController.h"
#import "BNRItem.h"
#import "BNRDateChangeController.h"
#import "BNRImageStore.h"
#import "BNRItemStore.h"
#import "BNRAssetTypeViewController.h"
#import "AppDelegate.h"

@interface BNRDetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) UIPopoverController *imagePickerPopover;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteImageButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *assetTypeButton;

@end

@implementation BNRDetailViewController

#pragma mark - Actions
- (IBAction)deleteImage:(id)sender {
    if (self.item.itemKey) {
        [[BNRImageStore sharedStore] deleteImageForKey:self.item.itemKey];
        
        self.imageView.image = nil;
        self.deleteImageButton.enabled = NO;
    } 
}
- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)showAssetTypePicker:(id)sender {
    [self.view endEditing:YES];
    
    BNRAssetTypeViewController *avc = [[BNRAssetTypeViewController alloc] init];
    avc.item = self.item;
    
    //Display in popover for ipad
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:avc];
        self.imagePickerPopover.delegate = self;
        [self.imagePickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        [self.navigationController pushViewController:avc animated:YES];
    }
    
}
- (IBAction)takePicture:(id)sender {
    if ([self.imagePickerPopover isPopoverVisible]) {
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        NSArray *availableTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
//        imagePicker.mediaTypes = availableTypes;
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        imagePicker.showsCameraControls = YES;
        
        UIImageView *cameraOverlayView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Crosshairs.png"]];
        cameraOverlayView.alpha = 0.5f;
        cameraOverlayView.center = self.view.center;
        imagePicker.cameraOverlayView = cameraOverlayView;

    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
//    imagePicker.allowsImageEditing = YES;
    
//    [self presentViewController:imagePicker animated:YES completion:nil];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        
        self.imagePickerPopover.delegate = self;
        
        [self.imagePickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }else {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    
    
    [[BNRImageStore sharedStore] setImage:image forKey:self.item.itemKey];
    self.imageView.image = image;
    [self.item setThumbnailFromImage:image];
//    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.imagePickerPopover) {
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)changeDate:(id)sender {
    BNRDateChangeController *dateChangeController = [[BNRDateChangeController alloc] init];
    
    dateChangeController.item = self.item;
    [self.navigationController pushViewController:dateChangeController animated:YES];
}

#pragma mark - View life cycle
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    UIImageView *iv = [[UIImageView alloc] initWithImage:nil];
//    iv.contentMode = UIViewContentModeScaleAspectFill;
//    
//    iv.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    [self.view addSubview:iv];
//    
//    self.imageView = iv;
//    
//    [self.imageView setContentHuggingPriority:200 forAxis:UILayoutConstraintAxisVertical];
//    [self.imageView setContentCompressionResistancePriority:700 forAxis:UILayoutConstraintAxisVertical];
//    
//    NSDictionary *nameMap = @{@"imageView" : self.imageView, @"dateLabel" : self.dateLabel, @"toolbar" : self.toolbar};
//    
//    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|" options:0 metrics:nil views:nameMap];
//    
//    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dateLabel]-8-[imageView]-8-[toolbar]" options:0 metrics:nil views:nameMap];
//    
//    [self.view addConstraints:horizontalConstraints];
//    [self.view addConstraints:verticalConstraints];
//}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIInterfaceOrientation io = [[UIApplication sharedApplication] statusBarOrientation];
    [self prepareViewForOrientation:io];
    
    BNRItem *item = self.item;
    
    self.nameField.text = item.itemName;
    self.serialNumberField.text = item.serialNumber;
    self.valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    self.dateLabel.text = [dateFormatter stringFromDate:item.dateCreated];
    
    NSString *itemKey = self.item.itemKey;
    UIImage *imageToDisplay = [[BNRImageStore sharedStore] imageForKey:itemKey];
    
    self.imageView.image = imageToDisplay;
    if (imageToDisplay) {
        self.deleteImageButton.enabled = YES;
    }else
        self.deleteImageButton.enabled = NO;
//    self.valueField.enablesReturnKeyAutomatically = YES;
    NSString *typeLabel = [self.item.assetType valueForKey:@"label"];
    if (!typeLabel) {
        typeLabel = NSLocalizedString(@"None", @"Type label None");
    }
    
    self.assetTypeButton.title = [NSString stringWithFormat:NSLocalizedString(@"Type: %@", @"Asset type button"), typeLabel];
    
    [self updateFonts];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    BNRItem *item = self.item;
    item.itemName = self.nameField.text;
    item.serialNumber = self.serialNumberField.text;
    
    int newValue = [self.valueField.text intValue];
    
    if (newValue != item.valueInDollars) {
        item.valueInDollars = newValue;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:newValue forKey:BNRNextItemValuePrefsKey];
    }
}

- (void)setItem:(BNRItem *)item
{
    _item = item;
    self.navigationItem.title = _item.itemName;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self.nameField resignFirstResponder];
//    [self.serialNumberField resignFirstResponder];
//    [self.valueField resignFirstResponder];
//}

//- (IBAction)showButton:(id)sender
//{
//    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:nil action:@selector(resignFirstResponder)];
//    self.navigationItem.rightBarButtonItem = doneButton;
//}

#pragma mark - orientation
- (void)prepareViewForOrientation:(UIInterfaceOrientation)orientation
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return;
    }
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.imageView.hidden = YES;
        self.cameraButton.enabled = NO;
    }else {
        self.imageView.hidden = NO;
        self.cameraButton.enabled = YES;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self prepareViewForOrientation:toInterfaceOrientation];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"User dismissed popover");
    self.imagePickerPopover = nil;
    
    NSString *typelabel = [self.item.assetType valueForKey:@"label"];
    if (!typelabel) {
        typelabel = @"None";
    }
    self.assetTypeButton.title = [NSString stringWithFormat:@"Type: %@", typelabel];
}

- (instancetype)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = doneItem;
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelItem;
        }
        
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self selector:@selector(updateFonts) name:UIContentSizeCategoryDidChangeNotification object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong initializer" reason:@"Use initForNewItem:" userInfo:nil];
    return nil;
}

- (void)save:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (void)cancel:(id)sender
{
    [[BNRItemStore sharedStore] removeItem:self.item];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

#pragma mark - font
- (void)updateFonts
{
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    self.nameLabel.font = font;
    self.serialNumberLabel.font = font;
    self.valueLabel.font = font;
    self.dateLabel.font = font;
    
    self.nameField.font = font;
    self.serialNumberField.font = font;
    self.valueField.font = font;
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    BOOL isNew = NO;
    if ([identifierComponents count] == 3) {
        isNew = YES;
    }
    
    return [[self alloc] initForNewItem:isNew];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.item.itemKey forKey:@"item.itemKey"];
    
    self.item.itemName = self.nameField.text;
    self.item.serialNumber = self.serialNumberField.text;
    self.item.valueInDollars = [self.valueField.text intValue];
    
    [[BNRItemStore sharedStore] saveChanges];
    
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSString *itemKey = [coder decodeObjectForKey:@"item.itemKey"];
    
    for (BNRItem *item in [[BNRItemStore sharedStore] allItems]) {
        if ([itemKey isEqualToString:item.itemKey]) {
            self.item = item;
            break;
        }
    }
    
    [super decodeRestorableStateWithCoder:coder];
}
@end

