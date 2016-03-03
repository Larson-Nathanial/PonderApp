//
//  Connection.m
//  Ponderize
//
//  Created by Nathan Larson on 10/7/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import "Connection.h"

@interface Connection ()

@property (nonatomic) NSString *verification;

@end

@implementation Connection

+ (Connection *)connection
{
    static Connection *connection = nil;
    
    if (!connection) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            connection = [[self alloc] initPrivate];
        });
    }
    return connection;
}

- (instancetype)initPrivate
{
    self = [super init];
    _verification = @"a secure string....";
    return self;
}

- (NSArray *)loadGroupsForUser
{
    NSString *user_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
    
    NSString *post = [NSString stringWithFormat:@"verify=%@&user_id=%@", _verification, user_id];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/Ponderize/LoadGroups.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        [self.delegate raiseNoInternetMessage];
        return nil;
    }else {
        NSArray *returnData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnData.count > 0) {
                return returnData;
            }else {
                return nil;
            }
        }
    }
    
    return nil;
}

- (NSArray *)loadGroupInvitationsForUser
{
    NSString *user_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
    
    NSString *post = [NSString stringWithFormat:@"verify=%@&user_id=%@", _verification, user_id];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/Ponderize/LoadGroupInvitations.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        [self.delegate raiseNoInternetMessage];
        return nil;
    }else {
        NSArray *returnData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnData.count > 0) {
                return returnData;
            }else {
                return nil;
            }
        }
    }
    
    return nil;
}

- (NSArray *)loadGroupMembersForGroupId:(NSString *)group_id
{
    
    NSString *post = [NSString stringWithFormat:@"verify=%@&group_id=%@", _verification, group_id];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/Ponderize/LoadGroupMembers.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        [self.delegate raiseNoInternetMessage];
        return nil;
    }else {
        NSArray *returnData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnData.count > 0) {
                return returnData;
            }else {
                return nil;
            }
        }
    }
    
    return nil;
}

- (NSArray *)loadPostsForUser
{
    NSString *user_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
    
    NSString *post = [NSString stringWithFormat:@"verify=%@&user_id=%@", _verification, user_id];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/Ponderize/LoadUsersPosts.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        [self.delegate raiseNoInternetMessage];
        return nil;
    }else {
        NSArray *returnData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnData.count > 0) {
                return returnData;
            }else {
                return nil;
            }
        }
    }
    
    return nil;
}

- (NSArray *)loadPostsForGroup:(NSString *)group_id
{
    
    NSString *post = [NSString stringWithFormat:@"verify=%@&group_id=%@", _verification, group_id];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/Ponderize/LoadPostsForGroup.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        [self.delegate raiseNoInternetMessage];
        return nil;
    }else {
        NSArray *returnData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnData.count > 0) {
                return returnData;
            }else {
                return nil;
            }
        }
    }
    
    return nil;
}

- (NSArray *)loadCommentsForPostId:(NSString *)post_id
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&post_id=%@", _verification, post_id];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/Ponderize/LoadCommentsForPostId.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        [self.delegate raiseNoInternetMessage];
        return nil;
    }else {
        NSArray *returnData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnData.count > 0) {
                return returnData;
            }else {
                return nil;
            }
        }
    }
    
    return nil;
}

- (NSArray *)getMinorBooksForMajorBook:(NSString *)majorBook
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&majorBook=%@", _verification, majorBook];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/Ponderize/GetMinorBooks.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        [self.delegate raiseNoInternetMessage];
        return nil;
    }else {
        NSArray *returnData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];

        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnData.count > 0) {
                return returnData;
            }else {
                return nil;
            }
        }
    }
    
    return nil;
}

- (NSArray *)getChaptersForMinorBookId:(NSString *)minor_book_id
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&minor_book_id=%@", _verification, minor_book_id];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/Ponderize/GetChaptersForBookId.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        [self.delegate raiseNoInternetMessage];
        return nil;
    }else {
        NSArray *returnData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnData.count > 0) {
                return returnData;
            }else {
                return nil;
            }
        }
    }
    
    return nil;
}

- (NSArray *)getVersesForChapterId:(NSString *)chapter_id
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&chapter_id=%@", _verification, chapter_id];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/Ponderize/GetVersesForChapter.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        [self.delegate raiseNoInternetMessage];
        return nil;
    }else {
        NSArray *returnData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnData.count > 0) {
                return returnData;
            }else {
                return nil;
            }
        }
    }
    
    return nil;
}

- (NSString *)didPostForUserVerse:(NSString *)verse book:(NSString *)book chapter:(NSString *)chapter verse1:(NSString *)verse1 verse2:(NSString *)verse2
{
    NSString *user_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
    
    NSString *post = [NSString stringWithFormat:@"verify=%@&user_id=%@&verse=%@&book=%@&chapter=%@&verse1=%@&verse2=%@", _verification, user_id, verse, book, chapter, verse1, verse2];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/Ponderize/PostForUser.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        [self.delegate raiseNoInternetMessage];
        return nil;
    }else {
        NSString *returnData = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnData.length > 0) {
                return returnData;
            }else {
                return nil;
            }
        }
    }
    
    return nil;
}

- (NSString *)getCountOfCommentsOnMyPosts
{
    NSString *user_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
    
    NSString *post = [NSString stringWithFormat:@"verify=%@&user_id=%@", _verification, user_id];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/Ponderize/CountOfCommentsOnMyPosts.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        [self.delegate raiseNoInternetMessage];
        return nil;
    }else {
        NSString *returnData = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnData.length > 0) {
                return returnData;
            }else {
                return nil;
            }
        }
    }
    
    return nil;
}

