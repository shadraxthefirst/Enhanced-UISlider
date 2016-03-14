//
//  JSDEnhancedSlider.m
//  PickerTest
//
//  Created by Richard Stockdale on 10/03/2016.
//  Copyright © 2016 Richard Stockdale. All rights reserved.
//

#import "JSDEnhancedSlider.h"

//==============================================================================
#pragma mark - Custom UIView : Caliper location calculation

@implementation UIView (FrameUtilities)
- (void)setFrameOrigin:(CGPoint)origin {
    self.frame = CGRectMake(origin.x, origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)setFrameOriginX:(CGFloat)originX {
    self.frame = CGRectMake(originX, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)setFrameWidth:(CGFloat)width {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}
@end

//==============================================================================
#pragma mark - Popover View

@interface PSPSliderPopover : UIView

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation PSPSliderPopover

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont boldSystemFontOfSize:13];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.opaque = NO;
        
        [self addSubview:self.textLabel];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    CGFloat y = (frame.size.height - 26) / 3;
    
    if (frame.size.height < 38)
        y = 0;
    
    self.textLabel.frame = CGRectMake(0, y, frame.size.width, 26);
}

- (void)drawRect:(CGRect)rect {
    
    //// Color Declarations
    UIColor* color2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(34.31, 0.56)];
    [bezierPath addLineToPoint: CGPointMake(34.63, 0.64)];
    [bezierPath addCurveToPoint: CGPointMake(39.36, 5.37) controlPoint1: CGPointMake(36.83, 1.44) controlPoint2: CGPointMake(38.56, 3.17)];
    [bezierPath addCurveToPoint: CGPointMake(40, 12.99) controlPoint1: CGPointMake(40, 7.38) controlPoint2: CGPointMake(40, 9.25)];
    [bezierPath addLineToPoint: CGPointMake(40, 20.01)];
    [bezierPath addCurveToPoint: CGPointMake(39.44, 27.31) controlPoint1: CGPointMake(40, 23.75) controlPoint2: CGPointMake(40, 25.62)];
    [bezierPath addLineToPoint: CGPointMake(39.36, 27.63)];
    [bezierPath addCurveToPoint: CGPointMake(34.63, 32.36) controlPoint1: CGPointMake(38.56, 29.83) controlPoint2: CGPointMake(36.83, 31.56)];
    [bezierPath addCurveToPoint: CGPointMake(27.07, 33) controlPoint1: CGPointMake(32.63, 33) controlPoint2: CGPointMake(30.77, 33)];
    [bezierPath addCurveToPoint: CGPointMake(20.07, 40) controlPoint1: CGPointMake(26.33, 33.74) controlPoint2: CGPointMake(20.07, 40)];
    [bezierPath addCurveToPoint: CGPointMake(13.07, 33) controlPoint1: CGPointMake(20.07, 40) controlPoint2: CGPointMake(13.81, 33.74)];
    [bezierPath addLineToPoint: CGPointMake(12.99, 33)];
    [bezierPath addCurveToPoint: CGPointMake(5.69, 32.44) controlPoint1: CGPointMake(9.25, 33) controlPoint2: CGPointMake(7.38, 33)];
    [bezierPath addLineToPoint: CGPointMake(5.37, 32.36)];
    [bezierPath addCurveToPoint: CGPointMake(0.64, 27.63) controlPoint1: CGPointMake(3.17, 31.56) controlPoint2: CGPointMake(1.44, 29.83)];
    [bezierPath addCurveToPoint: CGPointMake(0, 20.01) controlPoint1: CGPointMake(0, 25.62) controlPoint2: CGPointMake(0, 23.75)];
    [bezierPath addLineToPoint: CGPointMake(0, 12.99)];
    [bezierPath addCurveToPoint: CGPointMake(0.56, 5.69) controlPoint1: CGPointMake(0, 9.25) controlPoint2: CGPointMake(0, 7.38)];
    [bezierPath addLineToPoint: CGPointMake(0.64, 5.37)];
    [bezierPath addCurveToPoint: CGPointMake(5.37, 0.64) controlPoint1: CGPointMake(1.44, 3.17) controlPoint2: CGPointMake(3.17, 1.44)];
    [bezierPath addCurveToPoint: CGPointMake(12.92, 0) controlPoint1: CGPointMake(7.37, 0) controlPoint2: CGPointMake(9.23, 0)];
    [bezierPath addLineToPoint: CGPointMake(12.99, 0)];
    [bezierPath addLineToPoint: CGPointMake(27.01, 0)];
    [bezierPath addCurveToPoint: CGPointMake(34.31, 0.56) controlPoint1: CGPointMake(30.75, 0) controlPoint2: CGPointMake(32.62, 0)];
    [bezierPath closePath];
    [color2 setFill];
    [bezierPath fill];
}

