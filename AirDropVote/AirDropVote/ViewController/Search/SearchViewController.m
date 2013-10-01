//
//  SearchViewController.m
//  AirDropVote
//
//  Created by 高橋 勲 on 2013/10/01.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "SearchViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+URLEncoding.h"
#import "NSString+Validate.h"
#import "MBProgressHUD.h"

@interface SearchViewController ()

@end

static const NSString *baseURLString = @"https://www.google.co.jp/search";

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.bsType = NONE;
    }
    return self;
}

-(void)initializeWithBookmark:(Bookmark*)bm {
    self.bookmark = bm;
    
    if (self.bookmark.i_base_service <= 0) {
        self.bsType = NONE;
    } else {
        self.bsType = self.bookmark.i_base_service;
    }
    
    self.searchBar.text = self.bookmark.t_title;
    
    if (![self.bookmark.t_url isEmpty]) {
        [self searchOnWebViewWithURL:[NSURL URLWithString:self.bookmark.t_url]];
    } else if (![self.searchBar.text isEmpty]) {
        [self searchOnWebView:self.bsType];
    }
}

-(void)searchOnWebViewWithURL:(NSURL*)url {
    if (url != nil) {
        [MBProgressHUD showHUDAddedTo:self.webView animated:YES];
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
}

-(void)searchOnWebView:(BookmarkServiceType)type {
    NSURL *url = nil;
    
    switch (type) {
        case NONE:
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?q=%@",baseURLString,[self.searchBar.text escapedString]]];
            break;
        case FACEBOOK:
            break;
        case TWITTER:
            break;
        case HATENA:
            break;
        default:
            break;
    }
    
    [self searchOnWebViewWithURL:url];
}

#pragma mark -
#pragma mark SearchBar Delegate
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self searchOnWebView:self.bsType];
}

-(void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar {
    NSString* title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSString* url = [self.webView stringByEvaluatingJavaScriptFromString:@"document.URL"];
    
    self.bookmark.t_title = title;
    self.bookmark.i_base_service = self.bsType;
    self.bookmark.t_url = url;
    
    [self.delegate selectedBookmarkURL:self.bookmark];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"cancel");
}

#pragma mark -
#pragma mark UIWebView Delegate
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideAllHUDsForView:self.webView animated:YES];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.webView animated:YES];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
