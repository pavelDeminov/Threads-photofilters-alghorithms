//
//  Person.h
//  Test
//
//  Created by Pavel Deminov on 15/07/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic,strong) NSNumber *uid;
@property (nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *country;

@end
