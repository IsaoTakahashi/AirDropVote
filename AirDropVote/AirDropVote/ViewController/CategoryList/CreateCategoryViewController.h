//
//  CreateCategoryViewController.h
//  AirDropVote
//
//  Created by 高橋 勲 on 2013/10/05.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElectionCategoryDAO.h"

@protocol CreateCategoryViewDelegate <NSObject>

-(void)succeededCreatingCategory:(ElectionCategory*)es;

@end

@interface CreateCategoryViewController : UIViewController

@property(nonatomic)id<CreateCategoryViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *categoryName;
- (IBAction)clickedDoneButton:(id)sender;



@end
