//
//  NSUserDefaults+GODictionaryLiterals.h
//  EasyFollow
//
//  Created by Samuel Goodwin on 4/9/12.
//  Copyright (c) 2012 SNAP Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (GODictionaryLiterals)

- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)object forKeyedSubscript:(id)key;

@end
