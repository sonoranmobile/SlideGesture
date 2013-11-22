//
//  SMSlideGestureRecognizer.h
//  Drag
//
//  Created by Michael Morris on 11/20/13.
//  Copyright (c) 2013 Michael Morris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSlideGestureRecognizer : UIGestureRecognizer
@property (assign, nonatomic) CGFloat slideWidth;
@property (assign, nonatomic) NSInteger selectedButtonIndex;

-(id)initWithTarget:(id)target action:(SEL)action;

-(NSString*)buttonLabelForIndex:(NSInteger)index;

@end
