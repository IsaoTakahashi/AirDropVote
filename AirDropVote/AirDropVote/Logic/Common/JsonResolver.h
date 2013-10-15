//
//  JsonResolver.h
//  AirDropVote
//
//  Created by 高橋 勲 on 2013/10/15.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryCandidateRelation.h"
#import "BookmarkScore.h"

@interface JsonResolver : NSObject

+ (NSData*) createJsonAllDataFromCategory:(ElectionCategory*)ec;
+ (void) resolveAndInsertDataFromJson:(NSData*)jsonData;
@end
