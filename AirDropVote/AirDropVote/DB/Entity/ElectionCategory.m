//
//  ElectionCategory.m
//  AirDropVote
//
//  Created by 高橋 勲 on 2013/10/05.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "ElectionCategory.h"

@implementation ElectionCategory

-(id)initWithJson:(NSDictionary*)jsonObject {
    if(self = [super init]) {
        self.t_title = [jsonObject objectForKey:@"t_title"];
        self.t_user = [jsonObject objectForKey:@"t_user"];
        
        self.i_del_flg = 0;
    }
    
    return self;
}

-(id)initWithResultSet:(FMResultSet*)rs {
    if (self = [super init]) {
        self.t_title = [rs stringForColumn:@"t_title"];
        self.t_user = [rs stringForColumn:@"t_user"];
        
        self.d_insert = [NSDate dateWithTimeIntervalSince1970:[rs longForColumn:@"d_insert"]];
        self.i_del_flg = [rs intForColumn:@"i_del_flg"];
    }
    
    return self;
}

@end
