//
//  BankAccount.h
//  Bank
//
//  Created by Peter Zhou on 7/9/13.
//  Copyright (c) 2013 Peter Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *DebitAmountLessThanZeroMessage;
extern NSString *DebitAmountExceedsBalanceMessage;

@interface BankAccount : NSObject{
    NSLock* _balanceLock;
}

@property(strong)NSString *name;
@property(assign)double balance;

-(void)Debit:(double)amount;
-(void)Credit:(double)amount;
-(id)initWithName:(NSString*)name andStartingBalance:(double)startingBalance;
@end
