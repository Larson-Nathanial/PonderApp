//
//  ChooseChapter.m
//  Ponderize
//
//  Created by Nathan Larson on 10/5/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import "ChooseChapter.h"
#import "ChapterCell.h"
#import "GetScriptureClass.h"
#import "ChooseVerses.h"
#import "Connection.h"

@interface ChooseChapter ()<UITableViewDataSource, UITableViewDelegate, GetScriptureDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *chapters;
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIView *coverView;
@property (nonatomic) UILabel *titleLabel;

@end

@implementation ChooseChapter

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = _titleForView;
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
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ChapterCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ChapterCell class])];
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
    
    [self loadBooksOne];
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)loadBooksOne
{
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        
        _chapters = [[Connection connection] getChaptersForMinorBookId:_minorBookId];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            [UIView animateWithDuration:0.5 animations:^{
                _coverView.alpha = 0.0;
            }];
        });
    });
    
    
    
    
    
    
    
//    [UIView animateWithDuration:0.3 animations:^{
//        _coverView.alpha = 1.0;
//    }];
//    
//    [GetScriptureClass getScriptureStuff].delegate = self;
//    [[GetScriptureClass getScriptureStuff] getChaptersForBook:_book2Selected andParentBook:_book1Selected];
//    
//    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(aQueue, ^{
//        
//    });
}

- (void)didGetChaptersForBook:(NSArray *)chapters
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _chapters = chapters;
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(aQueue, ^{

//            for (NSDictionary *dictionary in _chapters) {
//                NSString *chap = [[dictionary valueForKey:@"chapter"] stringByReplacingOccurrencesOfString:@"Psalm " withString:@""];
//                [[Connection connection] didInsertChapterForBook:_minorBookId chapter:chap study:[dictionary valueForKey:@"study"]];
//            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5 animations:^{
                    _coverView.alpha = 0.0;
                }];
            });
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
    return _chapters.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![[_chapters[indexPath.row] valueForKey:@"study"] isEqual:[NSNull null]]) {
        return 121.0;
    }else {
        return 50.0;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChapterCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ChapterCell class]) forIndexPath:indexPath];
    NSString *chapOrSec = @"";
    if ([_titleForView isEqualToString:@"Doctrine & Covenants"]) {
        chapOrSec = @"Section";
    }else {
        chapOrSec = @"Chapter";
    }
    
    cell.chapter.text = [NSString stringWithFormat:@"%@ %@", chapOrSec, [_chapters[indexPath.row] valueForKey:@"chapter"]];
    cell.studyHelp.numberOfLines = 0;
    cell.studyHelp.lineBreakMode = NSLineBreakByTruncatingTail;
    
    if (![[_chapters[indexPath.row] valueForKey:@"study"] isEqual:[NSNull null]]) {
        cell.studyHelp.text = [_chapters[indexPath.row] valueForKey:@"study"];
        
        [cell.studyHelp sizeToFit];
    }else {
        cell.studyHelp.text = @"";
    }
    
    
    
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

    ChooseVerses *viewController = [ChooseVerses new];
    viewController.book1Selected = _book1Selected;
    viewController.book2Selected = _book2Selected;
    viewController.longTitle = _titleForView;
    viewController.chapterSelected = [_chapters[indexPath.row] valueForKey:@"chapter"];
    viewController.chapter_id = [_chapters[indexPath.row] valueForKey:@"id"];
    viewController.minor_book_id = _minorBookId;
    viewController.canUseDBForScriptures = _canUseDBForScriptures;
    viewController.numOfChapters = [NSString stringWithFormat:@"%i", (int)_chapters.count];
    viewController.allChapters = _chapters;
    [self.navigationController pushViewController:viewController animated:YES];
    
}


@end
