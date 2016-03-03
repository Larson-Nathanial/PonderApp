//
//  GetScriptureClass.h
//  Ponderize
//
//  Created by Nathan Larson on 10/6/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GetScriptureDelegate <NSObject>

@optional
- (void)didGetBooksAvailableInBook:(NSArray *)books;
- (void)didGetChaptersForBook:(NSArray *)chapters;
- (void)didGetVersesForChapter:(NSArray *)verses;

@end

@interface GetScriptureClass : NSObject

@property (nonatomic) id<GetScriptureDelegate> delegate;

+ (GetScriptureClass *)getScriptureStuff;

- (void)getBooksAvailableInBook:(NSString *)book realBookName:(NSString *)book_name;
- (void)getChaptersForBook:(NSString *)book andParentBook:(NSString *)parent_book;
- (void)getVersesForChapter:(NSString *)chapter andBook:(NSString *)book andParentBook:(NSString *)parent_book;

@end
