//
//  LakeCalculator.m
//  LakeCalculator
//
//  Created by Ryan Strug on 9/6/14.
//  Copyright (c) 2014 Ryan Strug. All rights reserved.
//

#import "LakeCalculator.h"
#import "Peak.h"

@implementation LakeCalculator

+ (NSNumber *)calculateLakeAreaForHeights:(NSArray *)heights
{
    if ([heights count] < 2)
        return [NSNumber numberWithFloat:0.0f];
    
    NSMutableArray *peaks = [NSMutableArray array];
    if ([heights[0] floatValue] > [heights[1] floatValue])
        [peaks addObject:[Peak peakWithHeight:heights[0] index:0]];
    NSUInteger last = [heights count] - 1;
    for (NSUInteger i = 1; i < last; i++) {
        CGFloat a = [heights[i - 1] floatValue], b = [heights[i] floatValue], c = [heights[i + 1] floatValue];
        if (b > a && b > c)
            [peaks addObject:[Peak peakWithHeight:heights[i] index:i]];
    }
    if ([[heights lastObject] floatValue] > [heights[last - 1] floatValue])
        [peaks addObject:[Peak peakWithHeight:[heights lastObject] index:last]];
    
    if ([peaks count] < 2)
        return [NSNumber numberWithFloat:0.0f];
    
    CGFloat area = 0.0f;
    for (NSUInteger i = 0; i < [peaks count] - 1; i++) {
        Peak *peak = peaks[i], *nextPeak = peaks[i + 1];
        
        CGFloat lakeHeight = MIN(peak.height, nextPeak.height);
        for (NSUInteger j = peak.index + 1; j < nextPeak.index; j++)
            if (lakeHeight >= [heights[j] floatValue])
                area += lakeHeight - [heights[j] floatValue];
    }
    
    return [NSNumber numberWithFloat:area];
}

@end
