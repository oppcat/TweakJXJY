//
//  HookJXJY.mm
//  HookJXJY
//
//  Created by Wesley Yang on 16/4/26.
//  Copyright (c) 2016年 __MyCompanyName__. All rights reserved.
//

// CaptainHook by Ryan Petrich
// see https://github.com/rpetrich/CaptainHook/

#import <Foundation/Foundation.h>
#import "CaptainHook/CaptainHook.h"
#include <notify.h> // not required; for examples only
#import <UIKit/UIKit.h>

// Objective-C runtime hooking using CaptainHook:
//   1. declare class using CHDeclareClass()
//   2. load class using CHLoadClass() or CHLoadLateClass() in CHConstructor
//   3. hook method using CHOptimizedMethod()
//   4. register hook using CHHook() in CHConstructor
//   5. (optionally) call old method using CHSuper()


@interface HookJXJY : NSObject

@end

@implementation HookJXJY

-(id)init
{
	if ((self = [super init]))
	{
	}

    return self;
}



@end


@class VitamoPlayerView;

CHDeclareClass(VitamoPlayerView); // declare class



CHOptimizedMethod1(self, void, VitamoPlayerView, movieFinished, id, arg){
    CHSuper1(VitamoPlayerView, movieFinished,arg); // call old (original) method
    id control = [(UIView*)self performSelector:@selector(controlV)];
    [control performSelector:@selector(seekBackwardPressed:) withObject:nil afterDelay:1];
}



static void WillEnterForeground(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	// not required; for example only
}

static void ExternallyPostedNotification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	// not required; for example only
}

CHConstructor // code block that runs immediately upon load
{
	@autoreleasepool
	{
        NSLog(@"HookJXJY OK");
		// listen for local notification (not required; for example only)
		CFNotificationCenterRef center = CFNotificationCenterGetLocalCenter();
		CFNotificationCenterAddObserver(center, NULL, WillEnterForeground, CFSTR("UIApplicationWillEnterForegroundNotification"), NULL, CFNotificationSuspensionBehaviorCoalesce);
		
		// listen for system-side notification (not required; for example only)
		// this would be posted using: notify_post("com.ff.HookJXJY.eventname");
		CFNotificationCenterRef darwin = CFNotificationCenterGetDarwinNotifyCenter();
		CFNotificationCenterAddObserver(darwin, NULL, ExternallyPostedNotification, CFSTR("com.ff.HookJXJY.eventname"), NULL, CFNotificationSuspensionBehaviorCoalesce);
		

        CHLoadLateClass(VitamoPlayerView);
        
        CHHook1(VitamoPlayerView, movieFinished);
		
	}
}
