//
//  MyLayoutInner.h
//  MyLinearLayoutDemo
//
//  Created by apple on 15/7/10.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#ifndef MyLinearLayoutDemo_MyLayoutInner_h
#define MyLinearLayoutDemo_MyLayoutInner_h


typedef enum : unsigned char
{
    MyLayoutValueType_NULL,
    MyLayoutValueType_NSNumber,
    MyLayoutValueType_Layout,
    MyLayoutValueType_Array
}MyLayoutValueType;


//布局位置内部定义
@interface MyLayoutPos()

@property(nonatomic, weak) UIView *view;
@property(nonatomic, assign) MarignGravity pos;
@property(nonatomic, assign) CGFloat offsetVal;
@property(nonatomic, strong) id posVal;

@property(nonatomic, assign) MyLayoutValueType posValType;

@property(nonatomic, readonly) NSNumber *posNumVal;
@property(nonatomic, readonly) MyLayoutPos *posRelaVal;
@property(nonatomic, readonly) NSArray *posArrVal;

//posNumVal + offsetVal
@property(nonatomic,readonly) CGFloat margin;

@end


//布局尺寸内部定义
@interface MyLayoutDime()

@property(nonatomic, weak) UIView *view;
@property(nonatomic, assign) MarignGravity dime;
@property(nonatomic, assign) CGFloat addVal;
@property(nonatomic, assign) CGFloat mutilVal;
@property(nonatomic, strong) id dimeVal;

@property(nonatomic, assign) MyLayoutValueType dimeValType;

@property(nonatomic, readonly) NSNumber *dimeNumVal;
@property(nonatomic, readonly) NSArray *dimeArrVal;
@property(nonatomic, readonly) MyLayoutDime *dimeRelaVal;

//是否跟父视图相关
@property(nonatomic, readonly) BOOL isMatchParent;

-(BOOL)isMatchView:(UIView*)v;

//只有为数值时才有意义。
@property(nonatomic, readonly) CGFloat measure;


@end


@interface MyLayoutBase()



//派生类重载这个函数进行布局
-(CGRect)doLayoutSubviews;

//判断margin是否是相对margin
-(BOOL)isRelativeMargin:(CGFloat)margin;


-(void)calcMatchParentWidth:(MyLayoutDime*)match
                  selfWidth:(CGFloat)selfWidth
                 leftMargin:(CGFloat)leftMargin
               centerMargin:(CGFloat)centerMargin
                rightMargin:(CGFloat)rightMargin
                leftPadding:(CGFloat)leftPadding
               rightPadding:(CGFloat)rightPadding
                       rect:(CGRect*)pRect;

-(void)calcMatchParentHeight:(MyLayoutDime*)match
                  selfHeight:(CGFloat)selfHeight
                   topMargin:(CGFloat)topMargin
                centerMargin:(CGFloat)centerMargin
                bottomMargin:(CGFloat)bottomMargin
                  topPadding:(CGFloat)topPadding
               bottomPadding:(CGFloat)bottomPadding
                        rect:(CGRect*)pRect;



-(void)vertGravity:(MarignGravity)vert
        selfHeight:(CGFloat)selfHeight
         topMargin:(CGFloat)topMargin
      centerMargin:(CGFloat)centerMargin
      bottomMargin:(CGFloat)bottomMargin
              rect:(CGRect*)pRect;


-(void)horzGravity:(MarignGravity)horz
         selfWidth:(CGFloat)selfWidth
        leftMargin:(CGFloat)leftMargin
      centerMargin:(CGFloat)centerMargin
       rightMargin:(CGFloat)rightMargin
              rect:(CGRect*)pRect;





@end



//绝度位置
@interface MyAbsolutePos : NSObject

@property(nonatomic, assign) CGFloat leftPos;
@property(nonatomic, assign) CGFloat rightPos;
@property(nonatomic, assign) CGFloat topPos;
@property(nonatomic, assign) CGFloat bottomPos;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;

-(void)reset;

@property(nonatomic,assign) CGRect frame;

@end



@interface UIView(MyLayoutExtInner)

@property(nonatomic, strong) MyAbsolutePos *absPos;

@end




#endif
