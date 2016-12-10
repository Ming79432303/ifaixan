//
//  Single.h
//  单例模式MRC
//
//  Created by Ming on 15/9/29.
//  Copyright © 2015年 Ming. All rights reserved.
//

#define singleH(name) +(instancetype)share##name;

#if __has_feature(objc_arc)

#define singleM(name) static id _instance;\
+(instancetype)allocWithZone:(struct _NSZone *)zone\
{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance = [super allocWithZone:zone];\
    });\
    return _instance;\
}\
\
+(instancetype)share##name\
{\
    return [[self alloc]init];\
}\
-(id)copyWithZone:(NSZone *)zone\
{\
    return _instance;\
}\
\
-(id)mutableCopyWithZone:(NSZone *)zone\
{\
    return _instance;\
}


#else
#define singleM static id _instance;\
+(instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\
\
+(instancetype)shareTools\
{\
return [[self alloc]init];\
}\
-(id)copyWithZone:(NSZone *)zone\
{\
return _instance;\
}\
\
-(id)mutableCopyWithZone:(NSZone *)zone\
{\
return _instance;\
}\
-(oneway void)release\
{\
}\
\
-(instancetype)retain\
{\
    return _instance;\
}\
\
-(NSUInteger)retainCount\
{\
    return MAXFLOAT;\
}
#endif