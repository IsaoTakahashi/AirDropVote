//
//  CategoryCandidateRelationDAO.m
//  AirDropVote
//
//  Created by 高橋 勲 on 2013/10/05.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "CategoryCandidateRelationDAO.h"
#import "SimpleDBManager.h"

@implementation CategoryCandidateRelationDAO

+(bool)exists:(CategoryCandidateRelation*)ccr {
    SimpleDBManager* db = [SimpleDBManager getInstance];
    
    FMResultSet *rs = [db.connection executeQuery:@"SELECT * FROM CATEGORY_CANDIDATE_RELATION \
                       WHERE t_category_title = ? AND t_category_user = ? \
                       AND t_candidate_title = ? AND t_candidate_url = ?",
                       ccr.t_category_title,
                       ccr.t_category_user,
                       ccr.t_candidate_title,
                       ccr.t_candidate_url
                       ];
    [db hadError];
    
    if([rs next]) {
        return true;
    }
    
    return false;
}

+(bool)insert:(CategoryCandidateRelation*)ccr {
    SimpleDBManager* db = [SimpleDBManager getInstance];
    bool insert_flg = false;
    
    
    NSLog(@"insert target category candidate relation =");
    NSLog(@"%@",[ccr description]);
    
    insert_flg = [db.connection executeUpdate:@"INSERT INTO CATEGORY_CANDIDATE_RELATION \
                  (t_category_title,t_category_user,t_candidate_title,t_candidate_url,i_del_flg) \
                  VALUES (?,?,?,?,?)",
                  ccr.t_category_title,
                  ccr.t_category_user,
                  ccr.t_candidate_title,
                  ccr.t_candidate_url,
                  [NSNumber numberWithInt:ccr.i_del_flg]];
    
    [db hadError];
    [db commit];
    
    return insert_flg;
}

+(NSMutableArray*)selectAll {
    SimpleDBManager* db = [SimpleDBManager getInstance];
    
    NSMutableArray* categoryCandidateRelationArray = [NSMutableArray new];
    
    FMResultSet *rs = [db.connection executeQuery:@"SELECT * FROM CATEGORY_CANDIDATE_RELATION WHERE i_del_flg = 0 ORDER BY t_title ASC"];
    [db hadError];
    
    while([rs next]) {
        CategoryCandidateRelation *ccr = [[CategoryCandidateRelation alloc] initWithResultSet:rs];
        
        [categoryCandidateRelationArray addObject:ccr];
    }
    
    return categoryCandidateRelationArray;
}

+(NSMutableArray*)selectByCategory:(ElectionCategory*)ec {
    SimpleDBManager* db = [SimpleDBManager getInstance];
    
    NSMutableArray* categoryCandidateRelationArray = [NSMutableArray new];
    
    FMResultSet *rs = [db.connection executeQuery:@"SELECT * FROM CATEGORY_CANDIDATE_RELATION \
                       WHERE t_category_title = ? AND t_category_user = ? \
                       AND i_del_flg = 0 ORDER BY t_title ASC",
                       ec.t_title,ec.t_user];
    [db hadError];
    
    while([rs next]) {
        CategoryCandidateRelation *ccr = [[CategoryCandidateRelation alloc] initWithResultSet:rs];
        
        [categoryCandidateRelationArray addObject:ccr];
    }
    
    return categoryCandidateRelationArray;
}

+(NSMutableArray*)selectCandidatesByCategory:(ElectionCategory*)ec {
    SimpleDBManager* db = [SimpleDBManager getInstance];
    
    NSMutableArray* bookmarkArray = [NSMutableArray new];
    
    FMResultSet *rs = [db.connection executeQuery:@"SELECT bm.* \
                       FROM BOOKMARK bm\
                       WHERE bm.i_del_flg = 0 \
                       AND EXISTS (SELECT * FROM CATEGORY_CANDIDATE_RELATION ccr\
                        WHERE ccr.t_category_title = ? AND ccr.t_category_user = ? \
                          AND ccr.t_candidate_title = bm.t_title \
                          AND ccr.t_candidate_url = bm.t_url) \
                       ORDER BY i_id ASC",
                       ec.t_title,ec.t_user];
    [db hadError];
    
    while([rs next]) {
        Bookmark *bm = [[Bookmark alloc] initWithResultSet:rs];
        
        [bookmarkArray addObject:bm];
    }
    
    return bookmarkArray;
}

+(NSMutableArray*)selectCandidatesByExceptingCategory:(ElectionCategory*)ec {
    SimpleDBManager* db = [SimpleDBManager getInstance];
    
    NSMutableArray* bookmarkArray = [NSMutableArray new];
    
    FMResultSet *rs = [db.connection executeQuery:@"SELECT bm.* \
                       FROM BOOKMARK bm\
                       WHERE bm.i_del_flg = 0 \
                       AND NOT EXISTS (SELECT * FROM CATEGORY_CANDIDATE_RELATION ccr\
                       WHERE ccr.t_category_title = ? AND ccr.t_category_user = ? \
                       AND ccr.t_candidate_title = bm.t_title \
                       AND ccr.t_candidate_url = bm.t_url) \
                       ORDER BY i_id ASC",
                       ec.t_title,ec.t_user];
    [db hadError];
    
    while([rs next]) {
        Bookmark *bm = [[Bookmark alloc] initWithResultSet:rs];
        
        [bookmarkArray addObject:bm];
    }
    
    return bookmarkArray;
}

+(NSMutableArray*)selectByCandidate:(Bookmark*)bm {
    SimpleDBManager* db = [SimpleDBManager getInstance];
    
    NSMutableArray* categoryCandidateRelationArray = [NSMutableArray new];
    
    FMResultSet *rs = [db.connection executeQuery:@"SELECT * FROM CATEGORY_CANDIDATE_RELATION \
                       WHERE t_candidate_title = ? AND t_candidate_url = ? \
                       AND i_del_flg = 0 ORDER BY t_title ASC",
                       bm.t_title,bm.t_url];
    [db hadError];
    
    while([rs next]) {
        CategoryCandidateRelation *ccr = [[CategoryCandidateRelation alloc] initWithResultSet:rs];
        
        [categoryCandidateRelationArray addObject:ccr];
    }
    
    return categoryCandidateRelationArray;
}

+(bool)deleteByPK:(CategoryCandidateRelation*)ccr {
    SimpleDBManager* db = [SimpleDBManager getInstance];
    bool delete_flg = false;
    
    NSLog(@"delete target category candidate relation=");
    NSLog(@"%@",[ccr description]);
    
    delete_flg =  [db.connection executeUpdate:@"DELETE FROM CATEGORY_CANDIDATE_RELATION \
                   WHERE t_category_title = ? AND t_category_user = ? \
                   AND t_candidate_title = ? AND t_candidate_url = ?",
                   ccr.t_category_title,
                   ccr.t_category_user,
                   ccr.t_candidate_title,
                   ccr.t_candidate_url];
    [db hadError];
    [db commit];
    
    return delete_flg;
}

@end
