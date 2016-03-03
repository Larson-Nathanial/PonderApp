//
//  ChooseVerses.m
//  Ponderize
//
//  Created by Nathan Larson on 10/5/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import "ChooseVerses.h"
#import "VerseCell.h"
#import "GetScriptureClass.h"
#import "Connection.h"

@interface ChooseVerses ()<UITableViewDataSource, UITableViewDelegate, GetScriptureDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *verses;
@property (nonatomic) NSMutableArray *selectedVerses;
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIView *coverView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) int currentChapterInCycle;

@end


@implementation ChooseVerses

- (void)viewDidLoad
{
    _selectedVerses = [NSMutableArray new];
    _currentChapterInCycle = 0;
    
    self.view.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    
    _titleLabel = [UILabel new];
    
    if ([_longTitle isEqualToString:@"Doctrine & Covenants"]) {
        _longTitle = @"D & C";
    }
    
    _titleLabel.text = [NSString stringWithFormat:@"%@ %@", _longTitle, _chapterSelected];
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
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([VerseCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([VerseCell class])];
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
    
    
    
//    _chapter_id = [_allChapters[_currentChapterInCycle] valueForKey:@"id"];
//    _chapterSelected = [_allChapters[_currentChapterInCycle] valueForKey:@"chapter"];
//    _chapterSelected = @"1";
//    _allChapters = @[@"1"];

    [self loadBooksOne];
    
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneSelectingScripture)];
    self.navigationItem.rightBarButtonItem = doneButton;
}



- (void)doneSelectingScripture
{
    NSString *completeScription = @"";
    int count = 0;
    NSString *firstVerse = nil;
    NSString *secondVerse = nil;
    NSMutableArray *temparray = [NSMutableArray new];
    for (NSDictionary *dictionary in _verses) {
        if ([[dictionary valueForKey:@"selected"] isEqualToString:@"yes"]) {
            completeScription = [completeScription stringByAppendingString:[NSString stringWithFormat:@"%@\n\n", [dictionary valueForKey:@"verse"]]];
            count++;
            [temparray addObject:dictionary];
        }
    }
    
    firstVerse = [[temparray firstObject] valueForKey:@"verse_number"];
    secondVerse = [[temparray lastObject] valueForKey:@"verse_number"];
    
    if ([completeScription isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Scripture Selected" message:@"You must select at least one verse" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }else {
        if (count == 1) {
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@ %@:%@", _longTitle, _chapterSelected, firstVerse] forKey:@"chosenScripture"];
        }else if (count > 1) {
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@ %@:%@ - %@", _longTitle, _chapterSelected, firstVerse, secondVerse] forKey:@"chosenScripture"];
        }
        [[NSUserDefaults standardUserDefaults] setValue:completeScription forKey:@"scriptureText"];
        [[NSUserDefaults standardUserDefaults] setValue:_longTitle forKey:@"bookSelected"];
        [[NSUserDefaults standardUserDefaults] setValue:_chapterSelected forKey:@"chapterSelected"];
        [[NSUserDefaults standardUserDefaults] setValue:firstVerse forKey:@"verse1Selected"];
        [[NSUserDefaults standardUserDefaults] setValue:secondVerse forKey:@"verse2Selected"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)loadBooksOne
{
    // get from server.
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        
        _verses = [[Connection connection] getVersesForChapterId:_chapter_id];
        
        NSMutableArray *mArray = [NSMutableArray arrayWithArray:_verses];
        
        for (int i = 0; i < (int)mArray.count; i++) {
            
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:mArray[i]];
            [dictionary setValue:@"no" forKey:@"selected"];
            [mArray replaceObjectAtIndex:i withObject:dictionary];
            
        }
        _verses = [NSArray arrayWithArray:mArray];
        
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            [UIView animateWithDuration:0.5 animations:^{
                _coverView.alpha = 0.0;
            }];
        });
    });
    
    
    
    
    
//    [GetScriptureClass getScriptureStuff].delegate = self;
//    [[GetScriptureClass getScriptureStuff] getVersesForChapter:_chapterSelected andBook:_book2Selected andParentBook:_book1Selected];
//    
//    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(aQueue, ^{
//        
//    });
}

- (void)didGetVersesForChapter:(NSArray *)verses
{
    dispatch_async(dispatch_get_main_queue(), ^{
    
        _verses = verses;
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(aQueue, ^{
            
//            for (NSDictionary *dictionary in _verses) {
//                [[Connection connection] didInsertVerseForchapter_id:_chapter_id verse_number:[dictionary valueForKey:@"verse_num"] verse:[dictionary valueForKey:@"verse"]];
//            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (_currentChapterInCycle < _allChapters.count - 1) {
                    _currentChapterInCycle++;
                    _chapter_id = [_allChapters[_currentChapterInCycle] valueForKey:@"id"];
                    _chapterSelected = [_allChapters[_currentChapterInCycle] valueForKey:@"chapter"];
                    NSLog(@"Now On Chapter: %@", [_allChapters[_currentChapterInCycle] valueForKey:@"chapter"]);
                    [self loadBooksOne];
                }else {
                    NSLog(@"-----------Completed-----------");
                    [UIView animateWithDuration:0.5 animations:^{
                        _coverView.alpha = 0.0;
                    }];
                }
                
                
                
                
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
    return _verses.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = [[_verses[indexPath.row] valueForKey:@"verse"] boundingRectWithSize:CGSizeMake(self.view.bounds.size.width - 50.0, MAXFLOAT)
                                                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                                                      attributes:@{
                                                                                                   NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-Regular" size:14.0]
                                                                                                   }
                                                                                         context:nil].size;
    
    return size.height + 25.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VerseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VerseCell class]) forIndexPath:indexPath];
    
    cell.verseText.text = [_verses[indexPath.row] valueForKey:@"verse"];
    
    if ([[_verses[indexPath.row] valueForKey:@"selected"] isEqualToString:@"yes"]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.backgroundColor = [UIColor colorWithRed:67.0 / 255.0 green:213.0 / 255.0 blue:81.0 / 255.0 alpha:0.5];
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor whiteColor];
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
    if ([[_verses[indexPath.row] valueForKey:@"selected"] isEqualToString:@"no"]) {
        
        NSMutableArray *mArray = [NSMutableArray arrayWithArray:_verses];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:mArray[indexPath.row]];
        [dictionary setValue:@"yes" forKey:@"selected"];
        [mArray replaceObjectAtIndex:indexPath.row withObject:dictionary];
        _verses = [NSArray arrayWithArray:mArray];
        
        
    }else {
        
        NSMutableArray *mArray = [NSMutableArray arrayWithArray:_verses];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:mArray[indexPath.row]];
        [dictionary setValue:@"no" forKey:@"selected"];
        [mArray replaceObjectAtIndex:indexPath.row withObject:dictionary];
        _verses = [NSArray arrayWithArray:mArray];
        
        
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


@end
