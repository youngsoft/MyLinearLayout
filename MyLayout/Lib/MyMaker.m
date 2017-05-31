//
//  MyMaker.m
//  MyLayout
//
//  Created by oybq on 15/7/5.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyMaker.h"

#if TARGET_OS_IPHONE

#import "MyLayoutPos.h"
#import "MyLayoutSize.h"
#import "MyLayoutPosInner.h"
#import "MyLayoutSizeInner.h"

@implementation MyMaker
{
    NSArray *_myViews;
    NSMutableArray *_keys;
    BOOL  _clear;
}

-(id)initWithView:(NSArray *)v
{
    self = [self init];
    if (self != nil)
    {
        _myViews = v;
        _keys = [[NSMutableArray alloc] init];
        _clear = NO;
    }
    
    return self;
}

-(MyMaker*)addMethod:(NSString*)method
{
    if (_clear)
        [_keys removeAllObjects];
    _clear = NO;
    
    [_keys addObject:method];
    return self;
}



-(MyMaker*)top
{
    return [self addMethod:@"topPos"];
}

-(MyMaker*)left
{
    return [self addMethod:@"leftPos"];
}

-(MyMaker*)bottom
{
    return [self addMethod:@"bottomPos"];
}

-(MyMaker*)right
{
    return [self addMethod:@"rightPos"];
}

-(MyMaker*)margin
{
    [self top];
    [self left];
    [self right];
   return [self bottom];
}

-(MyMaker*)leading
{
    return [self addMethod:@"leadingPos"];

}

-(MyMaker*)trailing
{
    return [self addMethod:@"trailingPos"];

}


-(MyMaker*)height
{
    return [self addMethod:@"heightSize"];
}

-(MyMaker*)width
{
    return [self addMethod:@"widthSize"];
}

-(MyMaker*)useFrame
{
    return [self addMethod:@"useFrame"];
}

-(MyMaker*)noLayout
{
    return [self addMethod:@"noLayout"];

}


-(MyMaker*)wrapContentHeight
{
    return [self addMethod:@"wrapContentHeight"];
}

-(MyMaker*)wrapContentWidth
{
    return [self addMethod:@"wrapContentWidth"];
}

-(MyMaker*)reverseLayout
{
    return [self addMethod:@"reverseLayout"];
}



-(MyMaker*)weight
{
    return [self addMethod:@"weight"];
    
}

-(MyMaker*)reverseFloat
{
    return [self addMethod:@"reverseFloat"];
}

-(MyMaker*)clearFloat
{
    return [self addMethod:@"clearFloat"];
}

-(MyMaker*)noBoundaryLimit
{
    return [self addMethod:@"noBoundaryLimit"];
}

-(MyMaker*)topPadding
{
    
    return [self addMethod:@"topPadding"];
    
}

-(MyMaker*)leftPadding
{
    return [self addMethod:@"leftPadding"];
    
}

-(MyMaker*)bottomPadding
{
    
    return [self addMethod:@"bottomPadding"];
    
}

-(MyMaker*)rightPadding
{
    return [self addMethod:@"rightPadding"];
    
}

-(MyMaker*)leadingPadding
{
    
    return [self addMethod:@"leadingPadding"];
    
}

-(MyMaker*)trailingPadding
{
    return [self addMethod:@"trailingPadding"];
    
}


-(MyMaker*)padding
{
     [self addMethod:@"topPadding"];
     [self addMethod:@"leftPadding"];
     [self addMethod:@"bottomPadding"];
    return [self addMethod:@"rightPadding"];
}

-(MyMaker*)zeroPadding
{
    return [self addMethod:@"zeroPadding"];
}

-(MyMaker*)orientation
{
    return [self addMethod:@"orientation"];
    
}

-(MyMaker*)gravity
{
    return [self addMethod:@"gravity"];
    
}


-(MyMaker*)centerX
{
  return [self addMethod:@"centerXPos"];
}

-(MyMaker*)centerY
{
    return [self addMethod:@"centerYPos"];
}

-(MyMaker*)center
{
    [self addMethod:@"centerXPos"];
    return [self addMethod:@"centerYPos"];
}

-(MyMaker*)visibility
{
    return [self addMethod:@"myVisibility"];
}

-(MyMaker*)alignment
{
    return [self addMethod:@"myAlignment"];
}



-(MyMaker*)sizeToFit
{
    for (UIView *myView in _myViews)
    {
        [myView sizeToFit];
    }
    
    return self;
}



-(MyMaker*)space
{
    return [self addMethod:@"subviewSpace"];
    
}

-(MyMaker*)shrinkType
{
    return [self addMethod:@"shrinkType"];
    
}


-(MyMaker*)arrangedCount
{
    return [self addMethod:@"arrangedCount"];
}

-(MyMaker*)autoArrange
{
    return [self addMethod:@"autoArrange"];
}

-(MyMaker*)arrangedGravity
{
    return [self addMethod:@"arrangedGravity"];

}

-(MyMaker*)vertSpace
{
    return [self addMethod:@"subviewVSpace"];

}

-(MyMaker*)horzSpace
{
    return [self addMethod:@"subviewHSpace"];

}

