//
//  AWFeedbackItem.m
//  AlfredWorkflow
//
//  Created by Daniel Shannon on 5/24/13.
//  Copyright (c) 2013 Daniel Shannon. All rights reserved.
//

#import "AWFeedbackItem.h"
#import "NSString+XMLEscaping.h"

@implementation AWFeedbackItem

+ (id)validItem:(BOOL)valid withObjectsAndKeys:(id)o, ...
{
    va_list args;
    va_start(args, o);
    int i = 0;

    AWFeedbackItem *item = [[AWFeedbackItem alloc] init];
    item.valid = valid;

    NSMutableArray *k = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *v = [[NSMutableArray alloc] initWithCapacity:0];

    id arg = o;
    do {
        if (i % 2 == 0) {
            [v addObject:[NSString stringWithString:arg]];
        } else if (i % 2 != 0) {
            if ([[arg className] rangeOfString:@"String"].location != NSNotFound)
                [k addObject:arg];
        }
        i++;
    } while ((arg = va_arg(args, id)));
    va_end(args);

    NSDictionary *kv = [NSDictionary dictionaryWithObjects:v forKeys:k];
    [item setValuesForKeysWithDictionary:kv];
    
    return item;
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        _title = @"";
        _subtitle = @"";
        _icon = @"icon.png";

        _uid = nil;
        _valid = NO;
        _autocomplete = nil;
        _arg = nil;

        _fileicon = NO;
        _filetype = NO;
        _type = nil;

        self->tags_ = [NSArray arrayWithObjects:@"title", @"subtitle", @"icon", nil];
        self->attrib_ = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"uid", @"valid", @"autocomplete", @"arg", @"type", nil], @"item", [NSArray arrayWithObjects:@"fileicon", @"filetype", nil], @"icon", nil];
    }
    
    return self;
}

- (id)initAsValid:(BOOL)valid withObjects:(NSArray *)obj forKeys:(NSArray *)key
{
    if ([obj count] != [key count]) {
        return nil;
    }

    self = [super init];
    self->tags_ = [NSArray arrayWithObjects:@"title", @"subtitle", @"icon", nil];
    self->attrib_ = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"uid", @"valid", @"autocomplete", @"arg", nil], @"item", [NSArray arrayWithObjects:@"fileicon", @"filetype", @"type", nil], @"icon", nil];

    if (self != nil) {
        for (NSUInteger i = 0; i < [obj count]; i++) {
            id v = [obj objectAtIndex:i];
            NSString *k = [key objectAtIndex:i];
            [self setValue:v forKey:k];
        }
    }

    return self;
}

- (NSString *)xml
{
    NSString *x = [NSString string];

    NSString *i = @"<item";
    for (NSString *k in [self->attrib_ objectForKey:@"item"]) {
        id v = [self valueForKey:k];
        if(v != nil) {
            if ([v respondsToSelector:@selector(escapedString)]) {
                v = [v escapedString];
            }
            if ([k isEqualToString:@"valid"])
                v = self->valid_;
            i = [i stringByAppendingFormat:@" %@=\"%@\"", k, v];
        }
    }
    i = [i stringByAppendingString:@">"];
    x = [x stringByAppendingString:i];

    for (NSString *k in self->tags_) {
        id v = [self valueForKey:k];

        if (v != nil) {
            NSString *strV = [NSString stringWithFormat:@"%@", v];
            strV = [strV escapedString];

            NSArray *attr = [self->attrib_ objectForKey:k];
            NSMutableString *format = [NSMutableString stringWithFormat:@"<%@", k];
            if (attr != nil) {
                for (NSString *a in attr) {
                    NSString *av;
                    if ([a isEqualToString:@"valid"])
                        av = self->valid_;
                    else if ([a isEqualToString:@"fileicon"] || [a isEqualToString:@"filetype"])
                        av = self->file_;
                    else if ([self valueForKey:a] != nil)
                        av = [self valueForKey:a];

                    if (av != nil)
                        [format appendFormat:@" %@=\"%@\"", a, av];
                }
            }
            [format appendString:@">"];
            x = [x stringByAppendingFormat:@"%@%@</%@>", format, strV, k];
        }
    }

    return x;
}





#pragma mark -
#pragma mark Custom Setters

- (void)setValid:(BOOL)valid
{
    _valid = valid;
    self->valid_ = valid ? @"yes" : @"no";
}

- (void)setFileicon:(BOOL)fileicon
{
    _fileicon = fileicon;
    self->file_ = @"fileicon";
}

- (void)setFiletype:(BOOL)filetype
{
    _filetype = filetype;
    self->file_ = @"filetype";
}

@end
