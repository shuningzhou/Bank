//
//  BankAccountWriter.m
//  Bank
//
//  Created by Peter Zhou on 7/10/13.
//  Copyright (c) 2013 Peter Zhou. All rights reserved.
//

#import "BankAccountWriter.h"

@implementation BankAccountWriter

-(id)initWithWriter:(FileWriter*)writer{
    self = [super init];
    if (self) {
        _fileWriter = writer;
    }
    return self;
}

-(void)writeAccount:(BankAccount*)account{
    NSString* content = [NSString stringWithFormat:@"%@|%f",account.name,account.balance];
    [_fileWriter writeToFile:account.name withContent:content];
}

-(BankAccount*)readAccount:(NSString*)name{
    BankAccount* account = nil;
    NSString* contents = [_fileWriter read:name];
    NSArray *both = [contents componentsSeparatedByString:@"|"];
    
    if ([both count]==2) {
        if ([[both objectAtIndex:1] doubleValue]) {
            NSString* name = [both objectAtIndex:0];
            double balance = [[both objectAtIndex:1] doubleValue];
            account = [[BankAccount alloc]initWithName:name andStartingBalance:balance];
        }
    }
    return account;
}

@end
