//
//  SettingScoreViewController.h
//  AirDropVote
//
//  Created by 高橋 勲 on 2013/10/03.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Bookmark.h"
#import "BookmarkScore.h"

@protocol SettingScoreViewControllerDelegate <NSObject>
- (void)setBookmarkScore:(BookmarkScore*)bs;
@end

@interface SettingScoreViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>
{
    Bookmark *_bm;
}

@property (nonatomic) id<SettingScoreViewControllerDelegate> delegate;
@property (nonatomic,setter = setBookmark:) Bookmark* bm;
@property (nonatomic) BookmarkScore* bs;

@property (weak, nonatomic) IBOutlet UIPickerView *scorePicker;

- (IBAction)clickCancelButton:(id)sender;
- (IBAction)clickDoneButton:(id)sender;

@end
