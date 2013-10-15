//
//  JsonResolver.m
//  AirDropVote
//
//  Created by 高橋 勲 on 2013/10/15.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "JsonResolver.h"
#import "ElectionCategoryDAO.h"
#import "BookmarkDAO.h"
#import "CategoryCandidateRelationDAO.h"
#import "BookmarkScoreDAO.h"
#import "UserSettingUtil.h"
#import "UserSettingConstants.h"

@implementation JsonResolver

+ (NSData*) createJsonAllDataFromCategory:(ElectionCategory*)ec {
    NSError *error;
    NSString * jsonListString = @"";
    
    NSMutableArray *relatedBookmark = [CategoryCandidateRelationDAO selectCandidatesByCategory:ec];
    NSString* userName = [UserSettingUtil getStringWithKey:USER_NAME];
    
    //User information
    jsonListString = [jsonListString stringByAppendingString:[NSString stringWithFormat:@"{\"user\":\"%@\"",userName]];
    
    //Election Category information
    jsonListString = [jsonListString stringByAppendingString:@","];
    jsonListString = [jsonListString stringByAppendingString:@"\"category\":"];
    jsonListString = [jsonListString stringByAppendingString:[NSString stringWithFormat:@"{\"t_title\":\"%@\", \"t_user\":\"%@\"",ec.t_title,ec.t_user]];
    //end of Election Category information
    jsonListString = [jsonListString stringByAppendingString:@"}"];
    
    //Bookmark and its score information
    jsonListString = [jsonListString stringByAppendingString:@","];
    jsonListString = [jsonListString stringByAppendingString:@"\"bookmark\":["];
    NSString *jsonStringForBookmarks = @"";
    for(Bookmark *bm in relatedBookmark) {
        if (jsonStringForBookmarks.length > 1) {
            jsonStringForBookmarks = [jsonStringForBookmarks stringByAppendingString:@","];
        }
        
        BookmarkScore *score = [BookmarkScoreDAO selectByBookmark:bm user:userName];
        if (score == nil) {
            score = [[BookmarkScore alloc] init];
            score.t_title = bm.t_title;
            score.t_url = bm.t_url;
            score.t_user = userName;
            score.i_score = 0;
        }
        NSString *jsonString = [NSString stringWithFormat:@"{\"t_title\":\"%@\", \"t_url\":\"%@\", \"t_user\":\"%@\", \"i_score\":\"%i\"}",bm.t_title,bm.t_url,score.t_user,score.i_score];
        jsonStringForBookmarks = [jsonStringForBookmarks stringByAppendingString:jsonString];
        
    }
    //end of Bookmark and its score information
    jsonListString = [jsonListString stringByAppendingString:[jsonStringForBookmarks stringByAppendingString:@"]"]];
    
    
    //end of json
    jsonListString = [jsonListString stringByAppendingString:@"}"];
    
    NSLog(@"%@",jsonListString);
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:
                          [jsonListString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:kNilOptions error:&error];
    NSLog(@"%@ %@"
          ,[[NSString alloc]
            initWithData:jsonData
            encoding:NSUTF8StringEncoding]
          ,error);
    
    return jsonData;
}

+ (void) resolveAndInsertDataFromJson:(NSData*)jsonData {
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    NSLog(@"%@",[jsonDic description]);
    if ([jsonDic objectForKey:@"user"]) {
        NSLog(@"user is : %@",[jsonDic objectForKey:@"user"]);
    }
    
    ElectionCategory *ec = nil;
    NSDictionary *jsonForEC = [jsonDic objectForKey:@"category"];
    if (jsonForEC) {
        ec = [[ElectionCategory alloc] initWithJson:jsonForEC];
        NSLog(@"%@",[ec description]);
        
        if([ElectionCategoryDAO exists:ec]) {
            NSLog(@"electioncategory already exists, name is : %@",ec.t_title);
        } else {
            [ElectionCategoryDAO insert:ec];
        }
        
    }
    
    NSArray *jsonForBookmarks = [jsonDic objectForKey:@"bookmark"];
    if (jsonForBookmarks) {
        for(NSDictionary *dicBookmark in jsonForBookmarks) {
            Bookmark *bm = [[Bookmark alloc] initWithJson:dicBookmark];
            
            if ([BookmarkDAO exists:bm]) {
                NSLog(@"bookmark already exists, title is : %@",bm.t_title);
            } else {
                [BookmarkDAO insert:bm];
            }
            
            //register score
            BookmarkScore *bs = [[BookmarkScore alloc] initWithJson:dicBookmark];
            if ([BookmarkScoreDAO exists:bs]) {
                NSLog(@"bookmark score updates to : %i",bs.i_score);
                [BookmarkScoreDAO updateScore:bs];
            } else {
                [BookmarkScoreDAO insert:bs];
            }
            
            //register relation
            if (ec != nil) {
                CategoryCandidateRelation * ccr = [[CategoryCandidateRelation alloc] initWithCategory:ec Bookmark:bm];
                
                if ([CategoryCandidateRelationDAO exists:ccr]) {
                    NSLog(@"bookmark relation already exists, title is : %@",bm.t_title);
                } else {
                    [CategoryCandidateRelationDAO insert:ccr];
                }
            }
            
        }
    }
    
    return;
}

@end
