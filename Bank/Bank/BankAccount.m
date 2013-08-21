//
//  BankAccount.m
//  Bank
//
//  Created by Peter Zhou on 7/9/13.
//  Copyright (c) 2013 Peter Zhou. All rights reserved.
//

#import "BankAccount.h"

NSString const *DebitAmountExceedsBalanceMessage = @"Debit amount exceeds balance";
NSString const *DebitAmountLessThanZeroMessage = @"Debit amount will result in a negative balance";

@implementation BankAccount

-(id)initWithName:(NSString*)name andStartingBalance:(double)startingBalance{
    self = [super init];
    if (self) {
        self.name = name;
        self.balance = startingBalance;
        self.balanceLock = [[NSLock alloc]init];
    }
    return self;
}

-(void)Debit:(double)amount{
    [self.balanceLock lock];
    double newBalance = self.balance - fabs(amount);
    if (amount > self.balance) {
        [NSException raise:@"ArgumentOutOfRangeException" format:@"%f|%@", amount, DebitAmountExceedsBalanceMessage];
    }
    if (newBalance < 0) {
        [NSException raise:@"ArgumentOutOfRangeException" format:@"%f|%@", amount, DebitAmountLessThanZeroMessage];
    }
    
    [NSThread sleepForTimeInterval:0.1f];
    self.balance = newBalance;
    [self.balanceLock unlock];
}

-(void)Credit:(double)amount{
    [self.balanceLock lock];
    [NSThread sleepForTimeInterval:0.1f];
    self.balance += fabs(amount);
    [self.balanceLock unlock];
}
@end
