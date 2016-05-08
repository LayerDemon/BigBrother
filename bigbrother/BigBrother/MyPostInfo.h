//
//  MyPostInfo.h
//  BigBrother
//
//  Created by xiaoyu on 16/3/5.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MyPostInfoTableShowType) {
    MyPostInfoTableShowTypeUnAuth,
    MyPostInfoTableShowTypeShowing,
    MyPostInfoTableShowTypeDone,
};

@interface MyPostInfo : NSObject

@property (nonatomic,assign) int postInfoID;

@property (nonatomic,copy) NSString *createdTime;

@property (nonatomic,copy) NSString *showingStatus;

@property (nonatomic,copy) NSString *status;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *postType;
@property (nonatomic,copy) NSString *showingPostType;

@property (nonatomic,assign) int matchedCount;

@property (nonatomic,assign) BOOL onTop;

@property (nonatomic,assign) MyPostInfoTableShowType infoType;

@property (nonatomic,assign) BOOL isProvide;

+(instancetype)infoWithNetDictionary:(NSDictionary *)netDic;

-(instancetype)updateWithNetDictionary:(NSDictionary *)netDic;

@end
