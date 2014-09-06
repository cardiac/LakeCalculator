//
//  LakeCalculatorTests.m
//  LakeCalculatorTests
//
//  Created by Ryan Strug on 9/5/14.
//  Copyright (c) 2014 Ryan Strug. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LakeCalculator.h"

@interface LakeCalculatorTests : XCTestCase

@end

@implementation LakeCalculatorTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testLakeCalculator
{
    NSArray *array = @[@1.0f, @2.0f, @1.5f, @2.5f, @2.0f, @1.5f, @3.0f, @2.5f, @2.0f];
    XCTAssertEqual([[LakeCalculator calculateLakeAreaForHeights:array] floatValue], 2.0f, @"Citrix base scenario failed.");
    
    array = @[@2.0f, @1.0f, @2.0f];
    XCTAssertEqual([[LakeCalculator calculateLakeAreaForHeights:array] floatValue], 1.0f, @"Tall bookends failed.");
    
    array = @[@1.0f, @2.0f, @1.0f];
    XCTAssertEqual([[LakeCalculator calculateLakeAreaForHeights:array] floatValue], 0.0f, @"No lakes failed.");
    
    array = [NSArray array];
    XCTAssertEqual([[LakeCalculator calculateLakeAreaForHeights:array] floatValue], 0.0f, @"No values failed.");
    
    array = @[@3.0f, @1.0f, @1.5f, @4.0f, @3.0f, @2.0f, @3.0f];
    XCTAssertEqual([[LakeCalculator calculateLakeAreaForHeights:array] floatValue], 4.5f, @"Interesting peaks failed.");
    
    array = @[@3.0f, @1.0f, @1.5f, @4.0f, @3.0f, @2.0f, @3.5f];
    XCTAssertEqual([[LakeCalculator calculateLakeAreaForHeights:array] floatValue], 5.5f, @"Taller interesting peaks failed.");
    
    array = @[@0.0f, @0.0f, @0.5f, @1.5f, @1.0f, @3.0f, @1.0f, @1.5f, @4.0f, @3.0f, @2.0f, @3.5f, @0.0f, @0.5f, @0.0f];
    XCTAssertEqual([[LakeCalculator calculateLakeAreaForHeights:array] floatValue], 6.5f, @"Zero ends failed.");
    
    array = @[@-1.0f, @-2.0f, @-1.5f, @-2.5f, @-2.0f, @-1.5f, @-3.0f, @-2.5f, @-2.0f, @-7.8f];
    XCTAssertEqual([[LakeCalculator calculateLakeAreaForHeights:array] floatValue], 3.5f, @"Citrix base scenario but negative failed.");
    
    array = @[@1.0f, @-1.5f, @1.0f];
    XCTAssertEqual([[LakeCalculator calculateLakeAreaForHeights:array] floatValue], 2.5f, @"Simple negative failed.");
    
    array = @[@-1.0f, @-2.0f, @-1.0f];
    XCTAssertEqual([[LakeCalculator calculateLakeAreaForHeights:array] floatValue], 1.0f, @"Simple all negative failed.");
}

@end