-(MyMaker*)pagedCount
{
    return [self addMethod:@"pagedCount"];
    
}




-(MyMaker* (^)(id val))equalTo
{
    _clear = YES;
    return ^id(id val) {
        
        for (NSString *key in _keys)
        {
            
            for (UIView * myView in _myViews)
            {
                if ([val isKindOfClass:[NSNumber class]])
                {
                    id oldVal = [myView valueForKey:key];
                    if ([oldVal isKindOfClass:[MyLayoutPos class]])
                    {
                        [((MyLayoutPos*)oldVal) __equalTo:val];
                    }
                    else if ([oldVal isKindOfClass:[MyLayoutSize class]])
                    {
                        [((MyLayoutSize*)oldVal) __equalTo:val];
                    }
                    else
                        [myView setValue:val forKey:key];
                }
                else if ([val isKindOfClass:[MyLayoutPos class]])
                {
                    [((MyLayoutPos*)[myView valueForKey:key]) __equalTo:val];
                }
                else if ([val isKindOfClass:[MyLayoutSize class]])
                {
                    [((MyLayoutSize*)[myView valueForKey:key]) __equalTo:val];
                }
                else if ([val isKindOfClass:[NSArray class]])
                {
                    [((MyLayoutSize*)[myView valueForKey:key]) __equalTo:val];
                }
                else if ([val isKindOfClass:[UIView class]])
                {
                    id oldVal = [val valueForKey:key];
                    if ([oldVal isKindOfClass:[MyLayoutPos class]])
                    {
                        [((MyLayoutPos*)[myView valueForKey:key]) __equalTo:oldVal];
                    }
                    else if ([oldVal isKindOfClass:[MyLayoutSize class]])
                    {
                        [((MyLayoutSize*)[myView valueForKey:key]) __equalTo:oldVal];
                        
                    }
                    else
                    {
                        [myView setValue:oldVal forKey:key];
                    }
                }
            }
            
        }
        
        return self;
    };
}

-(MyMaker* (^)(CGFloat val))offset
{
    _clear = YES;
    
    return ^id(CGFloat val) {
        
        for (NSString *key in _keys)
        {
            for (UIView *myView in _myViews)
            {
                
                [((MyLayoutPos*)[myView valueForKey:key]) __offset:val];
            }
        }
        
        return self;
    };
}

-(MyMaker* (^)(CGFloat val))multiply
{
    _clear = YES;
    return ^id(CGFloat val) {
        
        for (NSString *key in _keys)
        {
            for (UIView *myView in _myViews)
            {
                
                [((MyLayoutSize*)[myView valueForKey:key]) __multiply:val];
            }
        }
        return self;
    };
    
}

-(MyMaker* (^)(CGFloat val))add
{
    _clear = YES;
    return ^id(CGFloat val) {
        
        for (NSString *key in _keys)
        {
            
            for (UIView *myView in _myViews)
            {
                
                [((MyLayoutSize*)[myView valueForKey:key]) __add:val];
            }
        }
        return self;
    };
    
}

-(MyMaker* (^)(id val))min
{
    _clear = YES;
    return ^id(id val) {
        
        for (NSString *key in _keys)
        {
            
            for (UIView *myView in _myViews)
            {
                
                
                id val2 = val;
                if ([val isKindOfClass:[UIView class]])
                    val2 = [val valueForKey:key];
                
                id oldVal = [myView valueForKey:key];
                if ([oldVal isKindOfClass:[MyLayoutPos class]])
                {
                    [((MyLayoutPos*)oldVal) __lBound:val2 offsetVal:0];
                }
                else if ([oldVal isKindOfClass:[MyLayoutSize class]])
                {
                    [((MyLayoutSize*)oldVal) __lBound:val2 addVal:0 multiVal:1];
                }
                else
                    ;
            }
        }
        return self;
    };
    
}

-(MyMaker* (^)(id val))max
{
    _clear = YES;
    return ^id(id val) {
        
        for (NSString *key in _keys)
        {
            for (UIView *myView in _myViews)
            {
                id val2 = val;
                if ([val isKindOfClass:[UIView class]])
                    val2 = [val valueForKey:key];
                
                id oldVal = [myView valueForKey:key];
                if ([oldVal isKindOfClass:[MyLayoutPos class]])
                {
                    [((MyLayoutPos*)oldVal) __uBound:val2 offsetVal:0];
                }
                else if ([oldVal isKindOfClass:[MyLayoutSize class]])
                {
                    [((MyLayoutSize*)oldVal) __uBound:val2 addVal:0 multiVal:1];
                }
                else
                    ;
            }
        }
        return self;
    };

}



@end


@implementation UIView(MyMakerExt)


-(void)makeLayout:(void(^)(MyMaker *make))layoutMaker
{
    
    MyMaker *myMaker = [[MyMaker alloc] initWithView:@[self]];
    layoutMaker(myMaker);
}

-(void)allSubviewMakeLayout:(void(^)(MyMaker *make))layoutMaker
{
    MyMaker *myMaker = [[MyMaker alloc] initWithView:self.subviews];
    layoutMaker(myMaker);
}


@end

#endif

