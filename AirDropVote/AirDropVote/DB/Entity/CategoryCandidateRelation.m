//
//  CategoryCandidateRelation.m
//  AirDropVote
//
//  Created by 高橋 勲 on 2013/10/05.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "CategoryCandidateRelation.h"

@implementation CategoryCandidateRelation

-(id)initWithJson:(NSArray*)jsonObject {
    if(self = [super init]) {
        for (NSDictionary *obj in jsonObject) {
            self.t_category_title = [obj objectForKey:@"t_category_title"];
            self.t_category_user = [obj objectForKey:@"t_category_user"];
            self.t_candidate_title = [obj objectForKey:@"t_candidate_title"];
            self.t_candidate_url = [obj objectForKey:@"t_candidate_url"];
            
            self.i_del_flg = 0;
        }
    }
    
    return self;
}

-(id)initWithResultSet:(FMResultSet*)rs {
    if (self = [super init]) {
        self.t_category_title = [rs stringForColumn:@"t_category_title"];
        self.t_category_user = [rs stringForColumn:@"t_category_user"];
        self.t_candidate_title = [rs stringForColumn:@"t_candidate_title"];
        self.t_candidate_url = [rs stringForColumn:@"t_candidate_url"];
        
        self.i_del_flg = [rs intForColumn:@"i_del_flg"];
    }
    
    return self;
}

-(id)initWithCategory:(ElectionCategory*)ec Bookmark:(Bookmark*)bm {
    
    if (self = [super init]) {
        self.t_category_title = ec.t_title;
        self.t_category_user = ec.t_user;
        self.t_candidate_title = bm.t_title;
        self.t_candidate_url = bm.t_url;
    }
    
    return self;
}

@end
