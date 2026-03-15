//
//  MyLayoutTraits.h
//  MyLayout
//
//  Created by oubaiquan on 2024/11/5.
//  Copyright © 2024 YoungSoft. All rights reserved.
//

#ifndef MyLayoutTraits_h
#define MyLayoutTraits_h

#import "MyLayoutDef.h"
#import "MyLayoutPos.h"
#import "MyLayoutSize.h"
#import "MyGrid.h"

@class MyBaseLayout;

@protocol MyViewTraits <NSObject>

-(id)copy;

//所有视图通用
@property (nonatomic, strong, readonly) MyLayoutPos *topPos;
@property (nonatomic, strong, readonly) MyLayoutPos *leadingPos;
@property (nonatomic, strong, readonly) MyLayoutPos *bottomPos;
@property (nonatomic, strong, readonly) MyLayoutPos *trailingPos;
@property (nonatomic, strong, readonly) MyLayoutPos *centerXPos;
@property (nonatomic, strong, readonly) MyLayoutPos *centerYPos;

@property (nonatomic, strong, readonly) MyLayoutPos *leftPos;
@property (nonatomic, strong, readonly) MyLayoutPos *rightPos;

@property (nonatomic, strong, readonly) MyLayoutPos *baselinePos;

// 上述位置对象快捷赋值属性
@property (nonatomic, assign) CGFloat myTop;
@property (nonatomic, assign) CGFloat myLeading;
@property (nonatomic, assign) CGFloat myBottom;
@property (nonatomic, assign) CGFloat myTrailing;
@property (nonatomic, assign) CGFloat myCenterX;
@property (nonatomic, assign) CGFloat myCenterY;
@property (nonatomic, assign) CGPoint myCenter;

@property (nonatomic, assign) CGFloat myLeft;
@property (nonatomic, assign) CGFloat myRight;

@property (nonatomic, assign) CGFloat myMargin;
@property (nonatomic, assign) CGFloat myHorzMargin;
@property (nonatomic, assign) CGFloat myVertMargin;

@property (nonatomic, strong, readonly) MyLayoutSize *widthSize;
@property (nonatomic, strong, readonly) MyLayoutSize *heightSize;

// 上述尺寸属性快捷赋值属性。
@property (nonatomic, assign) CGFloat myWidth;
@property (nonatomic, assign) CGFloat myHeight;
@property (nonatomic, assign) CGSize mySize;

// 已经过期的属性，不建议再使用。
@property (nonatomic, assign) BOOL wrapContentWidth;
@property (nonatomic, assign) BOOL wrapContentHeight;
@property (nonatomic, assign) BOOL wrapContentSize;

//线性布局和浮动布局和流式布局子视图专用
@property (nonatomic, assign) CGFloat weight;

@property (nonatomic, assign) BOOL useFrame;
@property (nonatomic, assign) BOOL noLayout;

@property (nonatomic, assign) MyVisibility visibility;
@property (nonatomic, assign) MyGravity alignment;


//浮动布局子视图专用
@property (nonatomic, assign, getter=isReverseFloat) BOOL reverseFloat;
@property (nonatomic, assign) BOOL clearFloat;

@end

@protocol MyLayoutTraits <MyViewTraits>

@property (nonatomic, assign) BOOL zeroPadding;

@property (nonatomic, assign) BOOL reverseLayout;
@property (nonatomic, assign) CGAffineTransform layoutTransform; //布局变换。

@property (nonatomic, assign) MyGravity gravity;

@property (nonatomic, assign) BOOL insetLandscapeFringePadding;

@property (nonatomic, assign) CGFloat paddingTop;
@property (nonatomic, assign) CGFloat paddingLeading;
@property (nonatomic, assign) CGFloat paddingBottom;
@property (nonatomic, assign) CGFloat paddingTrailing;
@property (nonatomic, assign) UIEdgeInsets padding;

@property (nonatomic, assign) CGFloat paddingLeft;
@property (nonatomic, assign) CGFloat paddingRight;

@property (nonatomic, assign) UIRectEdge insetsPaddingFromSafeArea;

@property (nonatomic, assign) CGFloat subviewVSpacing;
@property (nonatomic, assign) CGFloat subviewHSpacing;
@property (nonatomic, assign) CGFloat subviewSpacing;

@end


@protocol MySequentLayoutTraits <MyLayoutTraits>

@property (nonatomic, assign) MyOrientation orientation;

@end

@protocol MyLinearLayoutTraits <MySequentLayoutTraits>

@property (nonatomic, assign) MySubviewsShrinkType shrinkType;

@end

@protocol MyTableLayoutTraits <MyLinearLayoutTraits>

@end

@protocol MyFlowLayoutTraits <MySequentLayoutTraits>

@property (nonatomic, assign) MyGravity arrangedGravity;
@property (nonatomic, assign) BOOL autoArrange;
@property (nonatomic, assign) BOOL isFlex;
@property (nonatomic, assign) MyGravityPolicy lastlineGravityPolicy;
@property (nonatomic, assign) NSInteger maxLines;

@property (nonatomic, assign) NSInteger arrangedCount;
@property (nonatomic, assign) NSInteger pagedCount;

@end

@protocol MyFloatLayoutTraits <MySequentLayoutTraits>

@end

@protocol MyRelativeLayoutTraits <MyLayoutTraits>

@end

@protocol MyFrameLayoutTraits <MyLayoutTraits>

@end

@protocol MyPathLayoutTraits <MyLayoutTraits>

@end

@protocol MyGridLayoutTraits <MyLayoutTraits, MyGrid>

@end


#endif /* MyLayoutTraits_h */
