//
//  PostVisibilityOptionsViewController.m
//  Ponderize
//
//  Created by Nathan Larson on 10/7/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import "PostVisibilityOptionsViewController.h"
#import "Connection.h"

@interface PostVisibilityOptionsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *postOptions;
@property (nonatomic) NSArray *groups;
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIView *coverView;
@property (nonatomic) UILabel *titleLabel;

@end

@implementation PostVisibilityOptionsViewController

- (void)viewDidLoad
{
    
    self.view.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    
    _titleLabel = [UILabel new];
    
    _titleLabel.text = @"Post Visibility";
    _titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.0];
    _titleLabel.frame = CGRectMake(0, 0, 150, 30);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = _titleLabel;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:67.0 / 255.0 green:213.0 / 255.0 blue:81.0 / 255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 64.0, self.view.bounds.size.width - 0.0, self.view.bounds.size.height - 113.0) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setShowsHorizontalScrollIndicator:NO];
    [_tableView setShowsVerticalScrollIndicator:NO];
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
    
    [self loadPostOptions];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(postScripture)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)loadPostOptions
{
    // just me - group_id = 0
    // world - group_id = 1
    // each group
    
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        
        _groups = [[Connection connection] loadGroupsForUser];
        
        NSMutableArray *mGArray = [NSMutableArray new];
        
        for (NSDictionary *dictionary in _groups) {
            NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithDictionary:dictionary];
            [dic2 setValue:@"no" forKey:@"selected"];
            [mGArray addObject:dic2];
        }
        
        NSDictionary *dic1 = @{@"group_name":@"The World", @"id":@"1", @"selected":@"no"};
//        NSDictionary *dic2 = @{@"group_name":@"Just Me", @"id":@"0", @"selected":@"yes"};
        
        [mGArray insertObject:dic1 atIndex:0];
//        [mGArray insertObject:dic2 atIndex:0];
        _postOptions = [NSArray arrayWithArray:mGArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_tableView reloadData];
            
            [UIView animateWithDuration:0.5 animations:^{
                _coverView.alpha = 0.0;
            }];
        });
    });
}

- (void)postScripture
{
    //make sure at least one row is selected.
    BOOL atLeastOneSelected = NO;
    
    for (NSDictionary *dictionary in _postOptions) {
        if ([[dictionary valueForKey:@"selected"] isEqualToString:@"yes"]) {
            atLeastOneSelected = YES;
        }
    }
    
    if (!atLeastOneSelected) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"You need to select at least one option." preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else {
        
        [UIView animateWithDuration:0.3 animations:^{
            _coverView.alpha = 1.0;
        }];
        
        dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(aQueue, ^{
            
            NSString *post_id = @"";
            
            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"scriptureText"] == nil) {
                post_id = [[Connection connection] didPostForUserVerse:_thoughtsText book:@" " chapter:@" " verse1:@" " verse2:@" "];
            }else if (_thoughtsText == nil) {
                post_id = [[Connection connection] didPostForUserVerse:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"scriptureText"]] book:[[NSUserDefaults standardUserDefaults] valueForKey:@"bookSelected"] chapter:[[NSUserDefaults standardUserDefaults] valueForKey:@"chapterSelected"] verse1:[[NSUserDefaults standardUserDefaults] valueForKey:@"verse1Selected"] verse2:[[NSUserDefaults standardUserDefaults] valueForKey:@"verse2Selected"]];
            }else {
                post_id = [[Connection connection] didPostForUserVerse:[NSString stringWithFormat:@"%@ \n %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"scriptureText"], _thoughtsText] book:[[NSUserDefaults standardUserDefaults] valueForKey:@"bookSelected"] chapter:[[NSUserDefaults standardUserDefaults] valueForKey:@"chapterSelected"] verse1:[[NSUserDefaults standardUserDefaults] valueForKey:@"verse1Selected"] verse2:[[NSUserDefaults standardUserDefaults] valueForKey:@"verse2Selected"]];
            }
            
            for (NSDictionary *dictionary in _postOptions) {
                if ([[dictionary valueForKey:@"selected"] isEqualToString:@"yes"]) {
                    [[Connection connection] didMatchPostId:post_id toGroupId:[dictionary valueForKey:@"id"]];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"scriptureText"] forKey:@"currentScriptureText"];
                [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"chosenScripture"] forKey:@"currentScriptureReference"];
                
                // Reset all of the defaults.
                [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"scriptureText"];
                [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"chosenScripture"];
                [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"bookSelected"];
                [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"chapterSelected"];
                [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"verse1Selected"];
                [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"verse2Selected"];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"EEEE"];
                NSLog(@"%@", [dateFormatter stringFromDate:[NSDate date]]);
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd"];
                NSLog(@"%@", [dateFormat stringFromDate:[NSDate date]]);
                
                [[NSUserDefaults standardUserDefaults] setValue:[dateFormatter stringFromDate:[NSDate date]] forKey:@"lastDayPosted"];
                [[NSUserDefaults standardUserDefaults] setValue:[dateFormat stringFromDate:[NSDate date]] forKey:@"lastDatePosted"];
                
                
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                [UIView animateWithDuration:0.5 animations:^{
                    _coverView.alpha = 0.0;
                }];
            });
        });
        
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    _tableView.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width - 0.0, self.view.bounds.size.height - 0.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _postOptions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    cell.textLabel.text = [_postOptions[indexPath.row] valueForKey:@"group_name"];
    
    if ([[_postOptions[indexPath.row] valueForKey:@"selected"] isEqualToString:@"yes"]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.backgroundColor = [UIColor colorWithRed:67.0 / 255.0 green:213.0 / 255.0 blue:81.0 / 255.0 alpha:1.0];
        cell.textLabel.textColor = [UIColor whiteColor];
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    [[cell viewWithTag:543] removeFromSuperview];
    
    if (indexPath.row > 0) {
        UIView *aView = [UIView new];
        aView.tag = 543;
        aView.frame = CGRectMake(5.0, 0.0, self.view.bounds.size.width - 10.0, 1.0);
        aView.backgroundColor = [UIColor colorWithWhite:245.0 / 255.0 alpha:1.0];
        [cell addSubview:aView];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[_postOptions[indexPath.row] valueForKey:@"selected"] isEqualToString:@"no"]) {
        
        NSMutableArray *mArray = [NSMutableArray arrayWithArray:_postOptions];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:mArray[indexPath.row]];
        [dictionary setValue:@"yes" forKey:@"selected"];
        [mArray replaceObjectAtIndex:indexPath.row withObject:dictionary];
        _postOptions = [NSArray arrayWithArray:mArray];
        
        
    }else {
        
        NSMutableArray *mArray = [NSMutableArray arrayWithArray:_postOptions];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:mArray[indexPath.row]];
        [dictionary setValue:@"no" forKey:@"selected"];
        [mArray replaceObjectAtIndex:indexPath.row withObject:dictionary];
        _postOptions = [NSArray arrayWithArray:mArray];
        
        
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


@end
