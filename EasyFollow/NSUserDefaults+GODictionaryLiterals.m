//
//  NSUserDefaults+GODictionaryLiterals.m
//  EasyFollow
//
//  Created by Samuel Goodwin on 4/9/12.
//  Copyright (c) 2012 SNAP Interactive. All rights reserved.
//

#import "NSUserDefaults+GODictionaryLiterals.h"

@implementation NSUserDefaults (GODictionaryLiterals)

- (id)objectForKeyedSubscript:(id)key{
    return [self objectForKey:key];
}

- (void)setObject:(id)object forKeyedSubscript:(id)key{
    [self setObject:object forKey:key];
}

@end
