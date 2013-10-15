//
//  CandidatesListViewController.m
//  AirDropVote
//
//  Created by 高橋 勲 on 2013/10/01.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "CandidatesListViewController.h"
#import "BookmarkScoreDAO.h"
#import "FileUtil.h"
#import "JsonResolver.h"
#import "TDBadgedCell.h"
#import "UserSettingConstants.h"

@interface CandidatesListViewController ()

@end

@implementation CandidatesListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bookmarkList = [NSMutableArray new];
    if (self.electionCategory != nil) {
        self.navigationItem.title = self.electionCategory.t_title;
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.electionCategory == nil || [self.electionCategory.t_title isEqual:@"All"]) {
        self.bookmarkList = [BookmarkDAO selectAll];
        self.addCandidateButton.enabled = false;
        self.searchButton.enabled = false;
    } else {
        self.bookmarkList = [CategoryCandidateRelationDAO selectCandidatesByCategoryOrderedByTotalScore:self.electionCategory];
        self.addCandidateButton.enabled = true;
        self.searchButton.enabled = true;
        
        //NSData *jsonData = [JsonResolver createJsonAllDataFromCategory:self.electionCategory];
        //[JsonResolver resolveAndInsertDataFromJson:jsonData];
    }
    
    return self.bookmarkList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CandidateCell";
    TDBadgedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[TDBadgedCell alloc]
                 initWithStyle:UITableViewCellStyleSubtitle
                 reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    Bookmark *bm = self.bookmarkList[indexPath.row];
    cell.textLabel.text = bm.t_title;
    cell.detailTextLabel.text = @"your score: - ";
    
    NSMutableArray* scoreArray = [BookmarkScoreDAO selectByBookmark:bm];
    int totalScore = 0;
    for(BookmarkScore *bs in scoreArray) {
        totalScore += bs.i_score;
        if ([bs.t_user isEqualToString:[UserSettingUtil getStringWithKey:USER_NAME]]) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"your score: %i",bs.i_score];
        }
    }
    
    cell.badgeString = [NSString stringWithFormat:@"%i",totalScore];
    cell.badgeColor = [UIColor orangeColor];
    
    if (indexPath.row == 0) {
        cell.backgroundColor = [UIColor colorWithRed:0.6 green:0.8 blue:0.9 alpha:0.2];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Bookmark* bm = self.bookmarkList[indexPath.row];
    
    self.ssViewCtr = [[SettingScoreViewController alloc] initWithNibName:@"SettingScoreViewController" bundle:nil];
    
    self.ssViewCtr.delegate = self;
    self.ssViewCtr.bm = [Bookmark bookmarkWithBookmark:bm];
    
    
    CGRect window = [[UIScreen mainScreen] bounds];
    self.ssViewCtr.view.center = CGPointMake(window.size.width/2, window.size.height/2);
    [self.ssViewCtr.view setAlpha:0.1];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelay:0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [self.ssViewCtr.view setAlpha:1.0];
    
    [UIView commitAnimations];
    
    [self.view.superview addSubview:self.ssViewCtr.view];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

#pragma mark -
#pragma mark SearchViewControllerDelegate
-(void)selectedBookmarkURL:(Bookmark*)bm {
    if ([BookmarkDAO exists:bm]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Bookmark" message:@"This bookmark is already exists" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
    } else {
        [BookmarkDAO insert:bm];
        CategoryCandidateRelation *ccs = [[CategoryCandidateRelation alloc] initWithCategory:self.electionCategory Bookmark:bm];
        
        [CategoryCandidateRelationDAO insert:ccs];
        
        [self.tableView reloadData];
    }
}

#pragma makr -
#pragma mark AddCandidateListViewControllerDelegate
-(void)addCandidate:(Bookmark *)bm {
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"PushSearchButton"]) {
        SearchViewController *viewController = (SearchViewController*)[segue destinationViewController];
        
        Bookmark * bm = [[Bookmark alloc] initWithTitle:@""];
        
        [viewController initializeWithBookmark:bm];
        viewController.delegate = self;
    } else if ([[segue identifier] isEqualToString:@"PushSpecificCandidate"]) {
        SearchViewController *viewController = (SearchViewController*)[segue destinationViewController];
        
        int index = (int)[self.tableView indexPathForCell:sender].row;
        Bookmark * bm = self.bookmarkList[index];
        
        [viewController initializeWithBookmark:bm];
        viewController.delegate = self;
    } else if ([[segue identifier] isEqualToString:@"AddCandidateSegue"]) {
        AddCandidateListViewController *viewController = (AddCandidateListViewController*)[segue destinationViewController];
        viewController.electionCategory = self.electionCategory;
        viewController.delegate = self;
    }
}


- (IBAction)clickedActionButton:(id)sender {
    //NSData *data = [Bookmark toJsonList:self.bookmarkList];
    NSData *data = [JsonResolver createJsonAllDataFromCategory:self.electionCategory];
    /*
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    for (NSDictionary *dict in jsonArray) {
        Bookmark *bmm = [[Bookmark alloc] initWithJson:dict];
        NSLog(@"%@", [bmm description]);
    }*/
    NSString *jsonString = [FileUtil data2str:data];
    
    UIActivityViewController *activityCtr = [[UIActivityViewController alloc] initWithActivityItems:@[jsonString]
                                                                              applicationActivities:nil];
    [self presentViewController:activityCtr
                       animated:YES
                     completion:nil];
    NSLog(@"action");
}

- (void)setBookmarkScore:(BookmarkScore *)bs {
    [self.ssViewCtr.view removeFromSuperview];
    
    if (bs != nil) {
        if([BookmarkScoreDAO exists:bs]) {
            [BookmarkScoreDAO updateScore:bs];
        } else {
            [BookmarkScoreDAO insert:bs];
        }
    }
    
    [self.tableView reloadData];
}

@end
