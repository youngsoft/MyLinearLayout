//
//  MyLayoutDelegate.h
//  MyLayout
//
//  Created by oubaiquan on 2017/9/2.
//  Copyright © 2017年 YoungSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "MyBorderline.h"

@class MyBaseLayout;

/**绘制线条层委托实现类**/
#ifdef MAC_OS_X_VERSION_10_12
@interface MyBorderlineLayerDelegate : NSObject<CALayerDelegate>
#else
@interface MyBorderlineLayerDelegate : NSObject
#endif

@property(nonatomic, strong) MyBorderline *topBorderline; /**顶部边界线*/
@property(nonatomic, strong) MyBorderline *leadingBorderline; /**头部边界线*/
@property(nonatomic, strong) MyBorderline *bottomBorderline;  /**底部边界线*/
@property(nonatomic, strong) MyBorderline *trailingBorderline;  /**尾部边界线*/
@property(nonatomic, strong) MyBorderline *leftBorderline;   /**左边边界线*/
@property(nonatomic, strong) MyBorderline *rightBorderline;   /**左边边界线*/


@property(nonatomic ,strong) CAShapeLayer *topBorderlineLayer;
@property(nonatomic ,strong) CAShapeLayer *leadingBorderlineLayer;
@property(nonatomic ,strong) CAShapeLayer *bottomBorderlineLayer;
@property(nonatomic ,strong) CAShapeLayer *trailingBorderlineLayer;


-(instancetype)initWithLayoutLayer:(CALayer*)layoutLayer;

-(void)setNeedsLayoutIn:(CGRect)rect withLayer:(CALayer*)layer;

@end




//触摸事件的委托代码基类。
@interface MyTouchEventDelegate : NSObject

@property(nonatomic, weak)  MyBaseLayout *layout;
@property(nonatomic, weak)  id target;
@property(nonatomic)  SEL action;

-(instancetype)initWithLayout:(MyBaseLayout*)layout;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

-(void)setTarget:(id)target action:(SEL)action;
-(void)setTouchDownTarget:(id)target action:(SEL)action;
-(void)setTouchCancelTarget:(id)target action:(SEL)action;


//subclass override this method
-(void)mySetTouchHighlighted;
-(void)myResetTouchHighlighted;
-(void)myResetTouchHighlighted2;
-(id)myActionSender;


@end


//布局视图的触摸委托代理。
@interface MyLayoutTouchEventDelegate : MyTouchEventDelegate

@property(nonatomic,strong)  UIColor *highlightedBackgroundColor;

@property(nonatomic,assign)  CGFloat highlightedOpacity;

@property(nonatomic,strong)  UIImage *highlightedBackgroundImage;

@end

