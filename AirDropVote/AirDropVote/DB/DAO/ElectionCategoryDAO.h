//
//  ElectionCategoryDAO.h
//  AirDropVote
//
//  Created by 高橋 勲 on 2013/10/05.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ElectionCategory.h"

@interface ElectionCategoryDAO : NSObject

+(bool)exists:(ElectionCategory*)ec;
+(bool)insert:(ElectionCategory*)ec;
+(NSMutableArray*)selectAll;
+(NSMutableArray*)selectByUser:(NSString*)user;
+(NSMutableArray*)selectByTitle:(NSString*)title;
+(ElectionCategory*)selectByTitle:(NSString*)title user:(NSString*)user;
+(bool)deleteByPK:(ElectionCategory*)ec;

@end
