//
//  GroupsViewController.m
//  Ponderize
//
//  Created by Nathan Larson on 10/5/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import "GroupsViewController.h"
#import "GroupMemebersViewController.h"
#import "Connection.h"

@interface GroupsViewController ()<UITableViewDataSource, UITableViewDelegate>

//@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *groups;
@property (nonatomic) NSArray *invitations;
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIView *coverView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *noGroupsLabel;

@property (nonatomic) UIBarButtonItem *editButton;
@property (nonatomic) UIBarButtonItem *doneButon;

@end

@implementation GroupsViewController

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"Groups";
    _titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.0];
    _titleLabel.frame = CGRectMake(0, 0, 150, 30);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = _titleLabel;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:67.0 / 255.0 green:213.0 / 255.0 blue:81.0 / 255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    self.refreshControl.tintColor = [UIColor colorWithRed:67.0 / 255.0 green:213.0 / 255.0 blue:81.0 / 255.0 alpha:1.0];
    [self.refreshControl addTarget:self
                            action:@selector(loadGroups)
                  forControlEvents:UIControlEventValueChanged];
    
    
    
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 64.0, self.view.bounds.size.width - 0.0, self.view.bounds.size.height - 113.0) style:UITableViewStylePlain];
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
    
    _editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPressed)];
    _doneButon = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPressed)];
    self.navigationItem.leftBarButtonItem = _editButton;
    
    _noGroupsLabel = [UILabel new];
    _noGroupsLabel.frame = CGRectMake(20.0, 0.0, self.view.bounds.size.width - 40, self.view.bounds.size.height);
    _noGroupsLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:18.0];
    _noGroupsLabel.textAlignment = NSTextAlignmentCenter;
    _noGroupsLabel.numberOfLines = 0;
    _noGroupsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _noGroupsLabel.text = @"You do not belong to any groups. To create a group, tap the + button in the top right corner.";
    _noGroupsLabel.alpha = 0.0;
    [self.view addSubview:_noGroupsLabel];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
//    _tableView.frame = CGRectMake(0.0, 64.0, self.view.bounds.size.width - 0.0, self.view.bounds.size.height - 0.0);
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
        _invitations = [[Connection connection] loadGroupInvitationsForUser];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (_groups.count == 0 && _invitations.count == 0) {
                // display that they have no groups.
                _noGroupsLabel.alpha = 1.0;
                _tableView.alpha = 0.0;
            }else {
                _noGroupsLabel.alpha = 0.0;
                _tableView.alpha = 1.0;
                [_tableView reloadData];
            }

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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_invitations != nil && _groups != nil) {
        return 2;
    }
    
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_invitations != nil && _groups != nil) {
        if (section == 0) {
            return @"Invitations";
        }else {
            return @"Groups";
        }
    }
    return nil;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_invitations != nil && _groups != nil) {
        if (section == 0) {
            return _invitations.count;
        }else {
            return _groups.count;
        }
    }else if (_invitations != nil && _groups == nil) {
        return _invitations.count;
    }
    
    return _groups.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    if (_invitations != nil && _groups != nil) {
        if (indexPath.section == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"Invite from: %@", [_invitations[indexPath.row] valueForKey:@"group_name"]];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.backgroundColor = [UIColor colorWithRed:67.0 / 255.0 green:213.0 / 255.0 blue:81.0 / 255.0 alpha:0.5];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else {
            cell.textLabel.text = [_groups[indexPath.row] valueForKey:@"group_name"];
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else if (_invitations != nil && _groups == nil) {
        cell.textLabel.text = [NSString stringWithFormat:@"Invite from: %@", [_invitations[indexPath.row] valueForKey:@"group_name"]];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor colorWithRed:67.0 / 255.0 green:213.0 / 255.0 blue:81.0 / 255.0 alpha:0.5];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else {
        cell.textLabel.text = [_groups[indexPath.row] valueForKey:@"group_name"];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row > 0) {
        UIView *aView = [UIView new];
        aView.frame = CGRectMake(5.0, 0.0, self.view.bounds.size.width - 10.0, 1.0);
        aView.backgroundColor = [UIColor colorWithWhite:245.0 / 255.0 alpha:1.0];
        [cell addSubview:aView];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_invitations != nil && _groups != nil) {
        if (indexPath.section == 0) {
            [self displayOptionsForGroupInvite:_invitations[indexPath.row]];
        }else {
            GroupMemebersViewController *viewController = [GroupMemebersViewController new];
            
            viewController.group_name = [_groups[indexPath.row] valueForKey:@"group_name"];
            viewController.group_id = [_groups[indexPath.row] valueForKey:@"id"];
            
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }else if (_invitations != nil && _groups == nil) {
        [self displayOptionsForGroupInvite:_invitations[indexPath.row]];
    }else {
        GroupMemebersViewController *viewController = [GroupMemebersViewController new];
        
        viewController.group_name = [_groups[indexPath.row] valueForKey:@"group_name"];
        viewController.group_id = [_groups[indexPath.row] valueForKey:@"id"];
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}

- (void)displayOptionsForGroupInvite:(NSDictionary *)group_invite
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Group Invite" message:[NSString stringWithFormat:@"You are invited to join the group %@", [group_invite valueForKey:@"group_name"]] preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Decline Invite" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self declineInvite:group_invite];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Accept Invite" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self acceptInvite:group_invite];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)acceptInvite:(NSDictionary *)group_invite
{
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        
        [[Connection connection] didAcceptInviteId:[group_invite valueForKey:@"id"] forGroupId:[group_invite valueForKey:@"group_id"] andUserId:[group_invite valueForKey:@"user_id"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self loadGroups];
            
            [UIView animateWithDuration:0.5 animations:^{
                _coverView.alpha = 0.0;
            }];
        });
    });
}

- (void)declineInvite:(NSDictionary *)group_invite
{
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        
        [[Connection connection] didDeclineInviteId:[group_invite valueForKey:@"id"] forGroupId:[group_invite valueForKey:@"group_id"] andUserId:[group_invite valueForKey:@"user_id"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self loadGroups];
            
            [UIView animateWithDuration:0.5 animations:^{
                _coverView.alpha = 0.0;
            }];
        });
    });
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete all rows
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Perform the real delete action here. Note: you may need to check editing style
    //   if you do not perform delete only.
    
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        
        [[Connection connection] didDeleteGroupWithId:[_groups[indexPath.row] valueForKey:@"id"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self loadGroups];
            
            [UIView animateWithDuration:0.5 animations:^{
                _coverView.alpha = 0.0;
            }];
        });
    });
    
    NSLog(@"Deleted row.");
}

- (IBAction)createGroupAction:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"New Group" message:@"Enter the name you would like for your group" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"group name";
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        if (((UITextField *)alert.textFields[0]).text.length == 0) {
            [self presentViewController:alert animated:YES completion:nil];
        }else {
            [self createGroupWithName:((UITextField *)alert.textFields[0]).text];
        }
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)createGroupWithName:(NSString *)group_name
{
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        
        [[Connection connection] didCreateNewGroupWithName:group_name];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self loadGroups];
            
            [UIView animateWithDuration:0.5 animations:^{
                _coverView.alpha = 0.0;
            }];
        });
    });
}

- (void)editButtonPressed
{
    if (_tableView.isEditing) {
        [_tableView setEditing:NO animated:YES];
        self.navigationItem.leftBarButtonItem = _editButton;
    }else {
        [_tableView setEditing:YES animated:YES];
        self.navigationItem.leftBarButtonItem = _doneButon;
    }
}


@end
