//
//  AddFriendsModel.m
//  BigBrother
//
//  Created by zhangyi on 16/5/15.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "AddFriendsModel.h"

@interface AddFriendsModel ()

@property (strong, nonatomic) id      searchFriendsData;
@property (strong, nonatomic) id      searchGroupsData;


@end

@implementation AddFriendsModel

//搜索好友
- (void)searchFriendsWithTerms:(NSString *)terms
{
    NSString *urlStr = [NSString  stringWithFormat:@"/im/friends/search"];
    [NetworkingManager postWithURL:urlStr params:@{@"terms":terms} successAction:^(NSURLSessionDataTask *operation, id responseObj) {
        NSDictionary * dataDic = responseObj;
        NSLog(@"searchFriend -- %@",dataDic);
        self.searchFriendsData = responseObj;
        
    } failAction:^(NSError *error, id responseObj) {
        NSLog(@"error -- %@",error.localizedDescription);
    }];
}

//搜索门派
- (void)searchGroupsWithTerms:(NSString *)terms
{
    NSString *urlStr = [NSString  stringWithFormat:@"/im/groups/search"];
    [NetworkingManager postWithURL:urlStr params:@{@"terms":terms} successAction:^(NSURLSessionDataTask *operation, id responseObj) {
        NSDictionary * dataDic = responseObj;
        NSLog(@"searchGroup -- %@",dataDic);
        self.searchGroupsData = responseObj;
        
    } failAction:^(NSError *error, id responseObj) {
        NSLog(@"error -- %@",error.localizedDescription);
    }];
}


@end
