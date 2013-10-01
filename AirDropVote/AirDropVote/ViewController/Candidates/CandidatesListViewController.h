//
//  CandidatesListViewController.h
//  AirDropVote
//
//  Created by 高橋 勲 on 2013/10/01.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"
#import "BookmarkDAO.h"

@interface CandidatesListViewController : UITableViewController<SearchViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *bookmarkList;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;

- (IBAction)clickedActionButton:(id)sender;

@end
