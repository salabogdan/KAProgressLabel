//
//  Test.m
//  
//
//  Created by Bogdan Sala on 27.04.2021.
//

#import <XCTest/XCTest.h>
#import <KAProgress/KAProgress.h>

@interface Test : XCTestCase

@end

@implementation Test

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    KAProgressLabel *label  = [KAProgressLabel new];
    label.borderColor = [UIColor blueColor];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
