//
//  ElectionCategoryDAO.m
//  AirDropVote
//
//  Created by 高橋 勲 on 2013/10/05.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "ElectionCategoryDAO.h"
#import "SimpleDBManager.h"

@implementation ElectionCategoryDAO

+(bool)exists:(ElectionCategory*)ec {
    SimpleDBManager* db = [SimpleDBManager getInstance];
    
    FMResultSet *rs = [db.connection executeQuery:@"SELECT * FROM ELECTION_CATEGORY \
                       WHERE t_title = ? AND t_user = ?",
                       ec.t_title,
                       ec.t_user
                       ];
    [db hadError];
    
    if([rs next]) {
        return true;
    }
    
    return false;
}

+(bool)insert:(ElectionCategory*)ec {
    SimpleDBManager* db = [SimpleDBManager getInstance];
    bool insert_flg = false;
    
    ec.d_insert = [NSDate date];
    
    NSLog(@"insert target election category =");
    NSLog(@"%@",[ec description]);
    
    insert_flg = [db.connection executeUpdate:@"INSERT INTO ELECTION_CATEGORY \
                  (t_title,t_user,d_insert,i_del_flg) \
                  VALUES (?,?,?,?)",
                  ec.t_title,
                  ec.t_user,
                  [NSNumber numberWithLong:[ec.d_insert timeIntervalSince1970]],
                  [NSNumber numberWithInt:ec.i_del_flg]];
    
    [db hadError];
    [db commit];
    
    return insert_flg;
}

+(NSMutableArray*)selectAll {
    SimpleDBManager* db = [SimpleDBManager getInstance];
    
    NSMutableArray* electionCategoryArray = [NSMutableArray new];
    
    FMResultSet *rs = [db.connection executeQuery:@"SELECT * FROM ELECTION_CATEGORY WHERE i_del_flg = 0 ORDER BY t_title ASC"];
    [db hadError];
    
    while([rs next]) {
        ElectionCategory *ec = [[ElectionCategory alloc] initWithResultSet:rs];
        
        [electionCategoryArray addObject:ec];
    }
    
    return electionCategoryArray;
}

+(NSMutableArray*)selectByUser:(NSString*)user {
    SimpleDBManager* db = [SimpleDBManager getInstance];
    
    NSMutableArray* electionCategoryArray = [NSMutableArray new];
    
    FMResultSet *rs = [db.connection executeQuery:@"SELECT * FROM ELECTION_CATEGORY \
                       WHERE t_user = ? AND i_del_flg = 0 \
                       ORDER BY t_title ASC",
                       user];
    [db hadError];
    
    while([rs next]) {
        ElectionCategory *ec = [[ElectionCategory alloc] initWithResultSet:rs];
        
        [electionCategoryArray addObject:ec];
    }
    
    return electionCategoryArray;
}

+(NSMutableArray*)selectByTitle:(NSString*)title {
    SimpleDBManager* db = [SimpleDBManager getInstance];
    
    NSMutableArray* electionCategoryArray = [NSMutableArray new];
    
    FMResultSet *rs = [db.connection executeQuery:@"SELECT * FROM ELECTION_CATEGORY \
                       WHERE t_title = ? AND i_del_flg = 0 \
                       ORDER BY t_title ASC",
                       title];
    [db hadError];
    
    while([rs next]) {
        ElectionCategory *ec = [[ElectionCategory alloc] initWithResultSet:rs];
        
        [electionCategoryArray addObject:ec];
    }
    
    return electionCategoryArray;
}

+(ElectionCategory*)selectByTitle:(NSString*)title user:(NSString*)user {
    SimpleDBManager* db = [SimpleDBManager getInstance];
    
    FMResultSet *rs = [db.connection executeQuery:@"SELECT * FROM ELECTION_CATEGORY \
                       WHERE t_title = ? AND t_user = ? AND i_del_flg = 0 \
                       ORDER BY t_title ASC",
                       title,
                       user];
    [db hadError];
    
    if([rs next]) {
        ElectionCategory *ec = [[ElectionCategory alloc] initWithResultSet:rs];
        
        return ec;
    }
    
    return nil;
}

+(bool)deleteByPK:(ElectionCategory*)ec {
    SimpleDBManager* db = [SimpleDBManager getInstance];
    bool delete_flg = false;
    
    NSLog(@"delete target election category =");
    NSLog(@"%@",[ec description]);
    
    delete_flg =  [db.connection executeUpdate:@"DELETE FROM ELECTION_CATEGORY WHERE t_tile = ? AND t_user = ?",
                   ec.t_title,ec.t_user];
    [db hadError];
    [db commit];
    
    return delete_flg;
}

@end
