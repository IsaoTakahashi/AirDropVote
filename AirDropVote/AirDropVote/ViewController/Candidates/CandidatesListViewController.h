//
//  CandidatesListViewController.h
//  AirDropVote
//
//  Created by 高橋 勲 on 2013/10/01.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"
#import "SettingScoreViewController.h"
#import "AddCandidateListViewController.h"
#import "BookmarkDAO.h"
#import "CategoryCandidateRelationDAO.h"
#import "ElectionCategory.h"

@interface CandidatesListViewController : UITableViewController<SearchViewControllerDelegate,SettingScoreViewControllerDelegate,AddCandidateListViewControllerDelegate>

@property (nonatomic) ElectionCategory *electionCategory;
@property (strong, nonatomic) NSMutableArray *bookmarkList;
@property (nonatomic) SettingScoreViewController *ssViewCtr;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addCandidateButton;

- (IBAction)clickedActionButton:(id)sender;

@end
