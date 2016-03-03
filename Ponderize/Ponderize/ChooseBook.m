//
//  ChooseBook.m
//  Ponderize
//
//  Created by Nathan Larson on 10/5/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import "ChooseBook.h"
#import "ChooseBookTwo.h"
#import "ChooseChapter.h"
#import "Connection.h"

@interface ChooseBook ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *books;
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIView *coverView;
@property (nonatomic) UILabel *titleLabel;

@property (nonatomic) BOOL canUseDBForScriptures;

@end

@implementation ChooseBook

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    
    _canUseDBForScriptures = NO;
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"Choose Book";
    _titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.0];
    _titleLabel.frame = CGRectMake(0, 0, 150, 30);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = _titleLabel;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:67.0 / 255.0 green:213.0 / 255.0 blue:81.0 / 255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width - 0.0, self.view.bounds.size.height - 0.0) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setShowsHorizontalScrollIndicator:NO];
    [_tableView setShowsVerticalScrollIndicator:NO];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPickingScripture)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)cancelPickingScripture
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadBooksOne];
}

- (void)loadBooksOne
{
    // load books.
    _books = @[@"Old Testament (KJV)", @"New Testament (KJV)", @"Book of Mormon", @"Doctrine & Covenants", @"Pearl of Great Price"];
    
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        
        _canUseDBForScriptures = [[Connection connection] canUseDBForScriptures];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
            
            //            dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            //            dispatch_async(aQueue, ^{
            //                [[TempGetAllScriptures getAll] kickOff];
            //            });
            
            [UIView animateWithDuration:0.5 animations:^{
                _coverView.alpha = 0.0;
            }];
        });
    });
    
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
    return _books.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    cell.textLabel.text = _books[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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
    
    if (indexPath.row == 0) {
        ChooseBookTwo *viewController = [ChooseBookTwo new];
        viewController.book1Selected = @"ot";
        viewController.titleForView = @"Old Testament (KJV)";
        viewController.canUseDBForScriptures = _canUseDBForScriptures;
        [self.navigationController pushViewController:viewController animated:YES];
    }else if (indexPath.row == 1) {
        ChooseBookTwo *viewController = [ChooseBookTwo new];
        viewController.book1Selected = @"nt";
        viewController.titleForView = @"New Testament (KJV)";
        viewController.canUseDBForScriptures = _canUseDBForScriptures;
        [self.navigationController pushViewController:viewController animated:YES];
    }else if (indexPath.row == 2) {
        ChooseBookTwo *viewController = [ChooseBookTwo new];
        viewController.book1Selected = @"bofm";
        viewController.titleForView = @"Book of Mormon";
        viewController.canUseDBForScriptures = _canUseDBForScriptures;
        [self.navigationController pushViewController:viewController animated:YES];
    }else if (indexPath.row == 3) {
        ChooseBookTwo *viewController = [ChooseBookTwo new];
        viewController.book1Selected = @"dc-testament";
//        viewController.book2Selected = @"/dc";
        viewController.titleForView = @"Doctrine & Covenants";
        viewController.canUseDBForScriptures = _canUseDBForScriptures;
        [self.navigationController pushViewController:viewController animated:YES];
    }else if (indexPath.row == 4) {
        ChooseBookTwo *viewController = [ChooseBookTwo new];
        viewController.book1Selected = @"pgp";
        viewController.titleForView = @"Pearl of Great Price";
        viewController.canUseDBForScriptures = _canUseDBForScriptures;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    

}


@end
