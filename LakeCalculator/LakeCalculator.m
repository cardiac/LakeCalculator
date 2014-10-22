//
//  LakeCalculator.m
//  LakeCalculator
//
//  Created by Ryan Strug on 9/6/14.
//  Copyright (c) 2014 Ryan Strug. All rights reserved.
//

#import "LakeCalculator.h"

struct Peak {
    CGFloat      height;
    NSUInteger   index;
    struct Peak *prev;
};

@interface LakeCalculator() {
    struct Peak *current;
    NSUInteger   peaks;
}

@end

@implementation LakeCalculator

+ (NSNumber *)calculateLakeAreaForHeights:(NSArray *)heights
{
    LakeCalculator *calc = [[LakeCalculator alloc] init];
    calc.heights = heights;
    return [calc calculateLakeArea];
}

- (id)init
{
    if (self = [super init])
        peaks = 0;
    return self;
}

- (BOOL)addPeakWithHeight:(CGFloat)height index:(NSUInteger)index
{
    peaks++;
    
    struct Peak *peak = (struct Peak *)malloc(sizeof(struct Peak));
    if (!peak) {
        NSLog(@"Memory allocation failure, file: %s, line: %u", __FILE__, __LINE__);
        while (current)
            [self popPeak];
        return NO;
    }
    
    peak->height = height;
    peak->index = index;
    peak->prev = current;
    current = peak;
    
    return YES;
}

- (void)removePseudoPeaks:(CGFloat)height
{
    if (!current || peaks < 2 || height < current->height || current->prev->height < current->height)
        return;
    
    while (peaks > 1 && height > current->height) {
        if (current->prev->height > current->height) {
            [self popPeak];
            peaks--;
            continue;
        } else if (current->prev->height == current->height) {
            NSUInteger subPeaks = 1;
            for (struct Peak *p = current->prev; p->prev; p = p->prev) {
                subPeaks++;
                if (p->prev->height > p->height && height > p->height) {
                    while (current != p->prev)
                        [self popPeak];
                    peaks -= subPeaks;
                    break;
                }
            }
        }
        break;
    }
}

- (void)popPeak
{
    struct Peak *temp = current;
    current = current->prev;
    free(temp);
}

- (NSNumber *)calculateLakeArea
{
    if ([_heights count] < 2)
        return [NSNumber numberWithFloat:0.0f];
    
    CGFloat height = [_heights[0] floatValue];
    if (height > [_heights[1] floatValue])
        if (![self addPeakWithHeight:height index:0])
            return nil;
    
    NSUInteger last = [_heights count] - 1;
    for (NSUInteger i = 1; i < last; i++) {
        height = [_heights[i] floatValue];
        if (height > [_heights[i - 1] floatValue] && height > [_heights[i + 1] floatValue]) {
            [self removePseudoPeaks:height];
            if (![self addPeakWithHeight:height index:i])
                return nil;
        }
    }
    
    height = [[_heights lastObject] floatValue];
    if (height > [_heights[last - 1] floatValue]) {
        [self removePseudoPeaks:height];
        if (![self addPeakWithHeight:height index:last])
            return nil;
    }
    
    if (peaks < 2)
        return [NSNumber numberWithFloat:0.0f];
    
    CGFloat area = 0.0f;
    while (peaks-- > 1) {
        height = MIN(current->height, current->prev->height);
        for (NSUInteger i = current->index - 1; i > current->prev->index; i--)
            if (height >= [_heights[i] floatValue])
                area += height - [_heights[i] floatValue];
        [self popPeak];
    }
    
    return [NSNumber numberWithFloat:area];
}

@end
