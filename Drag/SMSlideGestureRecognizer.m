//
//  SMSlideGestureRecognizer.m
//  Drag
//
//  Created by Michael Morris on 11/20/13.
//  Copyright (c) 2013 Michael Morris. All rights reserved.
//

#import "SMSlideGestureRecognizer.h"
#import "UIKit/UIGestureRecognizerSubclass.h"

typedef NS_ENUM(NSInteger, SMSlideState) {
	SMSlideClosedState,
	SMSlideOpeningState,
	SMSlideOpenState,
	SMSlideClosingState,
	SMSlideInvalidState
};

typedef NS_ENUM(NSInteger, SMSlideMoveDirection){
	SMSlideMoveLeft,
	SMSlideMoveRight,
	SMSlideMoveNone
};


@interface SMSlideGestureRecognizer ()
@property (assign, nonatomic) CGPoint lastTouchPoint;
//@property (assign, nonatomic) CGFloat maxX;
//@property (assign, nonatomic) CGFloat minX;
@property (weak, nonatomic) UIView* buttonView;
@property (strong, nonatomic) NSArray* buttons;
@property (assign, nonatomic) SMSlideState slideState;

@property (strong, nonatomic) NSMutableDictionary* origins;
@end


@implementation SMSlideGestureRecognizer

-(id)initWithTarget:(id)target action:(SEL)action {
	self = [super initWithTarget:target action:action];
	if(self) {
		_slideWidth = 120.0;
		_slideState = SMSlideClosedState;
		_selectedButtonIndex = NSNotFound;
		_origins = [NSMutableDictionary dictionary];
	}
	
	return self;
}


-(void)reset {
	_slideState = SMSlideClosedState;
	_selectedButtonIndex = NSNotFound;
}

