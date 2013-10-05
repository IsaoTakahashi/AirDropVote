//
//  AddCandidateListViewController.h
//  AirDropVote
//
//  Created by 高橋 勲 on 2013/10/05.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryCandidateRelationDAO.h"

@protocol AddCandidateListViewControllerDelegate <NSObject>

-(void) addCandidate:(Bookmark*)bm;

@end

@interface AddCandidateListViewController : UITableViewController

@property(nonatomic) id<AddCandidateListViewControllerDelegate> delegate;
@property(nonatomic) ElectionCategory *electionCategory;
@property(nonatomic) NSMutableArray *candidateList;
@end
