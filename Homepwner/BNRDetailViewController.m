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

@interface BNRDetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteImageButton;

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
- (IBAction)takePicture:(id)sender {
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
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    [[BNRImageStore sharedStore] setImage:image forKey:self.item.itemKey];
    self.imageView.image = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeDate:(id)sender {
    BNRDateChangeController *dateChangeController = [[BNRDateChangeController alloc] init];
    
    dateChangeController.item = self.item;
    [self.navigationController pushViewController:dateChangeController animated:YES];
}

#pragma mark - View life cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    BNRItem *item = self.item;
    item.itemName = self.nameField.text;
    item.serialNumber = self.serialNumberField.text;
    item.valueInDollars = [self.valueField.text intValue];
    
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
@end
