//
//  BNRDateChangeController.m
//  Homepwner
//
//  Created by 倪之欣 on 15/11/4.
//  Copyright © 2015年 倪之欣. All rights reserved.
//

#import "BNRDateChangeController.h"
#import "BNRItemsViewController.h"
#import "BNRItem.h"

@interface BNRDateChangeController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePick;

@end

@implementation BNRDateChangeController
- (IBAction)changeDateButton:(id)sender {
    self.item.dateCreated = self.datePick.date;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
