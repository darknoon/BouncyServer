//
//  AccelerationAnimation.m
//  AnimationAcceleration
//
//  Created by Matt Gallagher on 8/09/08.
//  Copyright 2008 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file without charge in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import "AccelerationAnimation.h"
#import "Evaluate.h"

@implementation AccelerationAnimation

+ (id)animationWithKeyPath:(NSString *)keyPath
	startValue:(double)startValue
	endValue:(double)endValue
	evaluationObject:(NSObject<Evaluate> *)evaluationObject
	interstitialSteps:(NSUInteger)steps
{
	id animation = [self animationWithKeyPath:keyPath];

	[animation
		calculateKeyFramesWithEvaluationObject:evaluationObject
		startValue:(double)startValue
		endValue:(double)endValue
		interstitialSteps:steps];
	
	return animation;
}

- (void)calculateKeyFramesWithEvaluationObject:(NSObject<Evaluate> *)evaluationObject
	startValue:(double)startValue
	endValue:(double)endValue
	interstitialSteps:(NSUInteger)steps
{
	NSUInteger count = steps + 2;
	
	NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:count];

	double progress = 0.0;
	double increment = 1.0 / (double)(count - 1);
	NSUInteger i;
	for (i = 0; i < count; i++)
	{
		double value = startValue + [evaluationObject evaluateAt:progress] * (endValue - startValue);
		[valueArray addObject:[NSNumber numberWithDouble:value]];
		
		progress += increment;
	}
	
	[self setValues:valueArray];
}


+ (id)animationWithKeyPath:(NSString *)keyPath
			startTransform:(CATransform3D)startValue
			  endTransform:(CATransform3D)endValue
				timeOffset:(NSTimeInterval)startOffset
		  evaluationObject:(NSObject<Evaluate> *)evaluationObject
		 interstitialSteps:(NSUInteger)steps;
{
	id animation = [self animationWithKeyPath:keyPath];
	
	[animation calculateKeyFramesWithEvaluationObject:evaluationObject
									   startTransform:startValue
										 endTransform:endValue
										   timeOffset:startOffset
									interstitialSteps:steps];
	
	return animation;
}


- (void)calculateKeyFramesWithEvaluationObject:(NSObject<Evaluate> *)evaluationObject
								startTransform:(CATransform3D)startValue
								  endTransform:(CATransform3D)endValue
									timeOffset:(NSTimeInterval)startOffset
							 interstitialSteps:(NSUInteger)steps;
{
	NSUInteger count = steps + 2;
	
	NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:count];
	
	double progress = 0.0;
	double increment = 1.0 / (double)(count - 1);
	NSUInteger i;
	for (i = 0; i < count; i++)
	{
		CGFloat k = [evaluationObject evaluateAt:startOffset + progress];
		CGFloat kk = 1.f - k;
		
		CATransform3D value;
		value.m11 = kk * startValue.m11 + k * endValue.m11;
		value.m12 = kk * startValue.m12 + k * endValue.m12;
		value.m13 = kk * startValue.m13 + k * endValue.m13;
		value.m14 = kk * startValue.m14 + k * endValue.m14;

		value.m21 = kk * startValue.m21 + k * endValue.m21;
		value.m22 = kk * startValue.m22 + k * endValue.m22;
		value.m23 = kk * startValue.m23 + k * endValue.m23;
		value.m24 = kk * startValue.m24 + k * endValue.m24;

		value.m31 = kk * startValue.m31 + k * endValue.m31;
		value.m32 = kk * startValue.m32 + k * endValue.m32;
		value.m33 = kk * startValue.m33 + k * endValue.m33;
		value.m34 = kk * startValue.m34 + k * endValue.m34;
		
		value.m41 = kk * startValue.m41 + k * endValue.m41;
		value.m42 = kk * startValue.m42 + k * endValue.m42;
		value.m43 = kk * startValue.m43 + k * endValue.m43;
		value.m44 = kk * startValue.m44 + k * endValue.m44;
		
		[valueArray addObject:[NSValue valueWithCATransform3D:value]];
		
		progress += increment;
	}
	
	[self setValues:valueArray];
}

@end
