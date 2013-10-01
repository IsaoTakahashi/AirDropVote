//
//  CandidatesListViewController.m
//  AirDropVote
//
//  Created by 高橋 勲 on 2013/10/01.
//  Copyright (c) 2013年 高橋 勲. All rights reserved.
//

#import "CandidatesListViewController.h"
#import "FileUtil.h"

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
    self.bookmarkList = [BookmarkDAO selectAll];
    return self.bookmarkList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CandidateCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Bookmark *bm = self.bookmarkList[indexPath.row];
    cell.textLabel.text = bm.t_title;
    
    return cell;
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
        [self.tableView reloadData];
    }
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
    }
}


- (IBAction)clickedActionButton:(id)sender {
    NSData *data = [Bookmark toJsonList:self.bookmarkList];
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    for (NSDictionary *dict in jsonArray) {
        Bookmark *bmm = [[Bookmark alloc] initWithJson:dict];
        NSLog(@"%@", [bmm description]);
    }
    NSString *jsonString = [FileUtil data2str:data];
    
    UIActivityViewController *activityCtr = [[UIActivityViewController alloc] initWithActivityItems:@[jsonString]
                                                                              applicationActivities:nil];
    [self presentViewController:activityCtr
                       animated:YES
                     completion:nil];
    NSLog(@"action");
}
@end
