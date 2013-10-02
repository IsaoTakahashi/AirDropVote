//
//  SettingScoreViewController.m
//  AirDropVote
//
//  Created by 高橋 勲 on 2013/10/03.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "SettingScoreViewController.h"
#import "BookmarkScoreDAO.h"

@interface SettingScoreViewController ()

@end

@implementation SettingScoreViewController

@synthesize bm = _bm;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setBookmark:(Bookmark *)bm {
    _bm = bm;
    self.navigationItem.title = bm.t_title;
    
    BookmarkScore *existingBS = [BookmarkScoreDAO selectByBookmark:bm user:[UserSettingUtil getStringWithKey:@"user_name"]];
    
    if(existingBS != nil) {
        self.bs = existingBS;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self viewSetting];
    if(self.bs != nil) {
        [self.scorePicker selectRow:self.bs.i_score-1 inComponent:0 animated:YES];
    }
}

-(void)viewSetting {
    CALayer *layer = self.view.layer;
    
    // shadow setting
    layer.shadowRadius = 5;
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shadowOpacity = 0.5;
    layer.shadowOffset = CGSizeMake(1, 3);
    layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
    
    // corner setting
    layer.cornerRadius = 5;
    layer.borderWidth = 3;
    layer.borderColor = [[UIColor darkGrayColor] CGColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return 5;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%ld", row+1];
}

- (IBAction)clickCancelButton:(id)sender {
    
    [self.delegate setBookmarkScore:nil];
}

- (IBAction)clickDoneButton:(id)sender {
    if (self.bs == nil) {
        self.bs = [[BookmarkScore alloc] init];
        self.bs.t_title = self.bm.t_title;
        self.bs.t_url = self.bm.t_url;
        self.bs.t_user = [UserSettingUtil getStringWithKey:@"user_name"];
    }
    
    self.bs.i_score = (int)[self.scorePicker selectedRowInComponent:0] + 1;
    
    [self.delegate setBookmarkScore:self.bs];
}
@end
