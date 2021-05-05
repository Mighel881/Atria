//
// Created by ren7995 on 2021-04-25 12:49:45
// Copyright (c) 2021 ren7995. All rights reserved.
//

#import "Hooks/Shared.h"
#import "src/ARITweak.h"

%hook SBDockView

// Override background alpha
- (void)setBackgroundAlpha:(CGFloat)alpha
{
    %orig([[ARITweak sharedInstance] floatValueForKey:@"dock_bg"]);
}

- (void)traitCollectionDidChange:(UITraitCollection *)old
{
    %orig(old);
    // Call the setter to force the background alpha to reset
    // This fixes the dock becoming full alpha after changing dark/light mode
    // Don't ask me how, but calling -setBackgroundAlpha: directly wasn't working,
    // but this does, even with 0.0 delay. What works works I guess
    [self performSelector:@selector(setBackgroundAlpha:) withObject:@(1.0f) afterDelay:0.0];
}

%end

%ctor
{
	if([ARITweak sharedInstance].enabled)
	{
		NSLog(@"Atria loading hooks from %s", __FILE__);
		%init();
	}
}
