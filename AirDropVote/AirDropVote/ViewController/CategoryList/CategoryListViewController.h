//
//  CategoryListViewController.h
//  AirDropVote
//
//  Created by 高橋 勲 on 2013/10/05.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElectionCategoryDAO.h"
#import "CreateCategoryViewController.h"

@interface CategoryListViewController : UITableViewController<CreateCategoryViewDelegate>

@property(nonatomic) NSMutableArray *categoryList;

@end
