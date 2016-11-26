//
//  KKObserver+Lua.m
//  KKObserverLua
//
//  Created by zhanghailong on 2016/11/26.
//  Copyright © 2016年 kkserver.cn. All rights reserved.
//

#import "KKObserver+Lua.h"
#import <KKLua/KKLua.h>

static int KKObserverOnFunction(lua_State * L) {
    
    KKObserver * v = lua_toObject(L, lua_upvalueindex(1));
    
    if([v isKindOfClass:[KKObserver class]]) {
        
        int top = lua_gettop(L);
        
        if(top > 1 && lua_isfunction(L, -top +1)) {
            
            id keys = lua_toValue(L, -top);
            id weakObject = top > 2 ? lua_toValue(L, -top +2) : nil;
            BOOL children = top > 3 ? lua_toValue(L, -top +3) : NO;
            
            if([keys isKindOfClass:[NSString class]]) {
                keys = [NSArray arrayWithObject:keys];
            }
            
            if([keys isKindOfClass:[NSArray class]]) {
                
                lua_pushvalue(L, -top +1);
                
                KKLuaRef * ref = [[KKLuaRef alloc] initWithL:L];
                
                [v on:keys :^(KKObserver * observer, NSArray<NSString *> * changedKeys, id weakObject) {
                    
                    lua_pushObject(ref.L, observer);
                    lua_newtable(ref.L);
                    
                    int i = 1;
                    char s[128];
                    
                    for(NSString * key in changedKeys) {
                        sprintf(s,"%d",i);
                        lua_pushstring(ref.L, s);
                        lua_pushstring(ref.L, [key UTF8String]);
                        lua_rawset(ref.L, -3);
                        i ++;
                    }
                    
                    lua_pushValue(ref.L, weakObject);
                    
                    [ref get];
                    
                    if(0 != lua_pcall(ref.L, 3, 0, 0)) {
                        NSLog(@"[KK][KKObserverLua][KKObserverOnFunction] %s",lua_tostring(ref.L, -1));
                        lua_pop(ref.L, 1);
                    }
                    
                } :weakObject :children];
                
            }
        }
    }
    
    return 0;
}

static int KKObserverOffFunction(lua_State * L) {
    
    KKObserver * v = lua_toObject(L, lua_upvalueindex(1));
    
    if([v isKindOfClass:[KKObserver class]]) {
        
        int top = lua_gettop(L);
        
        if(top > 0) {
            
            id keys = lua_toValue(L, -top);
            id weakObject = top > 1 ? lua_toValue(L, -top +1) : nil;
            
            if([keys isKindOfClass:[NSString class]]) {
                keys = [NSArray arrayWithObject:keys];
            }
            
            if([keys isKindOfClass:[NSArray class]]) {
                [v off:keys :weakObject];
            }
        }
    }
    
    return 0;
}


@implementation KKObserver (Lua)

-(int) KKLuaObjectGet:(NSString *) key L:(lua_State *)L {
    if([key isEqualToString:@"on"]) {
        
        lua_pushObject(L, self);
        lua_pushcclosure(L, KKObserverOnFunction, 1);
        
        return 1;
    }
    else if([key isEqualToString:@"off"]) {
        
        lua_pushObject(L, self);
        lua_pushcclosure(L, KKObserverOffFunction, 1);
        
        return 1;
    }
    else {
        return [super KKLuaObjectGet:key L:L];
    }
}

@end
