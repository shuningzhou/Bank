//
//  FileWriter.m
//  Bank
//
//  Created by Peter Zhou on 7/9/13.
//  Copyright (c) 2013 Peter Zhou. All rights reserved.
//

#import "FileWriter.h"

@implementation FileWriter

- (void)writeToFile:(NSString*)file withContent:(NSString*)contents{
    NSString* filePath = [NSString stringWithFormat:@"Documents/%@",file];
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:filePath];
    [contents writeToFile:docPath
               atomically:YES
                 encoding:NSUTF8StringEncoding
                    error:nil];
}

- (NSString*)read:(NSString*)file{
    NSString* filePath = [NSString stringWithFormat:@"Documents/%@",file];
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:filePath];
    NSString *dataFile = [NSString stringWithContentsOfFile:docPath encoding:NSUTF8StringEncoding error:nil];
    return dataFile;
}

@end
