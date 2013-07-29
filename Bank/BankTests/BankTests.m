//
//  BankTests.m
//  BankTests
//
//  Created by Peter Zhou on 7/9/13.
//  Copyright (c) 2013 Peter Zhou. All rights reserved.
//

#import "BankTests.h"
#import "BankAccount.h"
#import "BankAccountWriter.h"
#import "FileWriter.h"

@implementation BankTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testDebit_WithValidAmount_UpdatesBalance
{
    // arrange
    double beginningBalance = 100.00;
    double debitAmount = 50.00;
    double expected = 50.00;
    BankAccount* account = [[BankAccount alloc]initWithName:@"Mr. Bryan Walton" andStartingBalance:beginningBalance];
    
    // act
    [account Debit:debitAmount];
    
    // assert
    double actual = account.balance;
    STAssertEquals(expected, actual, @"Account not debited correctly");
}

-(void)testDebit_WhenAmountIsLessThanZero_ShouldThrowArgumentOutOfRange
{
    // arrange
    double beginningBalance = 100.00;
    double debitAmount = -200.00;
    BankAccount* account = [[BankAccount alloc]initWithName:@"Mr. Bryan Walton" andStartingBalance:beginningBalance];
    
    // act
    @try {
        [account Debit:debitAmount];
    }
    @catch (NSException *exception) {
        NSString* reason = exception.reason;
        NSArray *words = [reason componentsSeparatedByString:@"|"];
        NSString* lastComponent = [words lastObject];
        // assert
        STAssertEqualObjects(lastComponent, DebitAmountLessThanZeroMessage, @"Did not get the correct exception");
        return;
    }
    STFail(@"No exception was thrown");
}


-(void)testDebit_WhenAmountIsGreaterThanBalance_ShouldThrowArgumentOutOfRange
{
    // arrange
    double beginningBalance = 100.00;
    double debitAmount = 200.00;
    BankAccount* account = [[BankAccount alloc]initWithName:@"Mr. Bryan Walton" andStartingBalance:beginningBalance];
    
    // act
    @try {
        [account Debit:debitAmount];
    }
    @catch (NSException *exception) {
        NSString* reason = exception.reason;
        NSArray *words = [reason componentsSeparatedByString:@"|"];
        NSString* lastComponent = [words lastObject];
        // assert
        STAssertEqualObjects(lastComponent, DebitAmountExceedsBalanceMessage, @"Did not get the correct exception");
        return;
    }
    STFail(@"No exception was thrown");
}


@end
