//
//  AppDelegate.m
//  GCDANR
//
//  Created by Adam Kaplan on 3/13/17.
//  Copyright © 2017 Adam Kaplan. All rights reserved.
//

#import "AppDelegate.h"
#import <mach/mach_time.h>

@interface AppDelegate ()
@property (nonatomic, nonnull) dispatch_source_t mainThreadSource;
@property (nonatomic, nonnull) dispatch_source_t threadMonitorTimer;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // This is the block triggered if the main thread didn't respond in time
    void(^onMainThreadDidNotRespond)(void) = ^(void) {
        NSLog(@"Main thread DID NOT respond");
    };
    
    __block BOOL mainThreadTriggered = NO;
    
    // Install signal handler on the main thread
    _mainThreadSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_OR, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_event_handler(_mainThreadSource, ^{
        mainThreadTriggered = YES;
        
        NSLog(@"%d", rand() % 1000); // easier to see demo when log messages don't look the same
    });
    
    _threadMonitorTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,
                                                 dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0));
    dispatch_source_set_timer(_threadMonitorTimer,
                              dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC),
                              1.0 * NSEC_PER_SEC,
                              0.5 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_threadMonitorTimer, ^{
        
        if (mainThreadTriggered) {          // Main thread responded, great!
            mainThreadTriggered = NO;       // Reset flag.
            NSLog(@"Main thread did respond");
        } else {
            onMainThreadDidNotRespond();    // Main thread did not respond, invoke handler
        }
        
        // Trigger main thread source. If the previous signal was not yet handled, this one
        // will coelesce with it. They will never stack up.
        dispatch_source_merge_data(_mainThreadSource, 1);
    });
    
    // Set initial call
    dispatch_source_set_registration_handler(_threadMonitorTimer, ^{
        dispatch_source_merge_data(_mainThreadSource, 1);
    });
    
    // Start it up
    dispatch_resume(_mainThreadSource);
    dispatch_resume(_threadMonitorTimer);
    
    return YES;
}

@end
