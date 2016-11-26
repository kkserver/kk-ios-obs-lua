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
    
    KKObject * v = lua_toObject(L, lua_upvalueindex(1));
    
    if([v isKindOfClass:[KKObject class]]) {
        
        NSMutableArray * keys = [NSMutableArray arrayWithCapacity:4];
        
        int top = lua_gettop(L);
        
        for(int i = 0 ;i < top; i++) {
            
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
        
        lua_pushObject(L, self);
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
