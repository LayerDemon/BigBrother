//
//  UnitedInfoModel.m
//  BigBrother
//
//  Created by zhangyi on 16/5/15.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "UnitedInfoModel.h"

@interface UnitedInfoModel ()

@property (strong, nonatomic) id        unitedDetailData;

@end

@implementation UnitedInfoModel

//获取门派资料
- (void)getUnitedInfoWithId:(NSString *)idString limit:(NSString *)limit
{
    NSMutableDictionary * dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setObject:idString forKey:@"id"];
    [dataDic setObject:limit forKey:@"limit"];
    
    [NetworkingManager postWithURL:@"http://121.42.161.141:8080/rent-car/api/im/groups/detail" params:dataDic successAction:^(NSURLSessionDataTask *operation, id responseObj) {
        NSLog(@"getAllRequest -- %@",responseObj);
        self.unitedDetailData = responseObj;
        
    } failAction:^(NSError *error, id responseObj) {
        NSLog(@"error -- %@",error.localizedDescription);
    }];

}

@end
