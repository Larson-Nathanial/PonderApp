//
//  PonderViewController.m
//  Ponderize
//
//  Created by Nathan Larson on 10/5/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import "PonderViewController.h"
#import "WorldPonderCell.h"
#import "AddPonder.h"
#import "Connection.h"
#import "MyScriptureViewController.h"
#import "WriteCommentViewController.h"
#import "CommentsViewController.h"

@interface PonderViewController ()<UITableViewDataSource, UITableViewDelegate>

//@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *posts;
@property (nonatomic) NSArray *groups;
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIView *coverView;
@property (nonatomic) UILabel *noIdeasLabel;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) NSDate *dd1;
@property (nonatomic) NSDateFormatter *f1;
@property (nonatomic) NSDateFormatter *f2;
@property (nonatomic) NSDateFormatter *f3;
@property (nonatomic) NSString *sd1;

@property (nonatomic) UIImageView *backgroundImageView;

@property (nonatomic) NSString *currentGroupId;
@property (nonatomic) NSString *currentGroupName;

@end

@implementation PonderViewController

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    
    _currentGroupId = nil;
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"Ponder";
    _titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.0];
    _titleLabel.frame = CGRectMake(0, 0, 150, 30);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = _titleLabel;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:67.0 / 255.0 green:213.0 / 255.0 blue:81.0 / 255.0 alpha:0.5];

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor colorWithWhite:245.0/ 255.0  alpha:1.0];
    self.refreshControl.tintColor = [UIColor colorWithRed:67.0 / 255.0 green:213.0 / 255.0 blue:81.0 / 255.0 alpha:1.0];
    [self.refreshControl addTarget:self
                            action:@selector(loadVerses)
                  forControlEvents:UIControlEventValueChanged];
    
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10.0, 64.0, self.view.bounds.size.width - 20.0, self.view.bounds.size.height - 0.0) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setShowsHorizontalScrollIndicator:NO];
    [_tableView setShowsVerticalScrollIndicator:NO];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WorldPonderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WorldPonderCell class])];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self.view addSubview:_tableView];
    
    _coverView = [UIView new];
    _coverView.frame = self.view.frame;
    _coverView.backgroundColor = [UIColor colorWithWhite:100.0 / 255.0 alpha:0.8];
    [self.view addSubview:_coverView];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicator.center = self.view.center;
    [_activityIndicator startAnimating];
    [_coverView addSubview:_activityIndicator];
    _coverView.alpha = 0.0;
    
    
    _f1 = [[NSDateFormatter alloc] init];
    [_f1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _f2 = [[NSDateFormatter alloc] init];
    [_f2 setDateStyle:NSDateFormatterLongStyle];
    _f3 = [[NSDateFormatter alloc] init];
    [_f3 setDateFormat:@"H:mm a"];
    
}

- (void)viewDidAppear:(BOOL)animated
{
//    _tableView.frame = CGRectMake(10.0, 64.0, self.view.bounds.size.width - 20.0, self.view.bounds.size.height - 0.0);
    [_tableView addSubview:self.refreshControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadGroups];
}

- (void)loadGroups
{
    
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        
        _groups = [[Connection connection] loadGroupsForUser];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _currentGroupId = [_groups[0] valueForKey:@"id"];
            _titleLabel.text = @"Just Me";
            [self loadVerses];
            [UIView animateWithDuration:0.5 animations:^{
                _coverView.alpha = 0.0;
            }];
        });
    });
}

