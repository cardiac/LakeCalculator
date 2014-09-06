//
//  Peak.m
//  LakeCalculator
//
//  Created by Ryan Strug on 9/6/14.
//  Copyright (c) 2014 Ryan Strug. All rights reserved.
//

#import "Peak.h"

@implementation Peak

+ (Peak *)peakWithHeight:(NSNumber *)height index:(NSUInteger)index
{
    Peak *peak = [[Peak alloc] init];
    peak.height = [height floatValue];
    peak.index = index;
    return peak;
}

@end
