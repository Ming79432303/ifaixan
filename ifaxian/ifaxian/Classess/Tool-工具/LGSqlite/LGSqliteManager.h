//
//  LGSqliteManager.h
//  FMDB工具类的封装
//
//  Created by ming on 17/2/15.
//  Copyright © 2017年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Single.h"
@interface LGSqliteManager : NSObject
singleH(Sqlite)
- (void)createTable;
- (NSArray *)loadDataDbNmae:(NSString *)name limit:(NSInteger)limit curentCount:(NSInteger)count;
- (void)updateDataTableName:(NSString *)tbName dataArray:(NSArray *)dataArray;
@end
