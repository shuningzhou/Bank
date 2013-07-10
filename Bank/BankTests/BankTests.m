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

- (void)Debit_WithValidAmount_UpdatesBalance{
    // arrange
    double beginningBalance = 11.99;
    double debitAmount = 4.55;
    double expected = 7.44;
    BankAccount* account = [[BankAccount alloc]initWithName:@"Mr. Bryan Walton" andStartingBalance:beginningBalance];
    
    // act
    [account Debit:debitAmount];
    
    // assert
    double actual = account.balance;
    STAssertEquals(expected, actual, @"Account not debited correctly");
}


@end
