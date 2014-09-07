//
//  LakeCalculator.h
//  LakeCalculator
//
//  Created by Ryan Strug on 9/6/14.
//  Copyright (c) 2014 Ryan Strug. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LakeCalculator : NSObject

@property (strong, nonatomic) NSArray *heights;

+ (NSNumber *)calculateLakeAreaForHeights:(NSArray *)heights;

@end
