//
//  GetScriptureClass.m
//  Ponderize
//
//  Created by Nathan Larson on 10/6/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import "GetScriptureClass.h"
#import "Connection.h"

@interface GetScriptureClass ()<UIWebViewDelegate>

@property (nonatomic) UIWebView *webView;
@property (nonatomic) int loadCount;
@property (nonatomic) NSString *currentlyLookingfor;
@property (nonatomic) BOOL isDC;
@property (nonatomic) BOOL isPGPMA;
@property (nonatomic) NSArray *majorBooks;
@property (nonatomic) NSArray *smallerBooks;
@property (nonatomic) NSString *currentBook;

@end

@implementation GetScriptureClass

+ (GetScriptureClass *)getScriptureStuff
{
    static GetScriptureClass *getScriptureStuff = nil;
    
    if (!getScriptureStuff) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            getScriptureStuff = [[self alloc] initPrivate];
        });
    }
    return getScriptureStuff;
}

- (instancetype)initPrivate
{
    self = [super init];
    _isDC = NO;
    
    _smallerBooks = [Connection connection];
    return self;
}

- (void)getBooksAvailableInBook:(NSString *)book realBookName:(NSString *)book_name
{
    NSString *urlToGet = [NSString stringWithFormat:@"https://www.lds.org/scriptures/%@?lang=eng", book];
    
//    if ([book isEqualToString:@"dc-testament/dc"]) {
//        _isDC = YES;
//    }else {
//        _isDC = NO;
//    }
    
    _currentlyLookingfor = @"Book";
    _currentBook = book_name;
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 5,5)];
    _webView.delegate = self;
    NSString *url = urlToGet;
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    _loadCount = 0;
    [_webView loadRequest:nsrequest];
    
}

- (void)getChaptersForBook:(NSString *)book andParentBook:(NSString *)parent_book
{
    NSString *urlToGet = [NSString stringWithFormat:@"https://www.lds.org/scriptures/%@/%@?lang=eng", parent_book, book];
    
    _currentlyLookingfor = @"ChaptersInBook";
    
    if ([book isEqualToString:@"moses"] || [book isEqualToString:@"abr"] || [parent_book isEqualToString:@"bofm"]) {
        _isPGPMA = YES;
    }else {
        _isPGPMA = NO;
    }
    
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 5,5)];
    _webView.delegate = self;
    NSString *url = urlToGet;
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    _loadCount = 0;
    [_webView loadRequest:nsrequest];
}

- (void)getVersesForChapter:(NSString *)chapter andBook:(NSString *)book andParentBook:(NSString *)parent_book
{
    NSString *urlToGet = [NSString stringWithFormat:@"https://www.lds.org/scriptures/%@/%@/%@?lang=eng", parent_book, book, chapter];

    _currentlyLookingfor = @"Verses";
    
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 5,5)];
    _webView.delegate = self;
    NSString *url = urlToGet;
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    _loadCount = 0;
    [_webView loadRequest:nsrequest];
}

