//
//  GKDBManager.m
//  GankIO
//
//  Created by Josscii on 16/9/3.
//  Copyright © 2016年 Josscii. All rights reserved.
//

#import "GKDBManager.h"
#import "FMDB/FMDB.h"
#import "RealStuff.h"

#define ERROR_DOMAIN @"com.gank.io"
#define EXPIRE_TIME 60 * 60 * 24

typedef NS_ENUM(NSUInteger, GKError) {
    GKOpenDBError,
    GKNoDataError,
    GKExcuteUpdateError,
    GKDataExpiredError
};

@interface GKDBManager ()

@property (nonatomic, strong) FMDatabase *database;

@end

@implementation GKDBManager

+ (instancetype)defaultManager {
    static GKDBManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GKDBManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingString:@"/realstuff.db"];
        _database = [FMDatabase databaseWithPath:path];
        
        if ([_database open]) {
            [_database executeUpdate:@"PRAGMA foreign_keys=YES"];
            
            NSString *historySQL = @"create table if not exists history(id integer primary key autoincrement, day text, updatetime real)";
            [_database executeUpdate:historySQL];
            
            NSString *realstuffSQL = @"create table if not exists realstuff(id integer primary key autoincrement, desc text, type text, url text, who text, day text, foreign key (day) references history(day))";
            [_database executeUpdate:realstuffSQL];
            
            [_database close];
        }
    }
    
    return self;
}

- (RACSignal *)saveHistory:(NSString *)day {
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        if ([self.database open]) {
            NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
            BOOL ok = NO;
            
            FMResultSet *s = [self.database executeQuery:@"select * from history where day = (?)", day];
            if ([s next]) {
                ok = [self.database executeUpdate:@"UPDATE history SET updatetime = (?) WHERE day = (?)", @(now), day];
            } else {
                ok = [self.database executeUpdate:@"INSERT INTO history (day, updatetime) values (?, ?)", day, @(now)];
            }
            
            if (ok) {
                [subscriber sendNext:day];
                [subscriber sendCompleted];
            } else {
                NSError *error = [NSError errorWithDomain:ERROR_DOMAIN code:GKExcuteUpdateError userInfo:@{@"desc": @"Error on updating db"}];
                [subscriber sendError:error];
            }
            [self.database close];
        }
        
        return nil;
    }];
}

- (RACSignal *)fetchHistory {
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        if ([self.database open]) {
            NSMutableArray *history = [NSMutableArray array];
            FMResultSet *s = [self.database executeQuery:@"select * from history"];
            while ([s next]) {
                NSString *day = [s objectForColumnName:@"day"];
                NSDate *lastUpdateTime = [NSDate dateWithTimeIntervalSince1970:[s doubleForColumn:@"updatetime"]];
                NSDate *now = [NSDate date];
                if ([now timeIntervalSinceDate:lastUpdateTime] > EXPIRE_TIME) {
                    NSError *error = [NSError errorWithDomain:ERROR_DOMAIN code:GKNoDataError userInfo:@{@"desc": @"Data Expired"}];
                    [subscriber sendError:error];
                    [self.database close];
                    return nil;
                }
                
                [history addObject:day];
            }
            if (history.count != 0) {
                [subscriber sendNext:[history copy]];
                [subscriber sendCompleted];
            } else {
                NSError *error = [NSError errorWithDomain:ERROR_DOMAIN code:GKNoDataError userInfo:@{@"desc": @"No Data Found"}];
                [subscriber sendError:error];
            }
            [self.database close];
        }
        return nil;
    }];
}

- (RACSignal *)saveRealStuffs:(NSArray *)realStuffs ofDay:(NSString *)day {
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        if ([self.database open]) {
            [realStuffs enumerateObjectsUsingBlock:^(RealStuff * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.database executeUpdate:@"INSERT INTO realstuff (desc, type, url, who, day) VALUES (?, ?, ?, ?, ?)", obj.desc, obj.type, obj.url, obj.who, day];
            }];
            [subscriber sendNext:day];
            [subscriber sendCompleted];
            [self.database close];
        }
        return nil;
    }];
}

- (RACSignal *)fetchRealStuffsOfDay:(NSString *)day {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        NSMutableArray *realStuffs = [NSMutableArray array];
        if ([self.database open]) {
            FMResultSet *s = [self.database executeQuery:@"SELECT * FROM realstuff where day = ?", day];
            while ([s next]) {
                NSString *desc = [s objectForColumnName:@"desc"];
                NSString *type = [s objectForColumnName:@"type"];
                NSString *url = [s objectForColumnName:@"url"];
                NSString *who = [s objectForColumnName:@"who"];
                RealStuff *realStuff = [[RealStuff alloc] initWithDesc:desc type:type url:url who:who];
                [realStuffs addObject:realStuff];
            }
            [self.database close];
        }
        if (realStuffs.count != 0) {
            [subscriber sendNext:realStuffs];
            [subscriber sendCompleted];
        } else {
            NSError *error = [NSError errorWithDomain:ERROR_DOMAIN code:GKNoDataError userInfo:@{@"desc": @"No Data Found"}];
            [subscriber sendError:error];
        }
        return nil;
    }];
}

@end
