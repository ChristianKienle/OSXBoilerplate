#import "OSBPreferencesController.h"

@interface OSBPreferencesController ()

#pragma mark Properties
@property (nonatomic, strong, readwrite) NSArray *viewControllers;
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
   [self.window makeKeyAndOrderFront:sender];
}

#pragma mark Private
- (void)createToolbarItemsToViewControllerMapping {
   self.viewControllers = [NSArray array];
   
   if(self.window == nil) {
      NSLog(@"A preferences controller cannot work without a window. Connect the window outlet to your preferences window.");
      return;
   }
   if(self.window.toolbar == nil) {
      NSLog(@"A preferences controller cannot work without a toolbar.");
      return;
   }
   
   NSToolbarItem *firstItem = nil;
   for(NSToolbarItem *visibleItem in self.window.toolbar.visibleItems) {
      if(!visibleItem.isEnabled || visibleItem.target != self) {
         continue;
      }
      NSViewController *controller = [self createViewControllerForToolbarItem:visibleItem];
      if(controller == nil) {
         continue;
      }
      self.viewControllers = [self.viewControllers arrayByAddingObject:controller];
      if(firstItem == nil) {
         firstItem = visibleItem;
      }
   }
   if(firstItem != nil) {
      [self.window.toolbar setSelectedItemIdentifier:firstItem.itemIdentifier];
      [self showPreferencesFor:firstItem];
   }
}

- (NSViewController *)createViewControllerForToolbarItem:(NSToolbarItem *)item {
   if(item == nil) {
      return nil;
   }
   NSString *identifier = item.itemIdentifier;
   NSViewController *result = [[NSViewController alloc] initWithNibName:identifier bundle:nil];
   if(result == nil) {
      return nil;
   }
   [result view];
   return result;
}

- (NSViewController *)existingViewControllerForToolbarItem:(NSToolbarItem *)item {
   if(item == nil) {
      return nil;
   }
   NSString *identifier = item.itemIdentifier;
   for(NSViewController *viewController in self.viewControllers) {
      if([viewController.nibName isEqualToString:identifier]) {
         return viewController;
      }
   }
   return nil;
}

@end
