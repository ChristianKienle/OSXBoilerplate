//
// Copyright (c) 2011 Christian Kienle
//

#import <Cocoa/Cocoa.h>

@interface OSBPreferencesController : NSObject

#pragma mark Properties
@property (readwrite, strong, nonatomic) IBOutlet NSWindow *window;

#pragma mark Actions
- (IBAction)showPreferencesFor:(id)sender;
- (IBAction)showPreferencesWindow:(id)sender;

@end
