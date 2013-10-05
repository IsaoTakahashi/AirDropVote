//
//  CreateCategoryViewController.m
//  AirDropVote
//
//  Created by 高橋 勲 on 2013/10/05.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "CreateCategoryViewController.h"
#import "NSString+Validate.h"
#import "UserSettingUtil.h"
#import "UserSettingConstants.h"

@interface CreateCategoryViewController ()

@end

@implementation CreateCategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.categoryName becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return false;
}

- (IBAction)clickedDoneButton:(id)sender {
    NSString *title = self.categoryName.text;
    if([title isEmpty]) {
        return;
    }
    
    ElectionCategory *ec = [ElectionCategory new];
    ec.t_title = title;
    ec.t_user = [UserSettingUtil getStringWithKey:USER_NAME];
    
    if ([ElectionCategoryDAO exists:ec]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Same category exists" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    } else {
        if ([ElectionCategoryDAO insert:ec]) {
            [self.delegate succeededCreatingCategory:ec];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    
}
@end