@end


//==============================================================================
#pragma mark - Slider implementation

@interface JSDEnhancedSlider ()


//==============================================================================
// Calipers
@property (nonatomic) UIView *leftCaliperView;
@property (nonatomic) UIView *rightCaliperView;
@property (nonatomic) UIView *leftTrackView;
@property (nonatomic) UIView *rightTrackView;
@property CGRect trackRect;

//==============================================================================
// Popover

@property (nonatomic, strong) PSPSliderPopover *popover;

- (void)showPopover;
- (void)showPopoverAnimated:(BOOL)animated;
- (void)hidePopover;
- (void)hidePopoverAnimated:(BOOL)animated;

@end


@implementation JSDEnhancedSlider

static const float kAnimationFadeInDuration = 0.2;
static const float kAnimationFadeOutDuration = 0.4;

static const float kCaliperWidth = 2.0;
static const float kCaliperHeight = 28.0;
static const float kTrackInitialWidth = 2.0;

static const float kHorizontalCaliperTrackEdgeOffset = 2.0;
static const float kVerticalCaliperEdgeOffset = 1.0;

#pragma mark - View Setup

- (void)didMoveToSuperview {
    self.trackRect = [self trackRectForBounds:self.bounds];
    self.leftCaliperView = [self createStyledCaliperView];
    self.rightCaliperView = [self createStyledCaliperView];
    self.leftTrackView = [self createStyledTrackView];
    self.rightTrackView = [self createStyledTrackView];
    self.caliperAndTrackAlpha = 0;
    
    for (UIView *view in self.caliperAndTrackViews) {
        [self.superview addSubview:view];
    }
    
    [self resetCaliperRects];
    [self performSelector:@selector(applyTrackBackgroundColors) withObject:nil afterDelay:0.0];
}

#pragma mark - Popover

- (PSPSliderPopover *)popover {
    if (_popover == nil) {
        //Default size, can be changed after
        [self addTarget:self action:@selector(updatePopoverFrame) forControlEvents:UIControlEventValueChanged];
        _popover = [[PSPSliderPopover alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y - 40, 40, 40)];
        [self updatePopoverFrame];
        _popover.alpha = 0;
        [self.superview addSubview:_popover];
    }
    
    return _popover;
}

- (void)updatePopoverFrame {
    CGFloat minimum =  self.minimumValue;
    CGFloat maximum = self.maximumValue;
    CGFloat value = self.value;
    
    if (minimum < 0.0) {
        
        value = self.value - minimum;
        maximum = maximum - minimum;
        minimum = 0.0;
    }
    
    CGFloat x = self.frame.origin.x;
    CGFloat maxMin = (maximum + minimum) / 2.0;
    
    x += (((value - minimum) / (maximum - minimum)) * self.frame.size.width) - (self.popover.frame.size.width / 2.0);
    
    if (value > maxMin) {
        
        value = (value - maxMin) + (minimum * 1.0);
        value = value / maxMin;
        value = value * 10.0;
        
        x = x - value;
        
    } else {
        
        value = (maxMin - value) + (minimum * 1.0);
        value = value / maxMin;
        value = value * 10.0;
        
        x = x + value;
    }
    
    CGRect popoverRect = self.popover.frame;
    popoverRect.origin.x = x;
    popoverRect.origin.y = self.frame.origin.y - popoverRect.size.height;
    
    self.popover.frame = popoverRect;
}

- (void)showPopover {
    [self showPopoverAnimated:NO];
}

- (void)showPopoverAnimated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.popover.alpha = 1.0;
        }];
    } else {
        self.popover.alpha = 1.0;
    }
}

- (void)hidePopover {
    [self hidePopoverAnimated:NO];
}

- (void)hidePopoverAnimated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.popover.alpha = 0;
        }];
    } else {
        self.popover.alpha = 0;
    }
}

- (void)setValue:(float)value {
    [super setValue:value];
    [self updatePopoverFrame];
    
    //self.popover.textLabel.text = [NSString stringWithFormat:@"%.00f", value];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self updatePopoverFrame];
    [self showPopoverAnimated:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hidePopoverAnimated:YES];
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hidePopoverAnimated:YES];
    [super touchesCancelled:touches withEvent:event];
}

#pragma mark - Calipers

