//
//  GroupMemebersViewController.m
//  Ponderize
//
//  Created by Nathan Larson on 10/5/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

// has a plus button to add a member, has an edit button so you can delete group members.


#import "GroupMemebersViewController.h"
#import "Connection.h"

@interface GroupMemebersViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *groupMembers;
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIView *coverView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *noGroupsLabel;

@end

@implementation GroupMemebersViewController

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = _group_name;
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
                            action:@selector(loadGroupMembers)
                  forControlEvents:UIControlEventValueChanged];
    
    
    
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
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addGroupMember)];
    
    self.navigationItem.rightBarButtonItem = addButton;
    
    _noGroupsLabel = [UILabel new];
    _noGroupsLabel.frame = CGRectMake(20.0, 0.0, self.view.bounds.size.width - 40, self.view.bounds.size.height);
    _noGroupsLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:18.0];
    _noGroupsLabel.textAlignment = NSTextAlignmentCenter;
    _noGroupsLabel.numberOfLines = 0;
    _noGroupsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _noGroupsLabel.text = @"To invite group members, tap the + bottom in the top right corner.";
    _noGroupsLabel.alpha = 0.0;
    [self.view addSubview:_noGroupsLabel];
    
}



- (void)viewDidAppear:(BOOL)animated
{
    
    _tableView.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width - 0.0, self.view.bounds.size.height - 0.0);
    [_tableView addSubview:self.refreshControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadGroupMembers];
}

- (void)loadGroupMembers
{
    
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        
        _groupMembers = [[Connection connection] loadGroupMembersForGroupId:_group_id];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (_groupMembers.count == 0) {
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _groupMembers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", [_groupMembers[indexPath.row] valueForKey:@"user_name"], [_groupMembers[indexPath.row] valueForKey:@"email"]];
    
    cell.accessoryView = nil;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0.0, 0.0, 80.0, 30.0);
    button.tag = indexPath.row;
    [button setTitle:@"Remove" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(removePersonFromGroup:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.accessoryView = button;
    
    if (indexPath.row > 0) {
        UIView *aView = [UIView new];
        aView.frame = CGRectMake(5.0, 0.0, self.view.bounds.size.width - 10.0, 1.0);
        aView.backgroundColor = [UIColor colorWithWhite:245.0 / 255.0 alpha:1.0];
        [cell addSubview:aView];
    }
    
    return cell;
    
}

- (void)addGroupMember
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invite Member" message:@"Enter the email of the person you want to invite. It will need to be the email address they used to create their account." preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"email";
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        if (((UITextField *)alert.textFields[0]).text.length == 0) {
            [self presentViewController:alert animated:YES completion:nil];
        }else {
            [self inviteMemberWithEmail:((UITextField *)alert.textFields[0]).text];
        }
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)inviteMemberWithEmail:(NSString *)emailAddress
{
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        
        [[Connection connection] didInviteGroupMemberViaEmail:emailAddress forGroupId:_group_id];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invite Sent" message:@"They will show up here once they've accepted the invitation." preferredStyle:UIAlertControllerStyleAlert];
            
            
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
                
            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            [UIView animateWithDuration:0.5 animations:^{
                _coverView.alpha = 0.0;
            }];
        });
    });

}

- (void)removePersonFromGroup:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        
        [[Connection connection] didRemoveGroupMember:[_groupMembers[sender.tag] valueForKey:@"group_member_id"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self loadGroupMembers];
            
            [UIView animateWithDuration:0.5 animations:^{
                _coverView.alpha = 0.0;
            }];
        });
    });
}


@end
