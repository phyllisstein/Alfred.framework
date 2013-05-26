//
//  AWFeedbackItem.h
//  AlfredWorkflow
//
//  Created by Daniel Shannon on 5/24/13.
//  Copyright (c) 2013 Daniel Shannon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AWFeedbackItem : NSObject {
    @private
    NSArray *tags_;
    NSDictionary *attrib_;
    NSString *valid_;
    NSString *file_;
}


@property NSString      *title;
@property NSString      *subtitle;
@property NSString      *uid;
@property (nonatomic)   BOOL valid;
@property NSString      *autocomplete;
@property NSString      *icon;
@property (nonatomic)   BOOL      fileicon;
@property (nonatomic)   BOOL      filetype;
@property NSString      *arg;
@property NSString      *type;

+ (id)validItem:(BOOL)valid withObjectsAndKeys:(id)o, ... NS_REQUIRES_NIL_TERMINATION;
- (id)initAsValid:(BOOL)valid withObjects:(NSArray *)obj forKeys:(NSArray *)key;

- (NSString *)xml;

@end
