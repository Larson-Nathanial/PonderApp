//
//  ChooseVerses.h
//  Ponderize
//
//  Created by Nathan Larson on 10/5/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseVerses : UIViewController

@property (nonatomic) NSString *book1Selected;
@property (nonatomic) NSString *book2Selected;
@property (nonatomic) NSString *longTitle;
@property (nonatomic) NSString *chapterSelected;
@property (nonatomic) NSString *chapter_id;
@property (nonatomic) BOOL canUseDBForScriptures;

@property (nonatomic) NSString *minor_book_id;

@property (nonatomic) NSString *numOfChapters;
@property (nonatomic) NSArray *allChapters;

@end