- (UIView *)createStyledCaliperView {
    UIView *styledCaliperView = [UIView.alloc initWithFrame:CGRectMake(0, 0, kCaliperWidth, kCaliperHeight)];
    styledCaliperView.backgroundColor = UIColor.whiteColor;
    styledCaliperView.layer.shadowColor = UIColor.blackColor.CGColor;
    styledCaliperView.layer.shadowRadius = 1;
    styledCaliperView.layer.shadowOpacity = 0.5;
    styledCaliperView.layer.shadowOffset = CGSizeMake(0, 0.5);
    styledCaliperView.layer.cornerRadius = 1;
    return styledCaliperView;
}

- (UIView *)createStyledTrackView {
    UIView *styledTrackView = UIView.new;
    styledTrackView.layer.cornerRadius = 1;
    return styledTrackView;
}

- (void)setCaliperAndTrackAlpha:(CGFloat)alpha {
    for (UIView *view in self.caliperAndTrackViews) {
        view.alpha = alpha;
    }
}

- (NSArray *)caliperAndTrackViews {
    return @[self.leftTrackView, self.leftCaliperView, self.rightTrackView, self.rightCaliperView];
}

- (void)applyTrackBackgroundColors {
    UIColor *background = self.superview.backgroundColor ?: UIColor.whiteColor;
    background = [background isEqual:UIColor.clearColor] ? UIColor.whiteColor : background;
    
    self.leftTrackView.backgroundColor = [background colorWithAlphaComponent:0.75];
    self.rightTrackView.backgroundColor = [background colorWithAlphaComponent:0.75];
}

- (void)resetCaliperRects {
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    CGFloat width = self.frame.size.width;
    
    self.leftCaliperView.frameOrigin = CGPointMake(x + kHorizontalCaliperTrackEdgeOffset, y + kVerticalCaliperEdgeOffset);
    self.rightCaliperView.frameOrigin = CGPointMake(x + width - kCaliperWidth - 2, y + kVerticalCaliperEdgeOffset);
    
    self.leftTrackView.frame = CGRectMake(x + self.trackRect.origin.x, y + self.trackRect.origin.y, kTrackInitialWidth, self.trackRect.size.height);
    self.rightTrackView.frame = CGRectMake(x + width - kTrackInitialWidth - self.trackRect.origin.x, y + self.trackRect.origin.y, kTrackInitialWidth, self.trackRect.size.height);
}

#pragma mark - UIControl Touch Tracking

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self resetCaliperRects];
    [UIView animateWithDuration:kAnimationFadeInDuration animations:^{ self.caliperAndTrackAlpha = 1; }];
    return [super beginTrackingWithTouch:touch withEvent:event];
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat x = self.frame.origin.x;
    CGFloat verticalTouchDelta = fabs([touch locationInView:self].y - (height / 2.f));
    
    if (verticalTouchDelta < height * 2.f) { // normal tracking
        [UIView animateWithDuration:kAnimationFadeOutDuration animations:^{ [self resetCaliperRects]; }];
        return [super continueTrackingWithTouch:touch withEvent:event];
    }
    
    CGFloat trackingHorizontalDelta = [touch locationInView:self].x - [touch previousLocationInView:self].x;
    CGFloat valueDivisor = fabs(verticalTouchDelta / height);
    CGFloat valueRange = self.maximumValue - self.minimumValue;
    CGFloat valuePerPoint = valueRange / width;
    
    self.value += (trackingHorizontalDelta * valuePerPoint) / valueDivisor;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    CGFloat leftPercentage = (self.value - self.minimumValue) / valueRange;
    CGFloat rightPercentage = (self.maximumValue - self.value) / valueRange;
    CGFloat leftOffset = width * leftPercentage / (valueDivisor / 2.f);
    CGFloat rightOffset = width * rightPercentage / (valueDivisor / 2.f);
    
    // int values make the calipers and track align to point values, mimicing the behavior of the UISlider thumb
    self.leftCaliperView.frameOriginX = (int)(x + (width * leftPercentage) - leftOffset + 2);
    self.rightCaliperView.frameOriginX = (int)(x + width - kCaliperWidth - (width * rightPercentage) + rightOffset - 2);
    self.leftTrackView.frameWidth = (int)((width * leftPercentage) - leftOffset + 1);
    self.rightTrackView.frameWidth = (int)((width * rightPercentage) - rightOffset + 1);
    self.rightTrackView.frameOriginX = (int)(x + width - 2 - self.rightTrackView.frame.size.width);
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self finishTracking];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [self finishTracking];
}

- (void)finishTracking {
    [UIView animateWithDuration:kAnimationFadeOutDuration animations:^{
        [self resetCaliperRects];
        self.caliperAndTrackAlpha = 0;
    }];
}

- (void) sliderValueChanged: (id) sender {
    self.popover.textLabel.text = [NSString stringWithFormat:@"%.00f", self.value];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    return self;
}

@end
