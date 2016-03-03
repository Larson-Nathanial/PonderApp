//
//  ChooseBookTwo.m
//  Ponderize
//
//  Created by Nathan Larson on 10/5/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import "ChooseBookTwo.h"
#import "GetScriptureClass.h"
#import "ChooseChapter.h"
#import "ChooseVerses.h"
#import "Connection.h"

@interface ChooseBookTwo ()<UITableViewDataSource, UITableViewDelegate, GetScriptureDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *books;
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIView *coverView;
@property (nonatomic) UILabel *titleLabel;

@end

@implementation ChooseBookTwo

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
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width - 0.0, self.view.bounds.size.height - 0.0) style:UITableViewStylePlain];
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
    
    [self loadBooksOne];
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)loadBooksOne
{
    // load books.
    
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        
        if ([_titleForView isEqualToString:@"Doctrine & Covenants"]) {
            _titleForView = @"Doctrine and Covenants";
        }
        
        _books = [[Connection connection] getMinorBooksForMajorBook:_titleForView];
        
        
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
//    [[GetScriptureClass getScriptureStuff] getBooksAvailableInBook:_book1Selected realBookName:_titleForView];
//    
//    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(aQueue, ^{
//        
//    });
    
    
}

- (void)didGetBooksAvailableInBook:(NSArray *)books
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([_book1Selected isEqualToString:@"pgp"]) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:books];
            [array removeObjectAtIndex:4];
            [array removeObjectAtIndex:3];
            [array removeObjectAtIndex:2];
            
            _books = [NSArray arrayWithArray:array];
        }else {
            _books = books;
        }
        
        
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [UIView animateWithDuration:0.5 animations:^{
            _coverView.alpha = 0.0;
        }];
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [_books[indexPath.row] valueForKey:@"book_name"];
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *bookSelected = nil;
    BOOL hasOneChapter = NO;
    
    if ([cell.textLabel.text isEqualToString:@"Genesis"]) {
        bookSelected = @"gen";
    }else if ([cell.textLabel.text isEqualToString:@"Exodus"]) {
        bookSelected = @"ex";
    }else if ([cell.textLabel.text isEqualToString:@"Leviticus"]) {
        bookSelected = @"lev";
    }else if ([cell.textLabel.text isEqualToString:@"Numbers"]) {
        bookSelected = @"num";
    }else if ([cell.textLabel.text isEqualToString:@"Deuteronomy"]) {
        bookSelected = @"deut";
    }else if ([cell.textLabel.text isEqualToString:@"Joshua"]) {
        bookSelected = @"josh";
    }else if ([cell.textLabel.text isEqualToString:@"Judges"]) {
        bookSelected = @"judg";
    }else if ([cell.textLabel.text isEqualToString:@"Ruth"]) {
        bookSelected = @"ruth";
    }else if ([cell.textLabel.text isEqualToString:@"1 Samuel"]) {
        bookSelected = @"1-sam";
    }else if ([cell.textLabel.text isEqualToString:@"2 Samuel"]) {
        bookSelected = @"2-sam";
    }else if ([cell.textLabel.text isEqualToString:@"1 Kings"]) {
        bookSelected = @"1-kgs";
    }else if ([cell.textLabel.text isEqualToString:@"2 Kings"]) {
        bookSelected = @"2-kgs";
    }else if ([cell.textLabel.text isEqualToString:@"1 Chronicles"]) {
        bookSelected = @"1-chr";
    }else if ([cell.textLabel.text isEqualToString:@"2 Chronicles"]) {
        bookSelected = @"2-chr";
    }else if ([cell.textLabel.text isEqualToString:@"Ezra"]) {
        bookSelected = @"ezra";
    }else if ([cell.textLabel.text isEqualToString:@"Nehemiah"]) {
        bookSelected = @"neh";
    }else if ([cell.textLabel.text isEqualToString:@"Esther"]) {
        bookSelected = @"esth";
    }else if ([cell.textLabel.text isEqualToString:@"Job"]) {
        bookSelected = @"job";
    }else if ([cell.textLabel.text isEqualToString:@"Psalms"]) {
        bookSelected = @"ps";
    }else if ([cell.textLabel.text isEqualToString:@"Proverbs"]) {
        bookSelected = @"prov";
    }else if ([cell.textLabel.text isEqualToString:@"Ecclesiastes"]) {
        bookSelected = @"eccl";
    }else if ([cell.textLabel.text isEqualToString:@"Song of Solomon"]) {
        bookSelected = @"song";
    }else if ([cell.textLabel.text isEqualToString:@"Isaiah"]) {
        bookSelected = @"isa";
    }else if ([cell.textLabel.text isEqualToString:@"Jeremiah"]) {
        bookSelected = @"jer";
    }else if ([cell.textLabel.text isEqualToString:@"Lamentations"]) {
        bookSelected = @"lam";
    }else if ([cell.textLabel.text isEqualToString:@"Ezekiel"]) {
        bookSelected = @"ezek";
    }else if ([cell.textLabel.text isEqualToString:@"Daniel"]) {
        bookSelected = @"dan";
    }else if ([cell.textLabel.text isEqualToString:@"Hosea"]) {
        bookSelected = @"hosea";
    }else if ([cell.textLabel.text isEqualToString:@"Joel"]) {
        bookSelected = @"joel";
    }else if ([cell.textLabel.text isEqualToString:@"Amos"]) {
        bookSelected = @"amos";
    }else if ([cell.textLabel.text isEqualToString:@"Obadiah"]) { // has a funny url
        bookSelected = @"obad";
        hasOneChapter = YES;
    }else if ([cell.textLabel.text isEqualToString:@"Jonah"]) {
        bookSelected = @"jonah";
    }else if ([cell.textLabel.text isEqualToString:@"Micah"]) {
        bookSelected = @"micah";
    }else if ([cell.textLabel.text isEqualToString:@"Nahum"]) {
        bookSelected = @"nahum";
    }else if ([cell.textLabel.text isEqualToString:@"Habakkuk"]) {
        bookSelected = @"hab";
    }else if ([cell.textLabel.text isEqualToString:@"Zephaniah"]) {
        bookSelected = @"zeph";
    }else if ([cell.textLabel.text isEqualToString:@"Haggai"]) {
        bookSelected = @"hag";
    }else if ([cell.textLabel.text isEqualToString:@"Zechariah"]) {
        bookSelected = @"zech";
    }else if ([cell.textLabel.text isEqualToString:@"Malachi"]) {
        bookSelected = @"mal";
    }else if ([cell.textLabel.text isEqualToString:@"Matthew"]) {
        bookSelected = @"matt";
    }else if ([cell.textLabel.text isEqualToString:@"Mark"]) {
        bookSelected = @"mark";
    }else if ([cell.textLabel.text isEqualToString:@"Luke"]) {
        bookSelected = @"luke";
    }else if ([cell.textLabel.text isEqualToString:@"John"]) {
        bookSelected = @"john";
    }else if ([cell.textLabel.text isEqualToString:@"Acts"]) {
        bookSelected = @"acts";
    }else if ([cell.textLabel.text isEqualToString:@"Romans"]) {
        bookSelected = @"rom";
    }else if ([cell.textLabel.text isEqualToString:@"1 Corinthians"]) {
        bookSelected = @"1-cor";
    }else if ([cell.textLabel.text isEqualToString:@"2 Corinthians"]) {
        bookSelected = @"2-cor";
    }else if ([cell.textLabel.text isEqualToString:@"Galatians"]) {
        bookSelected = @"gal";
    }else if ([cell.textLabel.text isEqualToString:@"Ephesians"]) {
        bookSelected = @"eph";
    }else if ([cell.textLabel.text isEqualToString:@"Philippians"]) {
        bookSelected = @"philip";
    }else if ([cell.textLabel.text isEqualToString:@"Colossians"]) {
        bookSelected = @"col";
    }else if ([cell.textLabel.text isEqualToString:@"1 Thessalonians"]) {
        bookSelected = @"1-thes";
    }else if ([cell.textLabel.text isEqualToString:@"2 Thessalonians"]) {
        bookSelected = @"2-thes";
    }else if ([cell.textLabel.text isEqualToString:@"1 Timothy"]) {
        bookSelected = @"1-tim";
    }else if ([cell.textLabel.text isEqualToString:@"2 Timothy"]) {
        bookSelected = @"2-tim";
    }else if ([cell.textLabel.text isEqualToString:@"Titus"]) {
        bookSelected = @"titus";
    }else if ([cell.textLabel.text isEqualToString:@"Philemon"]) { // has a funny url
        bookSelected = @"philem";
        hasOneChapter = YES;
    }else if ([cell.textLabel.text isEqualToString:@"Hebrews"]) {
        bookSelected = @"heb";
    }else if ([cell.textLabel.text isEqualToString:@"James"]) {
        bookSelected = @"james";
    }else if ([cell.textLabel.text isEqualToString:@"1 Peter"]) {
        bookSelected = @"1-pet";
    }else if ([cell.textLabel.text isEqualToString:@"2 Peter"]) {
        bookSelected = @"2-pet";
    }else if ([cell.textLabel.text isEqualToString:@"1 John"]) {
        bookSelected = @"1-jn";
    }else if ([cell.textLabel.text isEqualToString:@"2 John"]) { // has a funny url
        bookSelected = @"2-jn";
        hasOneChapter = YES;
    }else if ([cell.textLabel.text isEqualToString:@"3 John"]) { // has a funny url
        bookSelected = @"3-jn";
        hasOneChapter = YES;
    }else if ([cell.textLabel.text isEqualToString:@"Jude"]) { // has a funny url
        bookSelected = @"jude";
        hasOneChapter = YES;
    }else if ([cell.textLabel.text isEqualToString:@"Revelation"]) {
        bookSelected = @"rev";
        hasOneChapter = NO;
    }
    else if (indexPath.row == 0 && [_book1Selected isEqualToString:@"bofm"]) {
        bookSelected = @"1-ne";
    }else if (indexPath.row == 1 && [_book1Selected isEqualToString:@"bofm"]) {
        bookSelected = @"2-ne";
    }else if ([cell.textLabel.text isEqualToString:@"Jacob"]) {
        bookSelected = @"jacob";
    }else if ([cell.textLabel.text isEqualToString:@"Enos"]) { // Didn't work.
        bookSelected = @"enos";
    }else if ([cell.textLabel.text isEqualToString:@"Jarom"]) { // has a funny url
        bookSelected = @"jarom";
        hasOneChapter = YES;
    }else if ([cell.textLabel.text isEqualToString:@"Omni"]) { // has a funny url
        bookSelected = @"omni";
        hasOneChapter = YES;
    }else if ([cell.textLabel.text isEqualToString:@"Words of Mormon"]) { // has a funny url
        bookSelected = @"w-of-m";
        hasOneChapter = YES;
    }else if ([cell.textLabel.text isEqualToString:@"Mosiah"]) { // check this one.. it looks funny.
        bookSelected = @"mosiah";
    }else if ([cell.textLabel.text isEqualToString:@"Alma"]) { // check this one.. it's pretty messed up.
        bookSelected = @"alma";
    }else if ([cell.textLabel.text isEqualToString:@"Helaman"]) { // this one is too.
        bookSelected = @"hel";
    }else if (indexPath.row == 10 && [_book1Selected isEqualToString:@"bofm"]) { // so is this one.
        bookSelected = @"3-ne";
    }else if (indexPath.row == 11 && [_book1Selected isEqualToString:@"bofm"]) { // has a funny url
        bookSelected = @"4-ne";
        hasOneChapter = YES;
    }else if ([cell.textLabel.text isEqualToString:@"Mormon"]) { // this one looked funny
        bookSelected = @"morm";
    }else if ([cell.textLabel.text isEqualToString:@"Ether"]) { // missing chapter 16
        bookSelected = @"ether";
    }else if ([cell.textLabel.text isEqualToString:@"Moroni"]) { // missing everything as well.
        bookSelected = @"moro";
    }else if ([cell.textLabel.text isEqualToString:@"Moses"]) {
        bookSelected = @"moses";
    }else if ([cell.textLabel.text isEqualToString:@"Abraham"]) {
        bookSelected = @"abr";
    }else if (indexPath.row == 2 && [_book1Selected isEqualToString:@"pgp"]) {//5 has funny url
        bookSelected = @"js-m";
        hasOneChapter = YES;
    }else if (indexPath.row == 3 && [_book1Selected isEqualToString:@"pgp"]) {//6 has funny url
        bookSelected = @"js-h";
        hasOneChapter = YES;
    }else if ([cell.textLabel.text isEqualToString:@"Articles of Faith"]) {// has funny url
        bookSelected = @"a-of-f";
        hasOneChapter = YES;
    }
    
//    if (hasOneChapter) {
//        ChooseVerses *viewController = [ChooseVerses new];
//        viewController.book1Selected = _book1Selected;
//        viewController.book2Selected = bookSelected;
//        viewController.longTitle = bookSelected;
//        viewController.chapterSelected = @"1";
//        viewController.canUseDBForScriptures = _canUseDBForScriptures;
//        [self.navigationController pushViewController:viewController animated:YES];
//    }else {
        ChooseChapter *viewController = [ChooseChapter new];
        viewController.book1Selected = _book1Selected;
        viewController.book2Selected = bookSelected;
        viewController.titleForView = cell.textLabel.text;
        viewController.canUseDBForScriptures = _canUseDBForScriptures;
        viewController.majorBook = _titleForView;
        viewController.minorBookId = [_books[indexPath.row] valueForKey:@"id"];
        [self.navigationController pushViewController:viewController animated:YES];
//    }
    
    
    
    
}


@end
