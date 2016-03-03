//
//  SettingsViewController.m
//  Ponderize
//
//  Created by Nathan Larson on 10/5/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()<UITableViewDataSource, UITableViewDelegate>

//@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *settings;
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIView *coverView;
@property (nonatomic) UILabel *titleLabel;

@property (nonatomic) NSString *selectedGroupName;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    
    _settings = @[@"Weekly Reminder", @"Comments on my post", @"Group Posts",  @"Group Comments"];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"Settings";
    _titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.0];
    _titleLabel.frame = CGRectMake(0, 0, 150, 30);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = _titleLabel;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:67.0 / 255.0 green:213.0 / 255.0 blue:81.0 / 255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
   
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 64.0, self.view.bounds.size.width - 0.0, self.view.bounds.size.height - 113.0) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setShowsHorizontalScrollIndicator:NO];
    [_tableView setShowsVerticalScrollIndicator:NO];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
//    _tableView.frame = CGRectMake(0.0, 64.0, self.view.bounds.size.width - 0.0, self.view.bounds.size.height - 0.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _settings.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = _settings[indexPath.row];
    
    cell.accessoryView = nil;
    
    UISwitch *sw = [UISwitch new];
    sw.frame = CGRectZero;
    sw.tag = indexPath.row;
    
    if ([cell.textLabel.text isEqualToString:@"Weekly Reminder"] && [[[NSUserDefaults standardUserDefaults] valueForKey:@"weeklyReminder"] isEqualToString:@"1"]) {
        sw.on = YES;
    }else if ([cell.textLabel.text isEqualToString:@"Weekly Reminder"] && [[[NSUserDefaults standardUserDefaults] valueForKey:@"weeklyReminder"] isEqualToString:@"0"]) {
        sw.on = NO;
    }
    
    if ([cell.textLabel.text isEqualToString:@"Comments on my post"] && [[[NSUserDefaults standardUserDefaults] valueForKey:@"commentsOnMyPosts"] isEqualToString:@"1"]) {
        sw.on = YES;
    }else if ([cell.textLabel.text isEqualToString:@"Comments on my post"] && [[[NSUserDefaults standardUserDefaults] valueForKey:@"commentsOnMyPosts"] isEqualToString:@"0"]) {
        sw.on = NO;
    }
    
    if ([cell.textLabel.text isEqualToString:@"Group Posts"] && [[[NSUserDefaults standardUserDefaults] valueForKey:@"groupPosts"] isEqualToString:@"1"]) {
        sw.on = YES;
    }else if ([cell.textLabel.text isEqualToString:@"Group Posts"] && [[[NSUserDefaults standardUserDefaults] valueForKey:@"groupPosts"] isEqualToString:@"0"]) {
        sw.on = NO;
    }
    
    if ([cell.textLabel.text isEqualToString:@"Group Comments"] && [[[NSUserDefaults standardUserDefaults] valueForKey:@"groupComments"] isEqualToString:@"1"]) {
        sw.on = YES;
    }else if ([cell.textLabel.text isEqualToString:@"Group Comments"] && [[[NSUserDefaults standardUserDefaults] valueForKey:@"groupComments"] isEqualToString:@"0"]) {
        sw.on = NO;
    }

    
    [sw addTarget:self action:@selector(changedSetting:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = sw;
    
    if (indexPath.row > 0) {
        UIView *aView = [UIView new];
        aView.frame = CGRectMake(5.0, 0.0, self.view.bounds.size.width - 10.0, 1.0);
        aView.backgroundColor = [UIColor colorWithWhite:245.0 / 255.0 alpha:1.0];
        [cell addSubview:aView];
    }
    
    return cell;
    
}

- (void)changedSetting:(UISwitch *)sw
{
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"weeklyReminder"];
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"commentsOnMyPosts"];
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"groupPosts"];
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"groupComments"];
    
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sw.tag inSection:0]];
    if (sw.on) {
        if ([cell.textLabel.text isEqualToString:@"Weekly Reminder"]) {
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"weeklyReminder"];
        }else if ([cell.textLabel.text isEqualToString:@"Comments on my post"]) {
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"commentsOnMyPosts"];
        }else if ([cell.textLabel.text isEqualToString:@"Group Posts"]) {
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"groupPosts"];
        }else if ([cell.textLabel.text isEqualToString:@"Group Comments"]) {
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"groupComments"];
        }
    }else {
        if ([cell.textLabel.text isEqualToString:@"Weekly Reminder"]) {
            [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"weeklyReminder"];
        }else if ([cell.textLabel.text isEqualToString:@"Comments on my post"]) {
            [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"commentsOnMyPosts"];
        }else if ([cell.textLabel.text isEqualToString:@"Group Posts"]) {
            [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"groupPosts"];
        }else if ([cell.textLabel.text isEqualToString:@"Group Comments"]) {
            [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"groupComments"];
        }
    }
}

@end

