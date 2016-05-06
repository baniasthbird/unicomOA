//
//  UserInfo.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/13.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.str_name forKey:@"name"];
    [aCoder encodeObject:self.str_username forKey:@"username"];
    [aCoder encodeObject:self.str_gender forKey:@"gender"];
    [aCoder encodeObject:self.str_department forKey:@"department"];
    [aCoder encodeObject:self.str_position forKey:@"position"];
    [aCoder encodeObject:self.str_email forKey:@"e-mail"];
    [aCoder encodeObject:self.str_cellphone forKey:@"cellphone"];
    [aCoder encodeObject:self.str_phonenum forKey:@"phonenum"];
    [aCoder encodeObject:self.str_Logo forKey:@"Logo"];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self=[super init]) {
        self.str_name=[aDecoder decodeObjectForKey:@"name"];
        self.str_username=[aDecoder decodeObjectForKey:@"username"];
        self.str_gender=[aDecoder decodeObjectForKey:@"gender"];
        self.str_department=[aDecoder decodeObjectForKey:@"department"];
        self.str_position=[aDecoder decodeObjectForKey:@"position"];
        self.str_email=[aDecoder decodeObjectForKey:@"e-mail"];
        self.str_cellphone=[aDecoder decodeObjectForKey:@"cellphone"];
        self.str_phonenum=[aDecoder decodeObjectForKey:@"phonenum"];
        self.str_Logo=[aDecoder decodeObjectForKey:@"Logo"];
    }
    return self;
}

@end
