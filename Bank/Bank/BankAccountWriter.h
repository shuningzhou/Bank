//
//  BankAccountWriter.h
//  Bank
//
//  Created by Peter Zhou on 7/10/13.
//  Copyright (c) 2013 Peter Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileWriter.h"
#import "BankAccount.h"

@interface BankAccountWriter : NSObject{
    FileWriter* _fileWriter;
}

-(id)initWithWriter:(FileWriter*)writer;
-(void)writeAccount:(BankAccount*)account;
-(BankAccount*)readAccount:(NSString*)name;

@end