- (NSString *)getCountOfTotalGroupPosts
{
    NSString *user_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
    
    NSString *post = [NSString stringWithFormat:@"verify=%@&user_id=%@", _verification, user_id];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/Ponderize/CountOfTotalGroupPosts.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        [self.delegate raiseNoInternetMessage];
        return nil;
    }else {
        NSString *returnData = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnData.length > 0) {
                return returnData;
            }else {
                return nil;
            }
        }
    }
    
    return nil;
}

- (NSString *)getcountOfTotalGroupComments
{
    NSString *user_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
    
    NSString *post = [NSString stringWithFormat:@"verify=%@&user_id=%@", _verification, user_id];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/Ponderize/CountOfTotalGroupComments.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        [self.delegate raiseNoInternetMessage];
        return nil;
    }else {
        NSString *returnData = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnData.length > 0) {
                return returnData;
            }else {
                return nil;
            }
        }
    }
    
    return nil;
}

- (BOOL)canUseDBForScriptures
{
    
    NSString *post = [NSString stringWithFormat:@"verify=%@", _verification];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/Ponderize/CanUseDB.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        [self.delegate raiseNoInternetMessage];
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if ([returnString isEqualToString:@"1"]) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

- (BOOL)didCreateNewGroupWithName:(NSString *)group_name
{
    NSString *user_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
    
    NSString *post = [NSString stringWithFormat:@"verify=%@&user_id=%@&group_name=%@", _verification, user_id, group_name];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/Ponderize/CreateGroup.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        [self.delegate raiseNoInternetMessage];
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

- (BOOL)didDeleteGroupWithId:(NSString *)group_id
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&group_id=%@", _verification, group_id];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/Ponderize/DeleteGroup.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        [self.delegate raiseNoInternetMessage];
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

- (BOOL)didInviteGroupMemberViaEmail:(NSString *)email forGroupId:(NSString *)group_id
{
    NSString *user_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
    
    NSString *post = [NSString stringWithFormat:@"verify=%@&group_id=%@&email=%@&user_id=%@", _verification, group_id, email, user_id];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/Ponderize/InviteGroupMember.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        [self.delegate raiseNoInternetMessage];
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

- (BOOL)didRemoveGroupMember:(NSString *)group_member_id
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&group_member_id=%@", _verification, group_member_id];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/Ponderize/RemoveGroupMember.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        [self.delegate raiseNoInternetMessage];
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

- (BOOL)didAcceptInviteId:(NSString *)invite_id forGroupId:(NSString *)group_id andUserId:(NSString *)user_id
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&invite_id=%@&group_id=%@&user_id=%@", _verification, invite_id, group_id, user_id];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/Ponderize/AcceptGroupInvite.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        [self.delegate raiseNoInternetMessage];
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

- (BOOL)didDeclineInviteId:(NSString *)invite_id forGroupId:(NSString *)group_id andUserId:(NSString *)user_id
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&invite_id=%@&group_id=%@&user_id=%@", _verification, invite_id, group_id, user_id];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/Ponderize/DeclineGroupInvite.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        [self.delegate raiseNoInternetMessage];
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

- (BOOL)didMatchPostId:(NSString *)post_id toGroupId:(NSString *)group_id
{
    NSString *user_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
    
    NSString *post = [NSString stringWithFormat:@"verify=%@&post_id=%@&group_id=%@&user_id=%@", _verification, post_id, group_id, user_id];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/Ponderize/MatchPostToGroup.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        [self.delegate raiseNoInternetMessage];
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

- (BOOL)didLikePostId:(NSString *)post_id
{
    NSString *user_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
    
    NSString *post = [NSString stringWithFormat:@"verify=%@&post_id=%@&user_id=%@", _verification, post_id, user_id];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/Ponderize/LikedPostId.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        [self.delegate raiseNoInternetMessage];
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

- (BOOL)didCreateNewComment:(NSString *)comment forPostId:(NSString *)post_id
{
    NSString *user_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"];
    
    NSString *post = [NSString stringWithFormat:@"verify=%@&post_id=%@&user_id=%@&comment=%@", _verification, post_id, user_id, comment];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/Ponderize/CreateCommentForPostId.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        [self.delegate raiseNoInternetMessage];
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

- (BOOL)didCreateAccountWithUserName:(NSString *)user_name email:(NSString *)email password:(NSString *)password;
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&user_name=%@&email=%@&password=%@", _verification, user_name, email, password];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/Ponderize/CreateAccount.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        [self.delegate raiseNoInternetMessage];
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                if ([returnString isEqualToString:@"Invalid Password"]) {
                    return NO;
                }else {
                    [[NSUserDefaults standardUserDefaults] setValue:returnString forKey:@"user_id"];
                }
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

- (BOOL)didInsertBook:(NSString *)book forMajorBook:(NSString *)major_book
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&book=%@&major_book=%@", _verification, book, major_book];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/Ponderize/Books.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        [self.delegate raiseNoInternetMessage];
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

- (BOOL)didInsertChapterForBook:(NSString *)book chapter:(NSString *)chapter study:(NSString *)study
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&book=%@&chapter=%@&study=%@", _verification, book, chapter, study];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/Ponderize/InsertChapter.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        [self.delegate raiseNoInternetMessage];
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

- (BOOL)didInsertVerseForchapter_id:(NSString *)chapter_id verse_number:(NSString *)verse_number verse:(NSString *)verse
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&chapter_id=%@&verse_number=%@&verse=%@", _verification, chapter_id, verse_number, verse];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/Ponderize/InsertVerse.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        [self.delegate raiseNoInternetMessage];
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

@end
