/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2011 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiIcloudModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation TiIcloudModule

#pragma mark Internal

-(void)storeUpdated:(NSNotification*)notification
{
    NSLog(@"[INFO] iCloud Change Detected; firing event...");
    NSDictionary *userInfo = [notification userInfo];
    NSNumber* reason = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangeReasonKey];
    NSArray* keys = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangedKeysKey];
    switch ([reason integerValue]) {
        case NSUbiquitousKeyValueStoreServerChange:
            [self fireEvent:@"externalChange" withObject:[NSDictionary dictionaryWithObject:keys forKey:@"keys"]];
            break;
        case NSUbiquitousKeyValueStoreInitialSyncChange:
            [self fireEvent:@"needsInitialSync" withObject:[NSDictionary dictionaryWithObject:keys forKey:@"keys"]];
            break;
        case NSUbiquitousKeyValueStoreQuotaViolationChange:
            [self fireEvent:@"quotaViolated" withObject:[NSDictionary dictionaryWithObject:keys forKey:@"keys"]];
            break;
        default:
            NSLog(@"[ERROR] Unknown change reason sent from iCloud: %d!", [reason intValue]);
            break;
    }
}

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"08f54473-ee58-40da-bc00-154cfdc1ac2c";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"ti.icloud";
}

#pragma mark Cleanup 

-(void)dealloc
{
	[super dealloc];
}

#pragma mark -
#pragma mark Public APIs

#pragma mark Disk Synchronization

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (!listenerAdded)
	{
		[[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(storeUpdated:)
                                                     name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                                   object:[NSUbiquitousKeyValueStore defaultStore]];
        listenerAdded = YES;
	}
}

-(id)sync:(id)args
{
    return NUMBOOL([[NSUbiquitousKeyValueStore defaultStore] synchronize]);
}

#pragma mark Data Setters

-(void)setString:(id)args
{
    ENSURE_TYPE([args objectAtIndex:0], NSString);
    ENSURE_TYPE([args objectAtIndex:1], NSString);
    
    NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
    NSString *value = [TiUtils stringValue:[args objectAtIndex:1]];
    
    [[NSUbiquitousKeyValueStore defaultStore] setString:value forKey:key];
}

-(void)setBool:(id)args
{
    ENSURE_TYPE([args objectAtIndex:0], NSString);
    ENSURE_TYPE([args objectAtIndex:1], NSNumber);
    
    NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
    bool value = [TiUtils boolValue:[args objectAtIndex:1]];
    
    [[NSUbiquitousKeyValueStore defaultStore] setBool:value forKey:key];
}

-(void)setDictonary:(id)args
{
    ENSURE_TYPE([args objectAtIndex:0], NSString);
    ENSURE_TYPE([args objectAtIndex:1], NSDictionary);
    
    NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
    NSDictionary *value = [args objectAtIndex:1];
    
    [[NSUbiquitousKeyValueStore defaultStore] setDictionary:value forKey:key];
}


-(void)setList:(id)args
{
    ENSURE_TYPE([args objectAtIndex:0], NSString);
    ENSURE_TYPE([args objectAtIndex:1], NSArray);
    
    NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
    NSArray *value = [args objectAtIndex:1];
    
    [[NSUbiquitousKeyValueStore defaultStore] setArray:value forKey:key];
}

-(void)setInt:(id)args
{
    ENSURE_TYPE([args objectAtIndex:0], NSString);
    ENSURE_TYPE([args objectAtIndex:1], NSNumber);
    
    NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
    // NOTE: We coerce the int to a double...
    double value = [TiUtils doubleValue:[args objectAtIndex:1]];
    // so that we can still store it in iCloud! (There is no "setInt" method yet.)
    [[NSUbiquitousKeyValueStore defaultStore] setDouble:value forKey:key];
}

-(void)setDouble:(id)args
{
    ENSURE_TYPE([args objectAtIndex:0], NSString);
    ENSURE_TYPE([args objectAtIndex:1], NSNumber);
    
    NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
    double value = [TiUtils doubleValue:[args objectAtIndex:1]];
    
    [[NSUbiquitousKeyValueStore defaultStore] setDouble:value forKey:key];
}

-(void)setObject:(id)args
{
    ENSURE_TYPE([args objectAtIndex:0], NSString);
    
    NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
    id value = [args objectAtIndex:1];
    
    [[NSUbiquitousKeyValueStore defaultStore] setObject:value forKey:key];
}

#pragma mark Data Getters

-(id)getString:(id)args
{
    ENSURE_TYPE([args objectAtIndex:0], NSString);
    NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
    
    return [[NSUbiquitousKeyValueStore defaultStore] stringForKey:key];
}

-(id)getBool:(id)args
{
    ENSURE_TYPE([args objectAtIndex:0], NSString);
    NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
    
    return NUMBOOL([[NSUbiquitousKeyValueStore defaultStore] boolForKey:key]);
}

-(id)getDictonary:(id)args
{
    ENSURE_TYPE([args objectAtIndex:0], NSString);
    NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
    
    return [[NSUbiquitousKeyValueStore defaultStore] dictionaryForKey:key];
}

-(id)getList:(id)args
{
    ENSURE_TYPE([args objectAtIndex:0], NSString);
    NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
    
    return [[NSUbiquitousKeyValueStore defaultStore] arrayForKey:key];
}

-(id)getInt:(id)args
{
    ENSURE_TYPE([args objectAtIndex:0], NSString);
    NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
    // NOTE: iCloud doesn't have a "intForKey" method, so we instead grab it as a double.
    return NUMINT([[NSUbiquitousKeyValueStore defaultStore] doubleForKey:key]);
}

-(id)getDouble:(id)args
{
    ENSURE_TYPE([args objectAtIndex:0], NSString);
    NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
    
    return NUMDOUBLE([[NSUbiquitousKeyValueStore defaultStore] doubleForKey:key]);
}

-(id)getObject:(id)args
{
    ENSURE_TYPE([args objectAtIndex:0], NSString);
    NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
    
    return [[NSUbiquitousKeyValueStore defaultStore] objectForKey:key];
}

-(id)getAll:(id)args
{
    return [[NSUbiquitousKeyValueStore defaultStore] dictionaryRepresentation];
}

#pragma mark Data Removers

-(void)remove:(id)args
{
    ENSURE_TYPE([args objectAtIndex:0], NSString);
    NSString *key = [TiUtils stringValue:[args objectAtIndex:0]];
    
    [[NSUbiquitousKeyValueStore defaultStore] removeObjectForKey:key];
}

@end