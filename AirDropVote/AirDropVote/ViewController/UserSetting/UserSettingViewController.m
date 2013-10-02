//
//  UserSettingViewController.m
//  AirDropVote
//
//  Created by 高橋 勲 on 2013/10/02.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "UserSettingViewController.h"
#import "UserSettingUtil.h"

@interface UserSettingViewController ()

@end

@implementation UserSettingViewController

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
    
    NSString* userName = [UserSettingUtil getStringWithKey:@"user_name"];
    if (userName != nil) {
        self.userNameField.text = userName;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    [UserSettingUtil setStringWithKey:@"user_name" value:textField.text];
    
    [self.navigationController popViewControllerAnimated:YES];
    return false;
}

@end
