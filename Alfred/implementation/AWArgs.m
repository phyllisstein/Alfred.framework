//
//  AWArgs.m
//  Alfred
//
//  Created by Daniel Shannon on 5/26/13.
//  Copyright (c) 2013 Daniel Shannon. All rights reserved.
//

#include <getopt.h>
#import <objc/objc-runtime.h>
#import "AWArgs.h"

@interface AWArgs ()

@property (readwrite) const char    **argv;
@property (readwrite) int             argc;
@property (readwrite) NSArray        *keys;
@property (readwrite) NSDictionary   *val_;

@end

@implementation AWArgs

- (id)initWithArgs:(const char *[])argv andKeys:(NSArray *)keys count:(int)argc
{
    self = [super init];
    if (self != nil) {
        _argv = argv;
        _argc = argc;
        _keys = keys;
    }
    return self;
}

- (NSDictionary *)parse
{
    if (self.argc == 1) {
        return [NSDictionary dictionary];
    }

    int c;
    int o = (int)[self.keys count] + 1;
    NSMutableString *fmt = [[NSMutableString alloc] initWithCapacity:self.argc];
    struct option long_options[o];
    memset(&long_options, 0, sizeof(struct option)*o);
    for (int i = 0; i < [self.keys count]; i++) {
        NSDictionary *kv = [self.keys objectAtIndex:i];
        NSString *name = [kv objectForKey:@"name"];
        [fmt appendString:name];
        const char *n = [name UTF8String];
        NSNumber *has_arg = [kv objectForKey:@"has_arg"];
        int h_a;
        if ([has_arg isEqualToNumber:@YES])
            h_a = required_argument;
        else if ([has_arg isEqualToNumber:@NO])
            h_a = no_argument;
        else
            h_a = optional_argument;
        unichar flag = [[kv objectForKey:@"flag"] characterAtIndex:0];

        long_options[i].name = n;
        long_options[i].has_arg = h_a;
        long_options[i].flag = 0;
        long_options[i].val = flag;
    }
    int last = o - 1;
    long_options[last].name = 0;
    long_options[last].has_arg = 0;
    long_options[last].flag = 0;
    long_options[last].val = 0;

    NSMutableDictionary *d = [[NSMutableDictionary alloc] initWithCapacity:0];
    int option_index = 0;
    while (YES) {
        c = getopt_long(self.argc, (char * const *)self.argv, [fmt UTF8String], long_options, &option_index);

        if (c == -1) {
            break;
        }
        NSString *k = nil;
        id v = nil;
        if (c == 0) {
            k = [NSString stringWithCString:long_options[option_index].name encoding:NSUTF8StringEncoding];
            if (optarg) {
                v = [NSString stringWithCString:optarg encoding:NSUTF8StringEncoding];
            } else {
                v = @YES;
            }
            [d setObject:v forKey:k];
        } else {
            const char _c = (const char)c;
            k = [NSString stringWithCString:&_c encoding:NSUTF8StringEncoding];
            if (optarg) {
                v = [NSString stringWithCString:optarg encoding:NSUTF8StringEncoding];
            } else {
                v = @YES;
            }
            [d setObject:v forKey:k];
        }
    }

    int oi = option_index + 2; // Advance from the last argument (+1) and ignore argv[0] (+1)
    NSMutableString *q = [[NSMutableString alloc] initWithCapacity:0];
    for (int i = oi; i < self.argc; i++) {
        [q appendFormat:@"%@ ", [NSString stringWithCString:self.argv[i] encoding:NSUTF8StringEncoding]];
    }
    q = [NSMutableString stringWithString:[q stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    NSLog(@"q=%@, option_index=%i, self.argv=%s", q, option_index, *self.argv);
    [d setObject:q forKey:@"query"];

    return d;
}



@end
