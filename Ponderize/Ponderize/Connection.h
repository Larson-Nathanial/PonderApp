//
//  Connection.h
//  Ponderize
//
//  Created by Nathan Larson on 10/7/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ConnectionDelegate <NSObject>

@optional
- (void)raiseNoInternetMessage;

@end

@interface Connection : NSObject

@property (nonatomic, assign) id<ConnectionDelegate>delegate;

+ (Connection *)connection;

- (NSArray *)loadGroupsForUser;
- (NSArray *)loadGroupMembersForGroupId:(NSString *)group_id;
- (NSArray *)loadGroupInvitationsForUser;

- (NSArray *)loadPostsForUser;
- (NSArray *)loadPostsForGroup:(NSString *)group_id;

- (NSArray *)loadCommentsForPostId:(NSString *)post_id;

- (NSArray *)getMinorBooksForMajorBook:(NSString *)majorBook;

- (NSArray *)getChaptersForMinorBookId:(NSString *)minor_book_id;

- (NSArray *)getVersesForChapterId:(NSString *)chapter_id;

- (BOOL)didCreateNewGroupWithName:(NSString *)group_name;
- (BOOL)didDeleteGroupWithId:(NSString *)group_id;

- (BOOL)didInviteGroupMemberViaEmail:(NSString *)email forGroupId:(NSString *)group_id;
- (BOOL)didRemoveGroupMember:(NSString *)group_member_id;

- (BOOL)didAcceptInviteId:(NSString *)invite_id forGroupId:(NSString *)group_id andUserId:(NSString *)user_id;
- (BOOL)didDeclineInviteId:(NSString *)invite_id forGroupId:(NSString *)group_id andUserId:(NSString *)user_id;

- (NSString *)didPostForUserVerse:(NSString *)verse book:(NSString *)book chapter:(NSString *)chapter verse1:(NSString *)verse1 verse2:(NSString *)verse2;

- (BOOL)didMatchPostId:(NSString *)post_id toGroupId:(NSString *)group_id;

- (BOOL)didLikePostId:(NSString *)post_id;

- (BOOL)didCreateNewComment:(NSString *)comment forPostId:(NSString *)post_id;

- (NSString *)getCountOfCommentsOnMyPosts;
- (NSString *)getCountOfTotalGroupPosts;
- (NSString *)getcountOfTotalGroupComments;

- (BOOL)didCreateAccountWithUserName:(NSString *)user_name email:(NSString *)email password:(NSString *)password;

- (BOOL)canUseDBForScriptures;






- (BOOL)didInsertBook:(NSString *)book forMajorBook:(NSString *)major_book;


- (BOOL)didInsertChapterForBook:(NSString *)book chapter:(NSString *)chapter study:(NSString *)study;
- (BOOL)didInsertVerseForchapter_id:(NSString *)chapter_id verse_number:(NSString *)verse_number verse:(NSString *)verse;

@end
