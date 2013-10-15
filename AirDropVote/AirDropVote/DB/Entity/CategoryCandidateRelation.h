//
//  CategoryCandidateRelation.h
//  AirDropVote
//
//  Created by 高橋 勲 on 2013/10/05.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ElectionCategory.h"
#import "Bookmark.h"
#import "FMResultSet.h"

@interface CategoryCandidateRelation : NSObject

@property(nonatomic) NSString *t_category_title;
@property(nonatomic) NSString *t_category_user;
@property(nonatomic) NSString *t_candidate_title;
@property(nonatomic) NSString *t_candidate_url;
@property(nonatomic) int i_del_flg;

-(id)initWithJson:(NSArray*)jsonObject;
-(id)initWithResultSet:(FMResultSet*)rs;
-(id)initWithCategory:(ElectionCategory*)ec Bookmark:(Bookmark*)bm;
@end
