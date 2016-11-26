//
//  KKObject+Lua.m
//  KKObserverLua
//
//  Created by zhanghailong on 2016/11/26.
//  Copyright © 2016年 kkserver.cn. All rights reserved.
//

#import "KKObject+Lua.h"
#import <KKLua/KKLua.h>

static int KKObjectChangedKeysFunction(lua_State * L) {
    
    int top = lua_gettop(L);
    
    if(top > 0 && lua_isObject(L, -top)) {
        
        KKObject * v = lua_toObject(L, - top);
        
        NSMutableArray * keys = [NSMutableArray arrayWithCapacity:4];
        
        for(int i = 1 ;i < top; i++) {
            
            id vv = lua_toValue(L, - top + i);
            
            if([vv isKindOfClass:[NSArray class]]) {
                [keys addObjectsFromArray:vv];
            }
            else if([vv isKindOfClass:[NSString class]]) {
                [keys addObject:vv];
            }
            
        }
        
        [v changeKeys:keys];
        
    }
    
    return 0;
}

@implementation KKObject (Lua)

-(int) KKLuaObjectGet:(NSString *) key L:(lua_State *)L {
    if([key isEqualToString:@"changeKeys"]) {
        
        lua_pushcclosure(L, KKObjectChangedKeysFunction, 1);
        
        return 1;
    }
    else {
        return [super KKLuaObjectGet:key L:L];
    }
}

-(id) KKLuaObjectValueForKey:(NSString *) key {
    return [self getWithKey:key];
}

-(void) KKLuaObjectValue:(id) value forKey:(NSString *) key {
    if(value == nil) {
        [self removeWithKey:key];
    }
    else {
        [self setWithKey:key :value];
    }
}

@end