- (void)TWOgetVersesForChapter:(NSString *)chapter andBook:(NSString *)book andParentBook:(NSString *)parent_book
{
    NSString *bookSelected = @"";
    BOOL hasOneChapter = YES;
    
    if ([book isEqualToString:@"Genesis"]) {
        bookSelected = @"gen";
    }else if ([book isEqualToString:@"Exodus"]) {
        bookSelected = @"ex";
    }else if ([book isEqualToString:@"Leviticus"]) {
        bookSelected = @"lev";
    }else if ([book isEqualToString:@"Numbers"]) {
        bookSelected = @"num";
    }else if ([book isEqualToString:@"Deuteronomy"]) {
        bookSelected = @"deut";
    }else if ([book isEqualToString:@"Joshua"]) {
        bookSelected = @"josh";
    }else if ([book isEqualToString:@"Judges"]) {
        bookSelected = @"judg";
    }else if ([book isEqualToString:@"Ruth"]) {
        bookSelected = @"ruth";
    }else if ([book isEqualToString:@"1 Samuel"]) {
        bookSelected = @"1-sam";
    }else if ([book isEqualToString:@"2 Samuel"]) {
        bookSelected = @"2-sam";
    }else if ([book isEqualToString:@"1 Kings"]) {
        bookSelected = @"1-kgs";
    }else if ([book isEqualToString:@"2 Kings"]) {
        bookSelected = @"2-kgs";
    }else if ([book isEqualToString:@"1 Chronicles"]) {
        bookSelected = @"1-chr";
    }else if ([book isEqualToString:@"2 Chronicles"]) {
        bookSelected = @"2-chr";
    }else if ([book isEqualToString:@"Ezra"]) {
        bookSelected = @"ezra";
    }else if ([book isEqualToString:@"Nehemiah"]) {
        bookSelected = @"neh";
    }else if ([book isEqualToString:@"Esther"]) {
        bookSelected = @"esth";
    }else if ([book isEqualToString:@"Job"]) {
        bookSelected = @"job";
    }else if ([book isEqualToString:@"Psalms"]) {
        bookSelected = @"ps";
    }else if ([book isEqualToString:@"Proverbs"]) {
        bookSelected = @"prov";
    }else if ([book isEqualToString:@"Ecclesiastes"]) {
        bookSelected = @"eccl";
    }else if ([book isEqualToString:@"Song of Solomon"]) {
        bookSelected = @"song";
    }else if ([book isEqualToString:@"Isaiah"]) {
        bookSelected = @"isa";
    }else if ([book isEqualToString:@"Jeremiah"]) {
        bookSelected = @"jer";
    }else if ([book isEqualToString:@"Lamentations"]) {
        bookSelected = @"lam";
    }else if ([book isEqualToString:@"Ezekiel"]) {
        bookSelected = @"ezek";
    }else if ([book isEqualToString:@"Daniel"]) {
        bookSelected = @"dan";
    }else if ([book isEqualToString:@"Hosea"]) {
        bookSelected = @"hosea";
    }else if ([book isEqualToString:@"Joel"]) {
        bookSelected = @"joel";
    }else if ([book isEqualToString:@"Amos"]) {
        bookSelected = @"amos";
    }else if ([book isEqualToString:@"Obadiah"]) { // has a funny url
        bookSelected = @"obad";
        hasOneChapter = YES;
    }else if ([book isEqualToString:@"Jonah"]) {
        bookSelected = @"jonah";
    }else if ([book isEqualToString:@"Micah"]) {
        bookSelected = @"micah";
    }else if ([book isEqualToString:@"Nahum"]) {
        bookSelected = @"nahum";
    }else if ([book isEqualToString:@"Habakkuk"]) {
        bookSelected = @"hab";
    }else if ([book isEqualToString:@"Zephaniah"]) {
        bookSelected = @"zeph";
    }else if ([book isEqualToString:@"Haggai"]) {
        bookSelected = @"hag";
    }else if ([book isEqualToString:@"Zechariah"]) {
        bookSelected = @"zech";
    }else if ([book isEqualToString:@"Malachi"]) {
        bookSelected = @"mal";
    }else if ([book isEqualToString:@"Matthew"]) {
        bookSelected = @"matt";
    }else if ([book isEqualToString:@"Mark"]) {
        bookSelected = @"mark";
    }else if ([book isEqualToString:@"Luke"]) {
        bookSelected = @"luke";
    }else if ([book isEqualToString:@"John"]) {
        bookSelected = @"john";
    }else if ([book isEqualToString:@"Acts"]) {
        bookSelected = @"acts";
    }else if ([book isEqualToString:@"Romans"]) {
        bookSelected = @"rom";
    }else if ([book isEqualToString:@"1 Corinthians"]) {
        bookSelected = @"1-cor";
    }else if ([book isEqualToString:@"2 Corinthians"]) {
        bookSelected = @"2-cor";
    }else if ([book isEqualToString:@"Galatians"]) {
        bookSelected = @"gal";
    }else if ([book isEqualToString:@"Ephesians"]) {
        bookSelected = @"eph";
    }else if ([book isEqualToString:@"Philippians"]) {
        bookSelected = @"philip";
    }else if ([book isEqualToString:@"Colossians"]) {
        bookSelected = @"col";
    }else if ([book isEqualToString:@"1 Thessalonians"]) {
        bookSelected = @"1-thes";
    }else if ([book isEqualToString:@"2 Thessalonians"]) {
        bookSelected = @"2-thes";
    }else if ([book isEqualToString:@"1 Timothy"]) {
        bookSelected = @"1-tim";
    }else if ([book isEqualToString:@"2 Timothy"]) {
        bookSelected = @"2-tim";
    }else if ([book isEqualToString:@"Titus"]) {
        bookSelected = @"titus";
    }else if ([book isEqualToString:@"Philemon"]) { // has a funny url
        bookSelected = @"philem";
        hasOneChapter = YES;
    }else if ([book isEqualToString:@"Hebrews"]) {
        bookSelected = @"heb";
    }else if ([book isEqualToString:@"James"]) {
        bookSelected = @"james";
    }else if ([book isEqualToString:@"1 Peter"]) {
        bookSelected = @"1-pet";
    }else if ([book isEqualToString:@"2 Peter"]) {
        bookSelected = @"2-pet";
    }else if ([book isEqualToString:@"1 John"]) {
        bookSelected = @"1-jn";
    }else if ([book isEqualToString:@"2 John"]) { // has a funny url
        bookSelected = @"2-jn";
        hasOneChapter = YES;
    }else if ([book isEqualToString:@"3 John"]) { // has a funny url
        bookSelected = @"3-jn";
        hasOneChapter = YES;
    }else if ([book isEqualToString:@"Jude"]) { // has a funny url
        bookSelected = @"jude";
        hasOneChapter = YES;
    }else if ([book isEqualToString:@"1 Nephi"]) {
        bookSelected = @"1-ne";
    }else if ([book isEqualToString:@"2 Nephi"]) {
        bookSelected = @"2-ne";
    }else if ([book isEqualToString:@"Jacob"]) {
        bookSelected = @"jacob";
    }else if ([book isEqualToString:@"Enos"]) {
        bookSelected = @"enos";
    }else if ([book isEqualToString:@"Jarom"]) { // has a funny url
        bookSelected = @"jarom";
        hasOneChapter = YES;
    }else if ([book isEqualToString:@"Omni"]) { // has a funny url
        bookSelected = @"omni";
        hasOneChapter = YES;
    }else if ([book isEqualToString:@"Words of Mormon"]) { // has a funny url
        bookSelected = @"w-of-m";
        hasOneChapter = YES;
    }else if ([book isEqualToString:@"Mosiah"]) {
        bookSelected = @"mosiah";
    }else if ([book isEqualToString:@"Alma"]) {
        bookSelected = @"alma";
    }else if ([book isEqualToString:@"Helaman"]) {
        bookSelected = @"hel";
    }else if ([book isEqualToString:@"3 Nephi"]) {
        bookSelected = @"3-ne";
    }else if ([book isEqualToString:@"4 Nephi"]) { // has a funny url
        bookSelected = @"4-ne";
        hasOneChapter = YES;
    }else if ([book isEqualToString:@"Mormon"]) {
        bookSelected = @"morm";
    }else if ([book isEqualToString:@"Ether"]) {
        bookSelected = @"ether";
    }else if ([book isEqualToString:@"Moroni"]) {
        bookSelected = @"moro";
    }else if ([book isEqualToString:@"Moses"]) {
        bookSelected = @"moses";
    }else if ([book isEqualToString:@"Abraham"]) {
        bookSelected = @"abr";
    }else if ([book isEqualToString:@"Joseph Smith-Matthew"]) {//5
        bookSelected = @"js-m";
        hasOneChapter = YES;
    }else if ([book isEqualToString:@"Joseph Smith-History"]) {//6
        bookSelected = @"js-h";
        hasOneChapter = YES;
    }else if ([book isEqualToString:@"Articles of Faith"]) {
        bookSelected = @"a-of-f";
        hasOneChapter = YES;
    }

    
    NSString *urlToGet = [NSString stringWithFormat:@"https://www.lds.org/scriptures/%@/%@/%@?lang=eng", parent_book, book, chapter];
    
    _currentlyLookingfor = @"Verses";
    
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 5,5)];
    _webView.delegate = self;
    NSString *url = urlToGet;
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    _loadCount = 0;
    [_webView loadRequest:nsrequest];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _loadCount++;
