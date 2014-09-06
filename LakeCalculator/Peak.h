//
//  Peak.h
//  LakeCalculator
//
//  Created by Ryan Strug on 9/6/14.
//  Copyright (c) 2014 Ryan Strug. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Peak : NSObject

@property (nonatomic) CGFloat    height;
@property (nonatomic) NSUInteger index;

+ (Peak *)peakWithHeight:(NSNumber *)height index:(NSUInteger)index;

@end
