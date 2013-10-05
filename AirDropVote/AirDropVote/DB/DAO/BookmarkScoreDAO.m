//
//  BookmarkScoreDAO.m
//  AirDropVote
//
//  Created by 高橋 勲 on 2013/10/02.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "BookmarkScoreDAO.h"

@implementation BookmarkScoreDAO

+(bool)exists:(BookmarkScore*)bs {
    SimpleDBManager* db = [SimpleDBManager getInstance];
    
    FMResultSet *rs = [db.connection executeQuery:@"SELECT * FROM BOOKMARK_SCORE \
                       WHERE t_title = ? AND t_url = ? AND t_user = ?",
                       bs.t_title,
                       bs.t_url,
                       [UserSettingUtil getStringWithKey:@"user_name"]
                       ];
    [db hadError];
    
    if([rs next]) {
        return true;
    }
    
    return false;
}

+(bool)insert:(BookmarkScore*)bs {
    SimpleDBManager* db = [SimpleDBManager getInstance];
    bool insert_flg = false;
    
    bs.d_insert = [NSDate date];
    
    NSLog(@"insert target bookmark score =");
    NSLog(@"%@",[bs description]);
    
    insert_flg = [db.connection executeUpdate:@"INSERT INTO BOOKMARK_SCORE \
                  (t_title,t_url,t_user,i_score,d_insert,i_del_flg) \
                  VALUES (?,?,?,?,?,?)",
                  bs.t_title,bs.t_url,
                  bs.t_user,
                  [NSNumber numberWithInt:bs.i_score],
                  [NSNumber numberWithLong:[bs.d_insert timeIntervalSince1970]],
                  [NSNumber numberWithInt:bs.i_del_flg]];
    
    [db hadError];
    [db commit];
    
    return insert_flg;
}

+(bool)updateScore:(BookmarkScore*)bs {
    
    SimpleDBManager* db = [SimpleDBManager getInstance];
    bool update_flg = false;
    
    NSLog(@"insert update bookmark score =");
    NSLog(@"%@",[bs description]);
    
    update_flg = [db.connection executeUpdate:@"UPDATE BOOKMARK_SCORE \
                  SET i_score = ? \
                  WHERE t_title =? AND t_url = ? AND t_user = ?",
                  [NSNumber numberWithInt:bs.i_score],
                  bs.t_title,
                  bs.t_url,
                  bs.t_user];
    
    [db hadError];
    //[db commit];
    
    return update_flg;
}

+(NSMutableArray*)selectAll {
    SimpleDBManager* db = [SimpleDBManager getInstance];
    
    NSMutableArray* bookmarkScoreArray = [NSMutableArray new];
    
    FMResultSet *rs = [db.connection executeQuery:@"SELECT * FROM BOOKMARK_SCORE WHERE i_del_flg = 0 ORDER BY t_title ASC"];
    [db hadError];
    
    while([rs next]) {
        BookmarkScore *bs = [[BookmarkScore alloc] initWithResultSet:rs];
        
        [bookmarkScoreArray addObject:bs];
    }
    
    return bookmarkScoreArray;
}

+(NSMutableArray*)selectByUser:(NSString*)user {
    SimpleDBManager* db = [SimpleDBManager getInstance];
    
    NSMutableArray* bookmarkScoreArray = [NSMutableArray new];
    
    FMResultSet *rs = [db.connection executeQuery:@"SELECT * FROM BOOKMARK_SCORE \
                       WHERE t_user = ? AND i_del_flg = 0 ORDER BY t_title ASC",
                       user];
    [db hadError];
    
    while([rs next]) {
        BookmarkScore *bs = [[BookmarkScore alloc] initWithResultSet:rs];
        
        [bookmarkScoreArray addObject:bs];
    }
    
    return bookmarkScoreArray;
}

+(NSMutableArray*)selectByBookmark:(Bookmark*)bm {
    SimpleDBManager* db = [SimpleDBManager getInstance];
    
    NSMutableArray* bookmarkScoreArray = [NSMutableArray new];
    
    FMResultSet *rs = [db.connection executeQuery:@"SELECT * FROM BOOKMARK_SCORE \
                       WHERE t_title = ? AND t_url = ? AND i_del_flg = 0 ORDER BY t_user ASC",
                       bm.t_title,bm.t_url];
    [db hadError];
    
    while([rs next]) {
        BookmarkScore *bs = [[BookmarkScore alloc] initWithResultSet:rs];
        
        [bookmarkScoreArray addObject:bs];
    }
    
    return bookmarkScoreArray;
}

+(BookmarkScore*)selectByBookmark:(Bookmark*)bm user:(NSString*)user {
    SimpleDBManager* db = [SimpleDBManager getInstance];
    
    FMResultSet *rs = [db.connection executeQuery:@"SELECT * FROM BOOKMARK_SCORE \
                       WHERE t_title = ? AND t_url = ? AND t_user = ? AND i_del_flg = 0 ORDER BY t_user ASC",
                       bm.t_title,bm.t_url,user];
    [db hadError];
    
    if([rs next]) {
        BookmarkScore *bs = [[BookmarkScore alloc] initWithResultSet:rs];
        
        return bs;
    }
    
    return nil;
}

+(bool)deleteByPK:(BookmarkScore*)bs {
    SimpleDBManager* db = [SimpleDBManager getInstance];
    bool delete_flg = false;
    
    NSLog(@"delete target bookmark score =");
    NSLog(@"%@",[bs description]);
    
    delete_flg =  [db.connection executeUpdate:@"DELETE FROM BOOKMARK_SCORE WHERE t_tile = ? AND t_url = ? AND t_user = ?",
                   bs.t_title,bs.t_url,bs.t_user];
    [db hadError];
    [db commit];
    
    return delete_flg;
}

@end
