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
    }
    return self;
}

-(void)Debit:(double)amount{
    [_balanceLock lock];
    double newBalance = self.balance - fabs(amount);
    if (amount > self.balance) {
        [NSException raise:@"ArgumentOutOfRangeException" format:@"Amount = %f. %@", amount, DebitAmountExceedsBalanceMessage];
    }
    if (newBalance < 0) {
        [NSException raise:@"ArgumentOutOfRangeException" format:@"Amount = %f. %@", amount, DebitAmountLessThanZeroMessage];
    }
    [NSThread sleepForTimeInterval:0.1f];
    [_balanceLock unlock];
}

-(void)Credit:(double)amount{
    [_balanceLock lock];
    [NSThread sleepForTimeInterval:0.01f];
    self.balance += fabs(amount);
    [_balanceLock unlock];
}
@end
