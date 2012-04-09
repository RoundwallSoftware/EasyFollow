//
//  NSDictionary+GODictionaryLiterals.m
//  EasyFollow
//
//  Created by Samuel Goodwin on 4/9/12.
//  Copyright (c) 2012 SNAP Interactive. All rights reserved.
//

#import "NSDictionary+GODictionaryLiterals.h"

@implementation NSDictionary (GODictionaryLiterals)

- (id)objectForKeyedSubscript:(id)key{
    return [self objectForKey:key];
}

@end
