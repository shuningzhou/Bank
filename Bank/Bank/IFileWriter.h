//
//  IFileWriter.h
//  Bank
//
//  Created by Peter Zhou on 7/9/13.
//  Copyright (c) 2013 Peter Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IFileWriter <NSObject>

- (void)writeToFile:(NSString*)file withContent:(NSString*)contents;
- (NSString*)read:(NSString*)file;

@end