- (void)loadVerses
{
    
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        
        
        
        _posts = [[Connection connection] loadPostsForGroup:_currentGroupId];
        
        
//        NSMutableArray *mArray = [NSMutableArray arrayWithArray:_groups];
        
//        NSDictionary *dic2 = @{@"group_name":@"Just Me", @"id":@"0"};
        
//        [mArray insertObject:dic2 atIndex:0];
        
//        _groups = [NSArray arrayWithArray:mArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
            [UIView animateWithDuration:0.5 animations:^{
                _coverView.alpha = 0.0;
            }];
        });
    });
    
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:67.0 / 255.0 green:213.0 / 255.0 blue:81.0 / 255.0 alpha:1.0]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *aView = [UIView new];
    if (section == 0) {
        aView.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, 10.0);
    }else {
        aView.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, 5.0);
    }
    
    aView.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    return aView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *aView = [UIView new];
    if (section == _posts.count - 1) {
        aView.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, 10.0);
    }else {
        aView.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, 5.0);
    }
    
    aView.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    return aView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10.0;
    }
    return 5.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == _posts.count - 1) {
        return 10.0;
    }
    return 5.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _posts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 270.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorldPonderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WorldPonderCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.postName.text = [_posts[indexPath.section] valueForKey:@"users_name"];
    
    NSString *verseText = nil;
    
    if ([[_posts[indexPath.section] valueForKey:@"book"] isEqualToString:@"none"]) {
        verseText = [_posts[indexPath.section] valueForKey:@"verse"];
    }else {
        if ([[_posts[indexPath.section] valueForKey:@"verse1"] intValue] == [[_posts[indexPath.section] valueForKey:@"verse2"] intValue]) {
            verseText = [NSString stringWithFormat:@"%@ %@:%@ \n %@", [_posts[indexPath.section] valueForKey:@"book"],[_posts[indexPath.section] valueForKey:@"chapter"], [_posts[indexPath.section] valueForKey:@"verse1"], [_posts[indexPath.section] valueForKey:@"verse"]];
        }else {
            verseText = [NSString stringWithFormat:@"%@ %@:%@ - %@ \n %@", [_posts[indexPath.section] valueForKey:@"book"],[_posts[indexPath.section] valueForKey:@"chapter"], [_posts[indexPath.section] valueForKey:@"verse1"], [_posts[indexPath.section] valueForKey:@"verse2"], [_posts[indexPath.section] valueForKey:@"verse"]];
        }
    }
    
    cell.postText.text = verseText;
    
    _sd1 = [_posts[indexPath.section] valueForKey:@"creation_date"];
    _dd1 = [_f1 dateFromString:_sd1];
    cell.postDate.text = [NSString stringWithFormat:@"%@ @ %@", [_f2 stringFromDate:_dd1], [_f3 stringFromDate:_dd1]];
    
    if ([[_posts[indexPath.section] valueForKey:@"like_count"] intValue] == 1) {
        cell.likesText.text = [NSString stringWithFormat:@"%i like", [[_posts[indexPath.section] valueForKey:@"like_count"] intValue]];
    }else {
        cell.likesText.text = [NSString stringWithFormat:@"%i likes", [[_posts[indexPath.section] valueForKey:@"like_count"] intValue]];
    }
    
    if ([[_posts[indexPath.section] valueForKey:@"comment_count"] intValue] == 1) {
        cell.commentsOutlet.text = [NSString stringWithFormat:@"%i comment", [[_posts[indexPath.section] valueForKey:@"comment_count"] intValue]];
    }else {
        cell.commentsOutlet.text = [NSString stringWithFormat:@"%i comments", [[_posts[indexPath.section] valueForKey:@"comment_count"] intValue]];
    }
    
    if ([[_posts[indexPath.section] valueForKey:@"liked"] intValue] == 1) {
        
        cell.likeButtonOutlet.alpha = 0.0;
        cell.likedButtonOutlet.alpha = 1.0;
    }else {
        
        cell.likedButtonOutlet.alpha = 0.0;
        cell.likeButtonOutlet.alpha = 1.0;
    }
    
    cell.viewMoreActionButton = ^(id sender){
        MyScriptureViewController *viewController = [MyScriptureViewController new];
        viewController.postObject = _posts[indexPath.section];
        viewController.fromFeed = YES;
        [self presentViewController:viewController animated:YES completion:nil];
    };
    
    
    
    CGSize sizeOfText = [verseText boundingRectWithSize:CGSizeMake(cell.postText.frame.size.width, CGFLOAT_MAX)
                                                options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                             attributes:@{ NSFontAttributeName : cell.postText.font }
                                                context: nil].size;
    CGSize frameSize = cell.postText.frame.size;
    if (frameSize.height - 3.0 < ceilf(sizeOfText.height))
    {
        cell.viewMoreOutlet.alpha = 1.0;
    }else {
        cell.viewMoreOutlet.alpha = 0.0;
    }
    
    UITapGestureRecognizer *tapIt = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCommentsForSection:)];
    tapIt.numberOfTapsRequired = 1;
    for (int i = 0; i < cell.commentsOutlet.gestureRecognizers.count; i++) {
        [cell.commentsOutlet.gestureRecognizers[i] removeTarget:self action:@selector(tappedCommentsForSection:)];
    }
    
    cell.commentsOutlet.tag = indexPath.section;
    
    [cell.commentsOutlet addGestureRecognizer:tapIt];
    cell.commentsOutlet.userInteractionEnabled = YES;
    
    cell.commentAction = ^(id sender){
        WriteCommentViewController *viewController = [WriteCommentViewController new];
        viewController.post_id = [_posts[indexPath.section] valueForKey:@"post_id"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
        [self presentViewController:nav animated:YES completion:nil];
    };
    
    cell.likeAction = ^(id sender){
        
        dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(aQueue, ^{
            
            [[Connection connection] didLikePostId:[_posts[indexPath.section] valueForKey:@"post_id"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableArray *mArray = [NSMutableArray arrayWithArray:_posts];
                NSMutableDictionary *mDictionary = [NSMutableDictionary dictionaryWithDictionary:mArray[indexPath.section]];
                [mDictionary setValue:@"1" forKey:@"liked"];
                int curVal = [[mDictionary valueForKey:@"like_count"]intValue];
                curVal++;
                [mDictionary setValue:[NSString stringWithFormat:@"%i", curVal] forKey:@"like_count"];
                [mArray replaceObjectAtIndex:indexPath.section withObject:mDictionary];
                _posts = [NSArray arrayWithArray:mArray];
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                
            });
            
            
        });
        
    };
    
    
    return cell;
    
}

- (void)tappedCommentsForSection:(UITapGestureRecognizer *)tappedLable
{
    UILabel *labe = (UILabel *)tappedLable.view;
    
    CommentsViewController *viewController = [CommentsViewController new];
    viewController.post_id = [_posts[labe.tag] valueForKey:@"post_id"];
    [self.navigationController pushViewController:viewController animated:YES];
}


- (IBAction)addNewPostAction:(id)sender {
    AddPonder *viewController = [AddPonder new];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)filterAction:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Filter" message:@"Choose a group" preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSDictionary *dictionary in _groups) {
        [alert addAction:[UIAlertAction actionWithTitle:[dictionary valueForKey:@"group_name"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            _currentGroupId = [dictionary valueForKey:@"id"];
            _titleLabel.text = [dictionary valueForKey:@"group_name"];
            [self loadVerses];
        }]];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
@end