-(void)addButtonsViewToSuperview:(UIView*)parent {
	CGRect buttonFrame = CGRectMake(parent.bounds.size.width, 0.0, _slideWidth, parent.bounds.size.height);
	UIView* view = [[UIView alloc] initWithFrame:buttonFrame];
	
	[parent addSubview:view];
	
	UIButton* deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	UIButton* moreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	buttonFrame = CGRectMake(0.0, 0.0, _slideWidth / 2.0, parent.bounds.size.height);
	moreButton.frame = buttonFrame;
	UIColor* backgroundColor = [UIColor lightGrayColor];
	UIColor* textColor = [UIColor whiteColor];
	moreButton.backgroundColor = backgroundColor;
	[moreButton setTitleColor:textColor forState:UIControlStateNormal];
	[moreButton setTitle:@"More" forState:UIControlStateNormal];
	
	buttonFrame = CGRectMake(_slideWidth / 2.0, 0.0, _slideWidth / 2.0, parent.bounds.size.height);
	backgroundColor = [UIColor redColor];
	deleteButton.frame = buttonFrame;
	deleteButton.backgroundColor = backgroundColor;
	[deleteButton setTitleColor:textColor forState:UIControlStateNormal];
	[deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
	
	[view addSubview:moreButton];
	[view addSubview:deleteButton];
	_buttonView = view;
	_buttons = @[deleteButton, moreButton];
}

-(void)awakeFromNib {
	if(_slideWidth < 60.0)
		_slideWidth = 160.0;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if(!_buttonView)
		[self addButtonsViewToSuperview:self.view];
	
	[self.view bringSubviewToFront:_buttonView];
	UITouch* touch = [[event allTouches] anyObject];
	_lastTouchPoint = [touch locationInView:self.view];
	
	switch(_slideState) {
		case SMSlideClosedState:
//			_maxX = _lastTouchPoint.x;
//			_minX = _lastTouchPoint.x - _slideWidth;
			break;
			
		case SMSlideOpeningState:
		case SMSlideClosingState:
			// If it gets here the user has touched a location where a button will be
			// before the open animation is complete, so ignore the touch
			break;
			
		case SMSlideOpenState:
//			_minX = _lastTouchPoint.x;
//			_maxX = _lastTouchPoint.x + _slideWidth;
			break;
			
			
		case SMSlideInvalidState:
			self.state = UIGestureRecognizerStateFailed;
			break;
			
	};
	
	return;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* touch = [[event allTouches] anyObject];
	CGPoint newPosition = [touch locationInView:self.view];
	CGFloat deltaX = 0.0;
	UIGestureRecognizerState nextState = self.state;
	SMSlideMoveDirection direction = [self moveDirection:newPosition.x];
	NSLog(@"touchesMoved:withEvent:");
	
	
	switch(_slideState) {
		case SMSlideClosedState:
			NSLog(@"touchesMoved:withEvent: SMSlideClosedState");
			if(direction == SMSlideMoveRight) {
				nextState = UIGestureRecognizerStateCancelled;
			} else {
				nextState = UIGestureRecognizerStateBegan;
				_buttonView.hidden = NO;
				[self saveOrigins];
				[self.view bringSubviewToFront:_buttonView];
				_slideState = SMSlideOpeningState;
				deltaX = newPosition.x - _lastTouchPoint.x;
				[self doSlideWithDeltaX:deltaX];
			}
			break;
			
		case SMSlideOpeningState:
			NSLog(@"touchesMoved:withEvent: SMSlideOpeningState");
			nextState = UIGestureRecognizerStateChanged;
			if(direction == SMSlideMoveLeft) {
				deltaX = newPosition.x - _lastTouchPoint.x;
				_lastTouchPoint = newPosition;
				[self doSlideWithDeltaX:deltaX];
			}
			break;
			
		case SMSlideOpenState:
			NSLog(@"touchesMoved:withEvent: SMSlideOpeningState");
			if(direction == SMSlideMoveRight) {
				[self closeSlider];
			}
			break;
			
		case SMSlideClosingState:
			break;
			
		case SMSlideInvalidState:
			break;
			
	};
	
	if(nextState != self.state)
		self.state = nextState;
	return;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* touch = [[event allTouches] anyObject];
	CGPoint newPosition = [touch locationInView:self.view];
	UIGestureRecognizerState nextState = self.state;
	UIView* touchedView = nil;
	
	switch(_slideState) {
		case SMSlideClosedState:
			[self closeSlider];
			nextState = UIGestureRecognizerStateCancelled;
			break;
			
		case SMSlideOpeningState:
			if([self openPercent] >= 0.5) {
				[self openSlider];
				nextState = UIGestureRecognizerStateChanged;
			} else {
				[self closeSlider];
				nextState = UIGestureRecognizerStateCancelled;
			}
			break;
			
		case SMSlideOpenState:
			// do nothing here, this should never be seen
			touchedView = [self.view hitTest:newPosition withEvent:event];
			_selectedButtonIndex = [_buttons indexOfObject:touchedView];
			if(_selectedButtonIndex != NSNotFound) {
				nextState = UIGestureRecognizerStateEnded;
			} else {
				nextState = UIGestureRecognizerStateCancelled;
			}
			[self closeSlider];
				
			break;

		case SMSlideClosingState:
			nextState = UIGestureRecognizerStateCancelled;
			break;
			
		case SMSlideInvalidState:
			[self closeSlider];
			nextState = UIGestureRecognizerStateFailed;
			break;
			
	};
	
	if(nextState != self.state)
		self.state = nextState;
	return;
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[self closeSlider];
	self.state = UIGestureRecognizerStateFailed;
}

-(SMSlideMoveDirection)moveDirection:(CGFloat)currentX {
	SMSlideMoveDirection direction = SMSlideMoveNone;
	if(currentX < _lastTouchPoint.x) {
		direction = SMSlideMoveLeft;
	} else if(currentX > _lastTouchPoint.x) {
		direction = SMSlideMoveRight;
	}
	
	return direction;
}



-(CGFloat)openPercent {
	CGFloat openedX = self.view.frame.size.width -  _buttonView.frame.origin.x;
	CGFloat value = openedX / _slideWidth;
	NSLog(@"openPercent openedX %lf  value %lf", openedX, value);
	return value;
}

-(void)doSlideWithDeltaX:(CGFloat)deltaX {
	if(deltaX >= 1.0 || deltaX < -1.0) {
		NSLog(@"doSlideWithDeltaX:%lf", deltaX);
		__weak SMSlideGestureRecognizer* weakSelf = self;
		[UIView animateWithDuration:0.1
						 animations:^{
							 __strong SMSlideGestureRecognizer* strongSelf = weakSelf;
							 UIView* view = nil;
							 for(view in strongSelf.view.subviews) {
								 CGPoint newCenter = view.center;
								 newCenter.x += deltaX;
								 view.center = newCenter;
							 }
						 }];
	}
}

-(void)openSlider {
	CGFloat currentButtonX = _buttonView.frame.origin.x;
	CGFloat slideGoalX = self.view.frame.size.width - _slideWidth;
	CGFloat deltaX = slideGoalX - currentButtonX;
	CGFloat bounceDelta = (deltaX < 0.0) ? -10.0:10.0;
	
	if(deltaX != 0.0) {
		NSLog(@"openSlider");
		__weak SMSlideGestureRecognizer* weakSelf = self;
		[UIView animateWithDuration:0.25
						 animations:^{
							 __strong SMSlideGestureRecognizer* strongSelf = weakSelf;
							 UIView* view = nil;
							 for(view in strongSelf.view.subviews) {
								 CGPoint newCenter = view.center;
								 newCenter.x += (deltaX + bounceDelta);
								 view.center = newCenter;
							 }
						 }
						 completion:^(BOOL finished) {
							 __strong SMSlideGestureRecognizer* strongSelf = weakSelf;
							 [UIView animateWithDuration:0.05 animations:^{
								 UIView* view = nil;
								 for(view in strongSelf.view.subviews) {
									 CGPoint newCenter = view.center;
									 newCenter.x += -(bounceDelta);
									 view.center = newCenter;
								 }
								 
							 }
											  completion:^(BOOL finished){
												  __strong SMSlideGestureRecognizer* strongSelf = weakSelf;
												  strongSelf.slideState = SMSlideOpenState;
											  }];
						 }];
	}
}




-(void)closeSlider {
	CGFloat openedX = _buttonView.frame.origin.x;
	CGFloat deltaX = self.view.frame.size.width - openedX;
	
	if(deltaX != 0.0) {
		NSLog(@"closeSlider deltaX %lf", deltaX);
		__weak SMSlideGestureRecognizer* weakSelf = self;
		[UIView animateWithDuration:0.25
						 animations:^{
							 __strong SMSlideGestureRecognizer* strongSelf = weakSelf;
							 
							 for(NSValue* key in [strongSelf.origins allKeys]) {
								 UIView* view = [key nonretainedObjectValue];
								 NSValue* value = strongSelf.origins[key];
								 CGPoint point = [value CGPointValue];
								 point.x += 10.0;
								 view.center = point;
							 }
							 
							 [strongSelf.origins removeAllObjects];
							 /*
							 UIView* view = nil;
							 for(view in strongSelf.view.subviews) {
								 CGPoint newCenter = view.center;
								 newCenter.x += (deltaX + 10.0);
								 view.center = newCenter;
							 }*/
						 }
						 completion:^(BOOL finished) {
							 __strong SMSlideGestureRecognizer* strongSelf = weakSelf;
							 [UIView animateWithDuration:0.05 animations:^{
								 UIView* view = nil;
								 for(view in strongSelf.view.subviews) {
									 CGPoint newCenter = view.center;
									 newCenter.x -= 10.0;
									 view.center = newCenter;
								 }
								 
								 [strongSelf.view sendSubviewToBack:_buttonView];
								 strongSelf.buttonView.hidden = YES;
								 
							 }completion:^(BOOL finished){
								 __strong SMSlideGestureRecognizer* strongSelf = weakSelf;
								 strongSelf.slideState = SMSlideClosedState;
							 }];
						 }];
	}
	_slideState = SMSlideClosedState;
}

-(NSString*)buttonLabelForIndex:(NSInteger)index {
	NSString* label = @"Invalid Index";
	if(index >= 0 && index < _buttons.count) {
		UIButton* button = _buttons[index];
		label = [button titleForState:UIControlStateNormal];
	}
	
	return label;
}

-(void)saveOrigins {
	UIView* view = nil;
	for(view in self.view.subviews) {
		[_origins setObject:[NSValue valueWithCGPoint:view.center] forKey:[NSValue valueWithNonretainedObject:view]];
	}
}

@end
