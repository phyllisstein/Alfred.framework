//
//  AWWorkflow.h
//  alfred
//
//  Created by Daniel Shannon on 5/25/13.
//  Copyright (c) 2013 Daniel Shannon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AWWorkflow : NSObject

@property NSString *bid;

- (NSString *)bundleID;
- (NSString *)local;
- (NSString *)local:(NSString *)filename;
- (NSString *)cache;
- (NSString *)cache:(NSString *)filename;
- (NSString *)storage;
- (NSString *)storage:(NSString *)filename;

- (void)log:(NSString *)s, ...;

- (void)flush:(BOOL)f feedbackItems:(id)fbi, ... NS_REQUIRES_NIL_TERMINATION;
- (void)flush:(BOOL)f feedbackArray:(NSArray *)fba;

- (NSArray *)fuzzySearchFor:(NSString *)query in:(NSArray *)array withKeyBlock:(NSString *(^)(id))key;

- (void)setPreference:(id)value forKey:(NSString *)key;
- (id)preferenceForKey:(NSString *)key;

@end
