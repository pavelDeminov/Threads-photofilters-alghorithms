//
//  Person+Extended.m
//  Test
//
//  Created by Pavel Deminov on 15/07/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "Person+Extended.h"

@implementation Person (Extended)

-(void) updateWithDict:(NSDictionary*)dict {
    
    NSNumber *uid = [dict objectForKey:kPersonID];
    if (uid) {
        self.uid =uid;
        
    }
    
    NSString *name = [dict objectForKey:kPersonName];
    if (name && name.length) {
        self.name =name;
        
    }
    
    NSString *country = [dict objectForKey:kPersonCountry];
    if (country && country.length) {
        self.country =country;
        
    }

    
    
}

@end
