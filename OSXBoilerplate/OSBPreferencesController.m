#import "OSBPreferencesController.h"

@interface OSBPreferencesController ()

#pragma mark Properties
@property (nonatomic, strong, readwrite) NSMutableDictionary *viewControllers;
@property (nonatomic, strong) NSViewController *currentViewController;
@property (nonatomic, strong) NSToolbarItem *currentToolbarItem;


#pragma mark Private
- (void)createToolbarItemsToViewControllerMapping;
- (NSViewController *)createViewControllerForToolbarItem:(NSToolbarItem *)item;
- (NSViewController *)existingViewControllerForToolbarItem:(NSToolbarItem *)item;

@end

@implementation OSBPreferencesController

#pragma mark Awaking from the Nib
- (void)awakeFromNib {
    if([super respondsToSelector:_cmd]) {
        [super awakeFromNib];
    }
    [self createToolbarItemsToViewControllerMapping];
}

#pragma mark Properties
@synthesize viewControllers, window;
@synthesize currentToolbarItem, currentViewController;

#pragma mark Actions
- (IBAction)showPreferencesFor:(id)sender {
    NSViewController *newViewController = [self existingViewControllerForToolbarItem:sender];
    if(self.currentViewController == nil) {
        CGFloat deltaHeight = NSHeight([self.window.contentView bounds]) - NSHeight(newViewController.view.frame);
        CGFloat deltaWidth = NSWidth([self.window.contentView bounds]) - NSWidth(newViewController.view.frame);
        
        NSRect newWindowFrame = self.window.frame;
        
        newWindowFrame.size.height -= deltaHeight;
        newWindowFrame.size.width -= deltaWidth;
        newWindowFrame.origin.y += deltaHeight;
        [self.window setFrame:newWindowFrame display:YES animate:YES];
        [self.window.contentView addSubview:newViewController.view];
        
        self.currentViewController = newViewController;
        return;
    }
    
    [self.currentViewController.view removeFromSuperview];
    
    CGFloat deltaHeight = NSHeight(self.currentViewController.view.frame) - NSHeight(newViewController.view.frame);
    CGFloat deltaWidth = NSWidth(self.currentViewController.view.frame) - NSWidth(newViewController.view.frame);
    
    NSRect newWindowFrame = self.window.frame;
    
    newWindowFrame.size.height -= deltaHeight;
    newWindowFrame.size.width -= deltaWidth;
    newWindowFrame.origin.y += deltaHeight;
    [self.window setFrame:newWindowFrame display:YES animate:YES];
    [self.window.contentView addSubview:newViewController.view];
    self.currentViewController = newViewController;
}

- (IBAction)showPreferencesWindow:(id)sender {
    [self.window center];
    [NSApp activateIgnoringOtherApps:TRUE]; // Make app active even if menu bar application
    [self.window makeKeyAndOrderFront:sender];
}

#pragma mark Private
- (void)createToolbarItemsToViewControllerMapping {
    self.viewControllers = [[NSMutableDictionary alloc] init];
    
    if(self.window == nil) {
        NSLog(@"A preferences controller cannot work without a window. Connect the window outlet to your preferences window.");
        return;
    }
    if(self.window.toolbar == nil) {
        NSLog(@"A preferences controller cannot work without a toolbar.");
        return;
    }
    
    // The toolbar displays tabs (toolbar items) for each pane of the preferences.
    // Here we create a view controller for each toolbar item and store a reference to it
    // in the self.viewControllers NSMutableDictionary
    NSToolbarItem *firstItem = nil;
    for(NSToolbarItem *visibleItem in self.window.toolbar.visibleItems) {
        if(!visibleItem.isEnabled || visibleItem.target != self) {
            continue;
        }
        NSViewController *controller = [self createViewControllerForToolbarItem:visibleItem];
        if(controller == nil) {
            NSLog(@"Controller for %@ is nil",visibleItem.itemIdentifier);
            continue;
        }
        if (visibleItem.itemIdentifier != nil) {
            NSLog(@"CREATED ENTRY FOR: %@", visibleItem.itemIdentifier);
            NSString *controllerName = visibleItem.itemIdentifier;
            [self.viewControllers setObject:controller forKey:controllerName];
        }
        if(firstItem == nil) {
            firstItem = visibleItem;
        }
    }
    if(firstItem != nil) {
        [self.window.toolbar setSelectedItemIdentifier:firstItem.itemIdentifier];
        [self showPreferencesFor: firstItem];
    }
}

- (NSViewController *)createViewControllerForToolbarItem:(NSToolbarItem *)item {
    if(item == nil) {
        return nil;
    }
    
    NSString *controllerIdentifier = item.itemIdentifier;
    NSMutableString *nibIdentifier = [item.itemIdentifier mutableCopy];
    if ([controllerIdentifier hasSuffix:@"Controller"]) {
        NSRange controllerRange = NSMakeRange([controllerIdentifier length]-[@"Controller" length], [@"Controller" length]);
        [nibIdentifier deleteCharactersInRange:controllerRange];
    } else {
        NSLog(@"Error: Controller Name must be of the form <nibname>Controller");
    }
    
    NSLog(@"CREATING NSVIEWCONTROLLER FOR: %@", controllerIdentifier);
    NSViewController *result = [[NSClassFromString(controllerIdentifier) alloc] initWithNibName:nibIdentifier bundle:nil];
    NSLog(@"Nibname of created NSVIEWCONTROLLER: %@",result.nibName);
    if(result == nil) {
        NSLog(@"NSVIEW CONTROLLER IS NIL!");
        return nil;
    }
    [result view];
    return result;
}

- (NSViewController *)existingViewControllerForToolbarItem:(NSToolbarItem *)item {
    NSLog(@"Getting existing controller!");
    if(item == nil) {
        NSLog(@"ITEM IS NIL");
        return nil;
    }
    
    NSString *controllerIdentifier = item.itemIdentifier;
    NSMutableString *nibIdentifier = [item.itemIdentifier mutableCopy];
    if ([controllerIdentifier hasSuffix:@"Controller"]) {
        NSRange controllerRange = NSMakeRange([controllerIdentifier length]-[@"Controller" length], [@"Controller" length]);
        [nibIdentifier deleteCharactersInRange:controllerRange];
    } else {
        NSLog(@"Error: Controller Name must be of the form <nibname>Controller");
    }
    
    if (controllerIdentifier != nil) {
        NSLog(@"THE IDENT: %@", controllerIdentifier);
        
        return [self.viewControllers objectForKey:controllerIdentifier];
    } else {
        NSLog(@"IDENT IS NIL");
        return nil;
    }
}

@end
