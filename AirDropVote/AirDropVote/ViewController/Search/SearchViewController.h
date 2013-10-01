//
//  SearchViewController.h
//  AirDropVote
//
//  Created by 高橋 勲 on 2013/10/01.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bookmark.h"

typedef enum BookmarkServiceType : NSUInteger {
    NONE,
    FACEBOOK,
    TWITTER,
    HATENA
} BookmarkServiceType;

@protocol SearchViewControllerDelegate <NSObject>

-(void)selectedBookmarkURL:(Bookmark*)bm;

@end

@interface SearchViewController : UIViewController<UISearchBarDelegate,UIWebViewDelegate>

@property (nonatomic) id<SearchViewControllerDelegate> delegate;
@property (nonatomic) Bookmark *bookmark;
@property (nonatomic) BookmarkServiceType bsType;

-(void)initializeWithBookmark:(Bookmark*)bm;

//outlet
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bookMarkButton;

@end
