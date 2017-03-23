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
    
    int top = lua_gettop(L);
    
    NSMutableArray * keys = [NSMutableArray arrayWithCapacity:4];
    
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
    
    return 0;
}

static int KKObjectGetFunction(lua_State * L) {
    
    KKObject * v = lua_toObject(L, lua_upvalueindex(1));
    
    int top = lua_gettop(L);
    
    if(top > 0 ) {
        
        id keys = lua_toValue(L, - top);
        
        id r = nil;
        
        if([keys isKindOfClass:[NSString class]]) {
            r = [v get:[NSArray arrayWithObject:keys]];
        }
        else if([keys isKindOfClass:[NSArray class]]) {
            r = [v get:keys];
        }
        
        lua_pushValue(L, r);
        
        return 1;
    }
    
    return 0;
}

static int KKObjectStringValueFunction(lua_State * L) {
    
    KKObject * v = lua_toObject(L, lua_upvalueindex(1));
    
    int top = lua_gettop(L);
    
    if(top > 0 ) {
        
        id keys = lua_toValue(L, - top);
        
        id r = nil;
        
        if([keys isKindOfClass:[NSString class]]) {
            r = [v stringValue:[NSArray arrayWithObject:keys] :@""];
        }
        else if([keys isKindOfClass:[NSArray class]]) {
            r = [v stringValue:keys :@""];
        }
        
        lua_pushValue(L, r);
        
        return 1;
    }
    
    return 0;
}

static int KKObjectIntValueFunction(lua_State * L) {
    
    KKObject * v = lua_toObject(L, lua_upvalueindex(1));
    
    int top = lua_gettop(L);
    
    if(top > 0 ) {
        
        id keys = lua_toValue(L, - top);
        
        id r = nil;
        
        if([keys isKindOfClass:[NSString class]]) {
            r = @([v intValue:[NSArray arrayWithObject:keys] :0]);
        }
        else if([keys isKindOfClass:[NSArray class]]) {
            r = @([v intValue:keys :0]);
        }
        
        lua_pushValue(L, r);
        
        return 1;
    }
    
    return 0;
}

static int KKObjectDoubleValueFunction(lua_State * L) {
    
    KKObject * v = lua_toObject(L, lua_upvalueindex(1));
    
    int top = lua_gettop(L);
    
    if(top > 0 ) {
        
        id keys = lua_toValue(L, - top);
        
        id r = nil;
        
        if([keys isKindOfClass:[NSString class]]) {
            r = @([v doubleValue:[NSArray arrayWithObject:keys] :0]);
        }
        else if([keys isKindOfClass:[NSArray class]]) {
            r = @([v doubleValue:keys :0]);
        }
        
        lua_pushValue(L, r);
        
        return 1;
    }
    
    return 0;
}

static int KKObjectBooleanValueFunction(lua_State * L) {
    
    KKObject * v = lua_toObject(L, lua_upvalueindex(1));
    
    int top = lua_gettop(L);
    
    if(top > 0 ) {
        
        id keys = lua_toValue(L, - top);
        
        id r = nil;
        
        if([keys isKindOfClass:[NSString class]]) {
            r = @([v booleanValue:[NSArray arrayWithObject:keys] :0]);
        }
        else if([keys isKindOfClass:[NSArray class]]) {
            r = @([v booleanValue:keys :0]);
        }
        
        lua_pushValue(L, r);
        
        return 1;
    }
    
    return 0;
}

static int KKObjectSetFunction(lua_State * L) {
    
    KKObject * v = lua_toObject(L, lua_upvalueindex(1));
    
    int top = lua_gettop(L);
    
    if(top > 0) {
        
        id value = top > 1 ? lua_toValue(L, - top + 1) : nil;
        
        id keys = lua_toValue(L, - top);
        
        if([keys isKindOfClass:[NSString class]]) {
            if(value == nil) {
                [v removeWithKeys:[NSArray arrayWithObject:keys]];
            }
            else {
                [v set:[NSArray arrayWithObject:keys] :value];
            }
        }
        else if([keys isKindOfClass:[NSArray class]]) {
            if(value == nil) {
                [v removeWithKeys:keys];
            }
            else {
                [v set:keys :value];
            }
        }
        
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
    else if([key isEqualToString:@"get"]) {
        
        lua_pushObject(L, self);
        lua_pushcclosure(L, KKObjectGetFunction, 1);
        
        return 1;
    }
    else if([key isEqualToString:@"stringValue"]) {
        
        lua_pushObject(L, self);
        lua_pushcclosure(L, KKObjectStringValueFunction, 1);
        
        return 1;
    }
    else if([key isEqualToString:@"intValue"]) {
        
        lua_pushObject(L, self);
        lua_pushcclosure(L, KKObjectIntValueFunction, 1);
        
        return 1;
    }
    else if([key isEqualToString:@"booleanValue"]) {
        
        lua_pushObject(L, self);
        lua_pushcclosure(L, KKObjectBooleanValueFunction, 1);
        
        return 1;
    }
    else if([key isEqualToString:@"doubleValue"]) {
        
        lua_pushObject(L, self);
        lua_pushcclosure(L, KKObjectDoubleValueFunction, 1);
        
        return 1;
    }
    else if([key isEqualToString:@"set"]) {
        
        lua_pushObject(L, self);
        lua_pushcclosure(L, KKObjectSetFunction, 1);
        
        return 1;
    }
    else {
        return [super KKLuaObjectGet:key L:L];
    }
}

@end
