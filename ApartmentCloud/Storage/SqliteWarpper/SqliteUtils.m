//
//  SqliteUtils.m
//  ApartmentCloud
//
//  Created by JC_CP3 on 16/1/14.
//  Copyright © 2016年 JC_CP3. All rights reserved.
//

#import "SqliteUtils.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDataBaseAdditions.h"

#define kFilename @"apartmentMark.sqlite3"

@interface SqliteUtils ()
{
    FMDatabaseQueue *dbQueue;
}

@end

@implementation SqliteUtils

+ (SqliteUtils *)sharedInstance
{
    static SqliteUtils *sqliteUtils = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sqliteUtils = [[SqliteUtils alloc] init];
    });
    
    return sqliteUtils;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        dbQueue = [[FMDatabaseQueue alloc] initWithPath:[self dataFilePath]];
        [self createTable];
    }
    return self;
}

- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    return [documentsDirectory stringByAppendingPathComponent:kFilename];
}

- (void)createTable
{
    [dbQueue inDatabase:^(FMDatabase *db) {
        [db beginDeferredTransaction];
        
        NSArray *sqlArray = @[@"CREATE TABLE IF NOT EXISTS cityrecord"];
        
    }];
}

@end
