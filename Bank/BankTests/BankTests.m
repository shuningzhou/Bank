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
#import "IFileWriter.h"
#import "OCMock.h"

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
        [account.balanceLock unlock];
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
        [account.balanceLock unlock];
        return;
    }
    STFail(@"No exception was thrown");
}

-(void)testCredit_Simple_Amount_UpdatesBalance
{
    //arrange
    double beginningBalance = 49.99;
    double creditAmount = 50.01;
    double expected = 100.00;
    BankAccount *account = [[BankAccount alloc]initWithName:@"Mr.Bryan Walton" andStartingBalance:beginningBalance];
    
    //act
    [account Credit:creditAmount];
    
    //assert
    double actual = account.balance;
    STAssertEquals(expected, actual, @"Account not credited correctly");
}

-(void)testDebit_Multi_Threaded{
    //arrange
    double beginningBalance = 10;
    double debitAmount = 1;
    double expected = 0;
    BankAccount *account = [[BankAccount alloc]initWithName:@"Mr.Bryan Walton" andStartingBalance:beginningBalance];
    
    //act
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_apply(10, queue, ^(size_t i) {
        [account Debit:debitAmount];
    });
    
    // assert
    double actual = account.balance;
    STAssertEquals(expected, actual, @"Account not debited correctly");
}

-(void)testDebit_And_Credit_Multi_Threaded
{
    //arrange
    double beginningBalance = 10;
    double debitAmount = -1;
    double creditAmount = 1;
    double expected = 10;
    BankAccount *account = [[BankAccount alloc]initWithName:@"Mr.Bryan Walton" andStartingBalance:beginningBalance];
    
    //act
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_apply(10, queue, ^(size_t i) {
        [account Debit:debitAmount];
        [account Credit:creditAmount];
    });
    
    // assert
    double actual = account.balance;
    STAssertEquals(expected, actual, @"Account balance is not correct");
}

-(void)testAccount_WriteToFile_ThenRead
{
    //arrange
    double beginningBalance = 10;
    BankAccount *account = [[BankAccount alloc]initWithName:@"Mr.Bryan Walton" andStartingBalance:beginningBalance];
    
    //act
    FileWriter *writer = [[FileWriter alloc]init];
    BankAccountWriter *baw = [[BankAccountWriter alloc]initWithWriter:writer];
    [baw writeAccount:account];
    
    //assert
    BankAccount *readAccount = [baw readAccount:account.name];
    STAssertEqualObjects(readAccount.name, account.name, @"Account name does not match");
    STAssertEquals(readAccount.balance, account.balance, @"Account balance does not match");
}

-(void)testAccount_WriteToFile_ThenRead_Mocked
{
    //arrange
    double beginningBalance = 10;
    BankAccount *account = [[BankAccount alloc]initWithName:@"Mr.Bryan Walton" andStartingBalance:beginningBalance];
    
    //act
    id writer = [OCMockObject mockForProtocol:@protocol(IFileWriter)];
    [[writer expect] writeToFile:[OCMArg any] withContent:[OCMArg any]];
    NSString* readReturnString = [NSString stringWithFormat:@"%@|%f",account.name, account.balance];
    [[[writer expect] andReturn:readReturnString]read:[OCMArg any]];
    
    BankAccountWriter *baw = [[BankAccountWriter alloc]initWithWriter:writer];
     [baw writeAccount:account];
    
    //assert
    BankAccount *readAccount = [baw readAccount:account.name];
    STAssertEqualObjects(readAccount.name, account.name, @"Account name does not match");
    STAssertEquals(readAccount.balance, account.balance, @"Account balance does not match");
}

@end