//    NSLog(@"%i", _loadCount);
    
    if ([_currentlyLookingfor isEqualToString:@"Book"]) {
        
        if (_loadCount == 2) {
            
            NSString *countOfBooks1 = [self.webView stringByEvaluatingJavaScriptFromString:@"function getCount() {"
                                       "var count = document.getElementsByClassName('books')[0].children.length;"
                                       "return count };"
                                       "getCount();"];
            NSLog(@"%@", countOfBooks1);
            
            NSMutableArray *bookNames = [NSMutableArray new];
            for (int i = 0; i < [countOfBooks1 intValue]; i++) {
                
                NSString *bName = [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"function getName() {"
                                                                                        "var name = document.getElementsByClassName('books')[0].getElementsByTagName('li')[%i].getElementsByTagName('a')[0].textContent;"
                                                                                        "return name };"
                                                                                        "getName();", i]];
                bName = [bName stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                bName = [bName stringByReplacingOccurrencesOfString:@"U00a0" withString:@" "];
                
                [bookNames addObject:bName];
                
            }
            
            NSLog(@"%@", bookNames);
            
            NSString *countOfBooks2 = [self.webView stringByEvaluatingJavaScriptFromString:@"function getCount() {"
                                       "var count = document.getElementsByClassName('books')[1].children.length;"
                                       "return count };"
                                       "getCount();"];
            NSLog(@"%@", countOfBooks2);
            
            for (int i = 0; i < [countOfBooks2 intValue]; i++) {
                
                NSString *bName = [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"function getName() {"
                                                                                        "var name = document.getElementsByClassName('books')[1].getElementsByTagName('li')[%i].getElementsByTagName('a')[0].textContent;"
                                                                                        "return name };"
                                                                                        "getName();", i]];
                bName = [bName stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                bName = [bName stringByReplacingOccurrencesOfString:@"U00a0" withString:@" "];
                [bookNames addObject:bName];
                
            }
            
            if ([_currentBook isEqualToString:@"New Testament"]) {
                _currentBook = [_currentBook stringByAppendingString:@" (KJV)"];
            }
            
//            for (NSString *string in bookNames) {
//                [[Connection connection] didInsertBook:string forMajorBook:_currentBook];
//            }
            
            NSLog(@"%@", @"Done");
            
            [self.delegate didGetBooksAvailableInBook:bookNames];
        }
        
    }else if ([_currentlyLookingfor isEqualToString:@"ChaptersInBook"]) {
        
        if (_loadCount == 2) {
         
            NSString *countOfChapters = [self.webView stringByEvaluatingJavaScriptFromString:@"function getCount() {"
                                       "var count = document.getElementsByClassName('chapters')[0].getElementsByTagName('dl')[0].children.length;"
                                       "return count };"
                                       "getCount();"];
            
            if (_isPGPMA) {
                
                NSMutableArray *chapters = [NSMutableArray new];
                for (int i = 0; i < [countOfChapters intValue]; i++) {
                    NSMutableDictionary *dictionary = [NSMutableDictionary new];
                    
                    if (i == 0) {
                        
                        [dictionary setValue:[self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"function getCount() {"
                                                                                                   "var count = document.getElementsByClassName('chapters')[0].getElementsByTagName('dl')[0].children[1].getElementsByTagName('a')[0].textContent;"
                                                                                                   "return count };"
                                                                                                   "getCount();"]] forKey:@"chapter"];
                        
                        [dictionary setValue:[self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"function getCount() {"
                                                                                                   "var count = document.getElementsByClassName('chapters')[0].getElementsByTagName('dl')[0].children[2].getElementsByTagName('div')[0].textContent;"
                                                                                                   "return count };"
                                                                                                   "getCount();"]] forKey:@"study"];
                        
                        [chapters addObject:dictionary];
                        
                    }else if (i % 2 == 0) {
                        
                        [dictionary setValue:[self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"function getCount() {"
                                                                                                   "var count = document.getElementsByClassName('chapters')[0].getElementsByTagName('dl')[0].children[%i].getElementsByTagName('a')[0].textContent;"
                                                                                                   "return count };"
                                                                                                   "getCount();", i + 1]] forKey:@"chapter"];
                        
                        [dictionary setValue:[self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"function getCount() {"
                                                                                                   "var count = document.getElementsByClassName('chapters')[0].getElementsByTagName('dl')[0].children[%i].getElementsByTagName('div')[0].textContent;"
                                                                                                   "return count };"
                                                                                                   "getCount();", i + 2]] forKey:@"study"];
                        
                        [chapters addObject:dictionary];
                        
                    }
                }
                [self.delegate didGetChaptersForBook:chapters];
                
            }else {
                
                NSMutableArray *chapters = [NSMutableArray new];
                for (int i = 0; i < [countOfChapters intValue]; i++) {
                    NSMutableDictionary *dictionary = [NSMutableDictionary new];
                    
                    if (i == 0) {
                        
                        [dictionary setValue:[self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"function getCount() {"
                                                                                                   "var count = document.getElementsByClassName('chapters')[0].getElementsByTagName('dl')[0].children[0].getElementsByTagName('a')[0].textContent;"
                                                                                                   "return count };"
                                                                                                   "getCount();"]] forKey:@"chapter"];
                        
                        [dictionary setValue:[self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"function getCount() {"
                                                                                                   "var count = document.getElementsByClassName('chapters')[0].getElementsByTagName('dl')[0].children[1].getElementsByTagName('div')[0].textContent;"
                                                                                                   "return count };"
                                                                                                   "getCount();"]] forKey:@"study"];
                        
                        [chapters addObject:dictionary];
                        
                    }else {
                        
                        NSString *check = [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"function getCount() {"
                                                                                                "var count = document.getElementsByClassName('chapters')[0].getElementsByTagName('dl')[0].children[%i].getElementsByTagName('a')[0].textContent;"
                                                                                                "return count };"
                                                                                                "getCount();", i]];
                        
                        if (check.length > 0 ) {
                            [dictionary setValue:[self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"function getCount() {"
                                                                                                       "var count = document.getElementsByClassName('chapters')[0].getElementsByTagName('dl')[0].children[%i].getElementsByTagName('a')[0].textContent;"
                                                                                                       "return count };"
                                                                                                       "getCount();", i]] forKey:@"chapter"];
                            
                            [dictionary setValue:[self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"function getCount() {"
                                                                                                       "var count = document.getElementsByClassName('chapters')[0].getElementsByTagName('dl')[0].children[%i].getElementsByTagName('div')[0].textContent;"
                                                                                                       "return count };"
                                                                                                       "getCount();", i + 1]] forKey:@"study"];
                            
                            [chapters addObject:dictionary];
                        }
                        
                        
                        
                    }
                }

                [self.delegate didGetChaptersForBook:chapters];
            }
            
        
        }
        
    }else if ([_currentlyLookingfor isEqualToString:@"Verses"]) {
        
        if (_loadCount == 2) {
            
            NSString *countOfVerses = [self.webView stringByEvaluatingJavaScriptFromString:@"function getCount() {"
                                         "var count = document.getElementsByClassName('verses')[0].children.length;"
                                         "return count };"
                                         "getCount();"];
            
            
            NSMutableArray *verses = [NSMutableArray new];
            for (int i = 0; i < [countOfVerses intValue]; i++) {
                NSMutableDictionary *dictionary = [NSMutableDictionary new];
            
                
                NSString *verseNumber = [[self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"function getCount() {"
                                                                                               "var count = document.getElementsByClassName('verses')[0].getElementsByTagName('p')[%i].getElementsByClassName('verse')[0].innerHTML;"
                                                                                               "return count };"
                                                                                               "getCount();", i]] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
                
                [dictionary setValue:verseNumber forKey:@"verse_num"];
                
                NSString *verse = [[self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"function getCount() {"
                                                                                         "var count = document.getElementsByClassName('verses')[0].getElementsByTagName('p')[%i].innerHTML;"
                                                                                         "var StrippedString = count.replace(/(<([^>]+)>)/ig,'');"
                                                                                         "return StrippedString };"
                                                                                         "getCount();", i]] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
                
                [dictionary setValue:verse forKey:@"verse"];
                [dictionary setValue:@"no" forKey:@"selected"];
                
                [verses addObject:dictionary];
            }
//            NSLog(@"%@", verses);
            [self.delegate didGetVersesForChapter:verses];
            
        }
        
    }
    
    

}

@end
