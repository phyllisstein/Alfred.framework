//
//  AWPreferences.h
//  alfred
//
//  Created by Daniel Shannon on 5/25/13.
//  Copyright (c) 2013 Daniel Shannon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AWPreferences : NSObject

@property (readonly) NSCache *c;

- (void)setPreference:(id)v forKey:(NSString *)k;
- (id)preferenceForKey:(NSString *)k;

@end
