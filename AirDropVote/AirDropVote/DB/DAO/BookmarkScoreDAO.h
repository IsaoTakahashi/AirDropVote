//
//  BookmarkScoreDAO.h
//  AirDropVote
//
//  Created by 高橋 勲 on 2013/10/02.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookmarkScore.h"
#import "SimpleDBManager.h"
#import "Bookmark.h"

@interface BookmarkScoreDAO : NSObject


+(bool)exists:(BookmarkScore*)bs;
+(bool)insert:(BookmarkScore*)bs;
+(bool)updateScore:(BookmarkScore*)bs;
+(NSMutableArray*)selectAll;
+(NSMutableArray*)selectByUser:(NSString*)user;
+(NSMutableArray*)selectByBookmark:(Bookmark*)bm;
+(BookmarkScore*)selectByBookmark:(Bookmark*)bm user:(NSString*)user;
+(bool)deleteByPK:(BookmarkScore*)bs;

@end
