//
//  CategoryCandidateRelationDAO.h
//  AirDropVote
//
//  Created by 高橋 勲 on 2013/10/05.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryCandidateRelation.h"
#import "ElectionCategory.h"
#import "Bookmark.h"

@interface CategoryCandidateRelationDAO : NSObject

+(bool)exists:(CategoryCandidateRelation*)ccr;
+(bool)insert:(CategoryCandidateRelation*)ccr;
+(NSMutableArray*)selectAll;
+(NSMutableArray*)selectByCategory:(ElectionCategory*)ec;
+(NSMutableArray*)selectCandidatesByCategory:(ElectionCategory*)ec; //特定のカテゴリに紐付いているものだけを取得
+(NSMutableArray*)selectCandidatesByExceptingCategory:(ElectionCategory*)ec; //特定のカテゴリに紐付いていないものだけを取得
+(NSMutableArray*)selectByCandidate:(Bookmark*)bm;
+(bool)deleteByPK:(CategoryCandidateRelation*)ccr;

@end
