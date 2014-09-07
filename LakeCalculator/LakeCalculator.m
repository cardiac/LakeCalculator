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
    struct Peak root, *current;
    NSUInteger peaks;
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
    if (self = [super init]) {
        peaks = 0;
    }
    return self;
}

- (void)addPeakWithHeight:(CGFloat)height index:(NSUInteger)index
{
    peaks++;
    
    struct Peak *peak = (struct Peak *)malloc(sizeof(struct Peak));
    
    peak->height = height;
    peak->index = index;
    peak->prev = current;
    current = peak;
}

- (void)removePseudoPeaks:(CGFloat)height
{
    if (peaks > 2) {
        while (current != &root) {
            if (height < current->height || current->prev->height < current->height)
                break;
            current = current->prev;
            peaks--;
        }
    }
}

- (NSNumber *)calculateLakeArea
{
    if ([_heights count] < 2)
        return [NSNumber numberWithFloat:0.0f];
    
    CGFloat height = [_heights[0] floatValue];
    if (height > [_heights[1] floatValue])
        [self addPeakWithHeight:height index:0];
    
    NSUInteger last = [_heights count] - 1;
    for (NSUInteger i = 1; i < last; i++) {
        height = [_heights[i] floatValue];
        if (height > [_heights[i - 1] floatValue] && height > [_heights[i + 1] floatValue]) {
            [self removePseudoPeaks:height];
            [self addPeakWithHeight:height index:i];;
        }
    }
    
    height = [[_heights lastObject] floatValue];
    if (height > [_heights[last - 1] floatValue]) {
        [self removePseudoPeaks:height];
        [self addPeakWithHeight:height index:last];
    }
    
    if (peaks < 2)
        return [NSNumber numberWithFloat:0.0f];
    
    CGFloat area = 0.0f;
    for (; peaks > 1; peaks--) {
        height = MIN(current->height, current->prev->height);
        for (NSUInteger j = current->index - 1; j > current->prev->index; j--) {
            if (height >= [_heights[j] floatValue]) {
                area += height - [_heights[j] floatValue];
            }
        }
        struct Peak *old = current;
        current = current->prev;
        free(old);
    }
    
    return [NSNumber numberWithFloat:area];
}

@end
