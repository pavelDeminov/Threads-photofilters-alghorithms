//
//  Person+Extended.h
//  Test
//
//  Created by Pavel Deminov on 15/07/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "Person.h"

#define kPersonID @"kPersonID"
#define kPersonName @"kPersonName"
#define kPersonCountry @"kPersonCountry"

@interface Person (Extended)

-(void) updateWithDict:(NSDictionary*)dict;

@end
