#import "OSBBadgeTextFieldCell.h"

@interface OSBBadgeTextFieldCell ()

- (NSSize)badgeValueSize;
- (NSRect)badgeBackgroundRectWithResultingBounds:(NSRect)resultingBounds;
- (NSRect)badgeValueRectWithResultingBounds:(NSRect)resultingBounds;
- (NSRect)resultingBoundsWithCellFrame:(NSRect)cellFrame;

@end

@implementation OSBBadgeTextFieldCell


- (NSSize)badgeValueSize {
   return [self.attributedStringValue size];
}

- (NSRect)badgeBackgroundRectWithResultingBounds:(NSRect)resultingBounds {
   CGFloat height = NSHeight(resultingBounds);
   CGFloat radius = 0.5 * height;
 
   NSRect backgroundRect = resultingBounds;
   CGFloat delta = NSWidth(resultingBounds) - ((2.0 * radius) + [self badgeValueSize].width);
   backgroundRect.origin.x += delta;
   backgroundRect.size.width -= delta;
   return backgroundRect;
}


- (NSRect)badgeValueRectWithResultingBounds:(NSRect)resultingBounds {
   NSRect backgroundRect = [self badgeBackgroundRectWithResultingBounds:resultingBounds];
   CGFloat height = NSHeight(backgroundRect);
   CGFloat radius = 0.5 * height;
   backgroundRect.origin.x = NSMinX(backgroundRect) + radius;
   backgroundRect.size.width = [self badgeValueSize].width;
   backgroundRect.origin.y = NSMinY(backgroundRect);
   backgroundRect.origin.y += ((height - [self badgeValueSize].height) * 0.5) - 1.0;
   return backgroundRect;
}

- (NSRect)resultingBoundsWithCellFrame:(NSRect)cellFrame {
   return NSInsetRect(cellFrame, 1.0, 1.0);
}


- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
   NSRect resultingBounds = [self resultingBoundsWithCellFrame:cellFrame];
   CGFloat height = NSHeight(resultingBounds);
   CGFloat radius = 0.5 * height;
   NSBezierPath *backgroundPath = [NSBezierPath bezierPathWithRoundedRect:[self badgeBackgroundRectWithResultingBounds:resultingBounds] xRadius:radius yRadius:radius];
   
   BOOL backgroundStyleIsDark = (self.backgroundStyle == NSBackgroundStyleDark);
   if(self.backgroundStyle == NSBackgroundStyleDark) {
      [[NSColor whiteColor] set];
   }
   else {
      [[NSColor colorWithCalibratedRed:0.596 green:0.647 blue:0.702 alpha:1.000] set];
   }
   
   if(backgroundStyleIsDark) {
      [NSGraphicsContext saveGraphicsState];
      NSShadow *shadow = [[NSShadow alloc] init];
      shadow.shadowColor = [NSColor whiteColor];
      shadow.shadowOffset = NSMakeSize(0.0, -1.0);
      shadow.shadowBlurRadius = 1.0;
      [shadow set];
      [backgroundPath fill];
      [NSGraphicsContext restoreGraphicsState];
   }
   else {
      [backgroundPath fill];
   }

   [self.attributedStringValue drawInRect:[self badgeValueRectWithResultingBounds:resultingBounds]];
}

- (NSAttributedString *)attributedStringValue {
   NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithAttributedString:[super attributedStringValue]];
   [result addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:-.25] range:NSMakeRange(0, result.length)];
   [result addAttribute:NSFontAttributeName value:[NSFont boldSystemFontOfSize:11] range:NSMakeRange(0, result.length)];
   return result;
}

- (NSColor *)textColor {
   return (self.backgroundStyle == NSBackgroundStyleDark) ? [NSColor colorWithCalibratedRed:0.444 green:0.483 blue:0.529 alpha:1.000] : [NSColor whiteColor];
}

@end
