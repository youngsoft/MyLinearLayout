//
//  MyMaker.m
//  MyLinearLayoutDemo
//
//  Created by apple on 15/7/5.
//  Copyright (c) 2015年 SunnadaSoft. All rights reserved.
//

#import "MyMaker.h"
#import "MyRelativeLayout.h"

@implementation MyMaker
{
    // __weak UIView *_myView;
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

-(MyMaker*)topMargin
{
    return [self addMethod:@"topMargin"];
}

-(MyMaker*)leftMargin
{
    return [self addMethod:@"leftMargin"];
}

-(MyMaker*)bottomMargin
{
    return [self addMethod:@"bottomMargin"];
}

-(MyMaker*)rightMargin
{
    return [self addMethod:@"rightMargin"];
}

-(MyMaker*)margin
{
    return [self addMethod:@"margin"];
}

-(MyMaker*)marginGravity
{
    return [self addMethod:@"marginGravity"];
}

-(MyMaker*)matchParentWidth
{
    
    return [self addMethod:@"matchParentWidth"];
    
}

-(MyMaker*)matchParentHeight
{
    return [self addMethod:@"matchParentHeight"];
}

-(MyMaker*)flexedHeight
{
    return [self addMethod:@"flexedHeight"];
    
}

-(MyMaker*)weight
{
    return [self addMethod:@"weight"];
    
}

-(MyMaker*)height
{
    if (_myViews.count == 0)
        return self;
    
    UIView *myView = [_myViews lastObject];
    
    if (myView.superview == nil || ![myView.superview isKindOfClass:[MyRelativeLayout class]])
    {
        return [self addMethod:@"height"];
    }
    else
    {
        return [self addMethod:@"heightDime"];
    }
}

-(MyMaker*)width
{
    if (_myViews.count == 0)
        return self;
    
    UIView *myView = [_myViews lastObject];
    
    if (myView.superview == nil || ![myView.superview isKindOfClass:[MyRelativeLayout class]])
    {
        return [self addMethod:@"width"];
    }
    else
    {
        return [self addMethod:@"widthDime"];
    }
    
}

-(MyMaker*)size
{
    if (_myViews.count == 0)
        return self;
    
    UIView *myView = [_myViews lastObject];
    
    if (myView.superview == nil || ![myView.superview isKindOfClass:[MyRelativeLayout class]])
    {
        return [self addMethod:@"size"];
    }
    else
    {
        [self width];
        return [self height];
    }
    
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


//布局独有
-(MyMaker*)orientation
{
    return [self addMethod:@"orientation"];
    
}

-(MyMaker*)wrapContent
{
    return [self addMethod:@"wrapContent"];
}

-(MyMaker*)adjustScrollViewContentSize
{
    
    return [self addMethod:@"adjustScrollViewContentSize"];
    
}

-(MyMaker*)gravity
{
    return [self addMethod:@"gravity"];
    
}

-(MyMaker*)autoAdjustSize
{
    return [self addMethod:@"autoAdjustSize"];
    
}


-(MyMaker*)autoAdjustDir
{
    return [self addMethod:@"autoAdjustDir"];
}

-(MyMaker*)top
{
    if (_myViews.count == 0)
        return self;
    
    UIView *myView = [_myViews lastObject];
    
    if (myView.superview == nil || ![myView.superview isKindOfClass:[MyRelativeLayout class]])
        return [self topMargin];
    else
        return [self addMethod:@"topPos"];
    
}

-(MyMaker*)left
{
    if (_myViews.count == 0)
        return self;
    
    UIView *myView = [_myViews lastObject];
    
    if (myView.superview == nil || ![myView.superview isKindOfClass:[MyRelativeLayout class]])
        return [self leftMargin];
    else
        return [self addMethod:@"leftPos"];
}

-(MyMaker*)bottom
{
    if (_myViews.count == 0)
        return self;
    
    UIView *myView = [_myViews lastObject];
    
    if (myView.superview == nil || ![myView.superview isKindOfClass:[MyRelativeLayout class]])
        return [self bottomMargin];
    else
        return [self addMethod:@"bottomPos"];
}

-(MyMaker*)right
{
    if (_myViews.count == 0)
        return self;
    
    UIView *myView = [_myViews lastObject];
    
    if (myView.superview == nil || ![myView.superview isKindOfClass:[MyRelativeLayout class]])
        return [self rightMargin];
    else
        return [self addMethod:@"rightPos"];
}


-(MyMaker*)centerX
{
    if (_myViews.count == 0)
        return self;
    
    UIView *myView = [_myViews lastObject];
    
    if (myView.superview == nil || ![myView.superview isKindOfClass:[MyRelativeLayout class]])
    {
        
        for (UIView *v in _myViews)
            v.marginGravity |= MGRAVITY_HORZ_CENTER;
        
        return [self addMethod:@"leftMargin"];
    }
    else
    {
        return [self addMethod:@"centerXPos"];
    }
    
    
}

-(MyMaker*)centerY
{
    if (_myViews.count == 0)
        return self;
    
    UIView *myView = [_myViews lastObject];
    
    if (myView.superview == nil || ![myView.superview isKindOfClass:[MyRelativeLayout class]])
    {
        for (UIView *v in _myViews)
            v.marginGravity |= MGRAVITY_VERT_CENTER;
        
        
        return [self addMethod:@"topMargin"];
    }
    else
    {
        return [self addMethod:@"centerYPos"];
        
    }
    
}

-(MyMaker*)center
{
    [self centerX];
    return [self centerY];
}


-(MyMaker* (^)(id val))equalTo
{
    _clear = YES;
    return ^id(id val) {
        
        for (NSString *key in _keys)
        {
            
            for (UIView * myView in _myViews)
            {
                
                //如果是整形
                if ([val isKindOfClass:[NSNumber class]])
                {
                    id oldVal = [myView valueForKey:key];
                    if ([oldVal isKindOfClass:[MyRelativePos class]])
                    {
                        ((MyRelativePos*)oldVal).equalTo(val);
                    }
                    else if ([oldVal isKindOfClass:[MyRelativeDime class]])
                    {
                        ((MyRelativeDime*)oldVal).equalTo(val);
                    }
                    else
                        [myView setValue:val forKey:key];
                }
                else if ([val isKindOfClass:[MyRelativePos class]])
                {
                    ((MyRelativePos*)[myView valueForKey:key]).equalTo(val);
                }
                else if ([val isKindOfClass:[MyRelativeDime class]])
                {
                    ((MyRelativeDime*)[myView valueForKey:key]).equalTo(val);
                }
                else if ([val isKindOfClass:[NSArray class]])
                {
                    ((MyRelativeDime*)[myView valueForKey:key]).equalTo(val);
                }
                else if ([val isKindOfClass:[UIView class]])
                {
                    id oldVal = [val valueForKey:key];
                    if ([oldVal isKindOfClass:[MyRelativePos class]])
                    {
                        ((MyRelativePos*)[myView valueForKey:key]).equalTo(oldVal);
                    }
                    else if ([oldVal isKindOfClass:[MyRelativeDime class]])
                    {
                        ((MyRelativeDime*)[myView valueForKey:key]).equalTo(oldVal);
                        
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
                
                ((MyRelativePos*)[myView valueForKey:key]).offset(val);
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
                
                ((MyRelativeDime*)[myView valueForKey:key]).multiply(val);
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
                
                ((MyRelativeDime*)[myView valueForKey:key]).add(val);
            }
        }
        return self;
    };
    
}




@end

@implementation UIView(MyMakerEx)


-(void)makeLayout:(void(^)(MyMaker *make))layoutMaker
{
    MyMaker *mymaker = [[MyMaker alloc] initWithView:@[self]];
    layoutMaker(mymaker);
}

-(void)allSubviewMakeLayout:(void(^)(MyMaker *make))layoutMaker
{
    MyMaker *mymaker = [[MyMaker alloc] initWithView:self.subviews];
    layoutMaker(mymaker);
}


@end

