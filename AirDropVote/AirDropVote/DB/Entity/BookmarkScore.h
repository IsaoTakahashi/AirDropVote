//
//  BookmarkScore.h
//  AirDropVote
//
//  Created by 高橋 勲 on 2013/10/02.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"

@interface BookmarkScore : NSObject

@property (nonatomic) NSString* t_user;
@property (nonatomic) NSString* t_title;
@property (nonatomic) NSString* t_url;
@property (nonatomic) int i_score;
@property (nonatomic) NSDate* d_insert;
@property (nonatomic) int i_del_flg;


-(id)initWithJson:(NSArray*)jsonObject;
-(id)initWithResultSet:(FMResultSet*)rs;

@end
