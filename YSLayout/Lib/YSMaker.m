//
//  YSMaker.m
//  YSLayout
//
//  Created by apple on 15/7/5.
//  Copyright (c) 2015年 欧阳大哥. All rights reserved.
//

#import "YSMaker.h"
#import "YSLayoutPos.h"
#import "YSLayoutDime.h"

@implementation YSMaker
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

-(YSMaker*)addMethod:(NSString*)method
{
    if (_clear)
        [_keys removeAllObjects];
    _clear = NO;
    
    [_keys addObject:method];
    return self;
}



-(YSMaker*)top
{
    return [self addMethod:@"topPos"];
}

-(YSMaker*)left
{
    return [self addMethod:@"leftPos"];
}

-(YSMaker*)bottom
{
    return [self addMethod:@"bottomPos"];
}

-(YSMaker*)right
{
    return [self addMethod:@"rightPos"];
}

-(YSMaker*)margin
{
    [self top];
    [self left];
    [self right];
   return [self bottom];
}


-(YSMaker*)height
{
    return [self addMethod:@"heightDime"];
}

-(YSMaker*)width
{
    return [self addMethod:@"widthDime"];
}



-(YSMaker*)flexedHeight
{
    return [self addMethod:@"flexedHeight"];
    
}

-(YSMaker*)wrapContentHeight
{
    return [self addMethod:@"wrapContentHeight"];
}

-(YSMaker*)wrapContentWidth
{
    return [self addMethod:@"wrapContentWidth"];
}


-(YSMaker*)weight
{
    return [self addMethod:@"weight"];
    
}


-(YSMaker*)topPadding
{
    
    return [self addMethod:@"ysTopPadding"];
    
}

-(YSMaker*)leftPadding
{
    return [self addMethod:@"ysLeftPadding"];
    
}

-(YSMaker*)bottomPadding
{
    
    return [self addMethod:@"ysBottomPadding"];
    
}

-(YSMaker*)rightPadding
{
    return [self addMethod:@"ysRightPadding"];
    
}


//布局独有
-(YSMaker*)orientation
{
    return [self addMethod:@"orientation"];
    
}

-(YSMaker*)gravity
{
    return [self addMethod:@"gravity"];
    
}


-(YSMaker*)centerX
{
  return [self addMethod:@"centerXPos"];
}

-(YSMaker*)centerY
{
    return [self addMethod:@"centerYPos"];
}

-(YSMaker*)sizeToFit
{
    for (UIView *myView in _myViews)
    {
        [myView sizeToFit];
    }
    
    return self;
}


-(YSMaker*)marginGravity
{
    return [self addMethod:@"marginGravity"];

}




-(YSMaker* (^)(id val))equalTo
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
                    if ([oldVal isKindOfClass:[YSLayoutPos class]])
                    {
                        ((YSLayoutPos*)oldVal).equalTo(val);
                    }
                    else if ([oldVal isKindOfClass:[YSLayoutDime class]])
                    {
                        ((YSLayoutDime*)oldVal).equalTo(val);
                    }
                    else
                        [myView setValue:val forKey:key];
                }
                else if ([val isKindOfClass:[YSLayoutPos class]])
                {
                    ((YSLayoutPos*)[myView valueForKey:key]).equalTo(val);
                }
                else if ([val isKindOfClass:[YSLayoutDime class]])
                {
                    ((YSLayoutDime*)[myView valueForKey:key]).equalTo(val);
                }
                else if ([val isKindOfClass:[NSArray class]])
                {
                    ((YSLayoutDime*)[myView valueForKey:key]).equalTo(val);
                }
                else if ([val isKindOfClass:[UIView class]])
                {
                    id oldVal = [val valueForKey:key];
                    if ([oldVal isKindOfClass:[YSLayoutPos class]])
                    {
                        ((YSLayoutPos*)[myView valueForKey:key]).equalTo(oldVal);
                    }
                    else if ([oldVal isKindOfClass:[YSLayoutDime class]])
                    {
                        ((YSLayoutDime*)[myView valueForKey:key]).equalTo(oldVal);
                        
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

-(YSMaker* (^)(CGFloat val))offset
{
    _clear = YES;
    
    return ^id(CGFloat val) {
        
        for (NSString *key in _keys)
        {
            for (UIView *myView in _myViews)
            {
                
                ((YSLayoutPos*)[myView valueForKey:key]).offset(val);
            }
        }
        
        return self;
    };
}

-(YSMaker* (^)(CGFloat val))multiply
{
    _clear = YES;
    return ^id(CGFloat val) {
        
        for (NSString *key in _keys)
        {
            for (UIView *myView in _myViews)
            {
                
                ((YSLayoutDime*)[myView valueForKey:key]).multiply(val);
            }
        }
        return self;
    };
    
}

-(YSMaker* (^)(CGFloat val))add
{
    _clear = YES;
    return ^id(CGFloat val) {
        
        for (NSString *key in _keys)
        {
            
            for (UIView *myView in _myViews)
            {
                
                ((YSLayoutDime*)[myView valueForKey:key]).add(val);
            }
        }
        return self;
    };
    
}

-(YSMaker* (^)(CGFloat val))min
{
    _clear = YES;
    return ^id(CGFloat val) {
        
        for (NSString *key in _keys)
        {
            
            for (UIView *myView in _myViews)
            {
                
                ((YSLayoutDime*)[myView valueForKey:key]).min(val);
            }
        }
        return self;
    };

}

-(YSMaker* (^)(CGFloat val))max
{
    _clear = YES;
    return ^id(CGFloat val) {
        
        for (NSString *key in _keys)
        {
            
            for (UIView *myView in _myViews)
            {
                
                ((YSLayoutDime*)[myView valueForKey:key]).max(val);
            }
        }
        return self;
    };

}



@end


@implementation UIView(YSMakerExt)


-(void)makeLayout:(void(^)(YSMaker *make))layoutMaker
{
    
    YSMaker *ysMaker = [[YSMaker alloc] initWithView:@[self]];
    layoutMaker(ysMaker);
}

-(void)allSubviewMakeLayout:(void(^)(YSMaker *make))layoutMaker
{
    YSMaker *ysMaker = [[YSMaker alloc] initWithView:self.subviews];
    layoutMaker(ysMaker);
}


@end

