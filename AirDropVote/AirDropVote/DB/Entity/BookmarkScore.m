//
//  BookmarkScore.m
//  AirDropVote
//
//  Created by 高橋 勲 on 2013/10/02.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "BookmarkScore.h"

@implementation BookmarkScore

-(id)initWithJson:(NSDictionary*)jsonObject {
    if(self = [super init]) {
        self.t_title = [jsonObject objectForKey:@"t_title"];
        self.t_url = [jsonObject objectForKey:@"t_url"];
        self.t_user = [jsonObject objectForKey:@"t_user"];
        self.i_score = [[jsonObject objectForKey:@"i_score"] intValue];
        
        self.i_del_flg = 0;
    }
    
    return self;
}

-(id)initWithResultSet:(FMResultSet*)rs {
    if (self = [super init]) {
        self.t_title = [rs stringForColumn:@"t_title"];
        self.t_url = [rs stringForColumn:@"t_url"];
        self.t_user = [rs stringForColumn:@"t_user"];
        self.i_score = [rs intForColumn:@"i_score"];
        
        self.d_insert = [NSDate dateWithTimeIntervalSince1970:[rs longForColumn:@"d_insert"]];
    }
    
    return self;
}

@end
