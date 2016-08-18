//
//  MyMaker.m
//  MyLayout
//
//  Created by oybq on 15/7/5.
//  Copyright (c) 2015年 YoungSoft. All rights reserved.
//

#import "MyMaker.h"
#import "MyLayoutPos.h"
#import "MyLayoutDime.h"

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


-(MyMaker*)height
{
    return [self addMethod:@"heightDime"];
}

-(MyMaker*)width
{
    return [self addMethod:@"widthDime"];
}



-(MyMaker*)flexedHeight
{
    return [self addMethod:@"flexedHeight"];
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

-(MyMaker*)sizeToFit
{
    for (UIView *myView in _myViews)
    {
        [myView sizeToFit];
    }
    
    return self;
}


-(MyMaker*)marginGravity
{
    return [self addMethod:@"marginGravity"];

}

-(MyMaker*)subviewMargin
{
    return [self addMethod:@"subviewMargin"];
    
}

-(MyMaker*)arrangedCount
{
    return [self addMethod:@"arrangedCount"];
}

-(MyMaker*)averageArrange
{
    return [self addMethod:@"averageArrange"];
}

-(MyMaker*)autoArrange
{
    return [self addMethod:@"autoArrange"];
}

-(MyMaker*)arrangedGravity
{
    return [self addMethod:@"arrangedGravity"];

}

-(MyMaker*)subviewVertMargin
{
    return [self addMethod:@"subviewVertMargin"];

}

-(MyMaker*)subviewHorzMargin
{
    return [self addMethod:@"subviewHorzMargin"];

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
                        ((MyLayoutPos*)oldVal).equalTo(val);
                    }
                    else if ([oldVal isKindOfClass:[MyLayoutDime class]])
                    {
                        ((MyLayoutDime*)oldVal).equalTo(val);
                    }
                    else
                        [myView setValue:val forKey:key];
                }
                else if ([val isKindOfClass:[MyLayoutPos class]])
                {
                    ((MyLayoutPos*)[myView valueForKey:key]).equalTo(val);
                }
                else if ([val isKindOfClass:[MyLayoutDime class]])
                {
                    ((MyLayoutDime*)[myView valueForKey:key]).equalTo(val);
                }
                else if ([val isKindOfClass:[NSArray class]])
                {
                    ((MyLayoutDime*)[myView valueForKey:key]).equalTo(val);
                }
                else if ([val isKindOfClass:[UIView class]])
                {
                    id oldVal = [val valueForKey:key];
                    if ([oldVal isKindOfClass:[MyLayoutPos class]])
                    {
                        ((MyLayoutPos*)[myView valueForKey:key]).equalTo(oldVal);
                    }
                    else if ([oldVal isKindOfClass:[MyLayoutDime class]])
                    {
                        ((MyLayoutDime*)[myView valueForKey:key]).equalTo(oldVal);
                        
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
                
                ((MyLayoutPos*)[myView valueForKey:key]).offset(val);
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
                
                ((MyLayoutDime*)[myView valueForKey:key]).multiply(val);
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
                
                ((MyLayoutDime*)[myView valueForKey:key]).add(val);
            }
        }
        return self;
    };
    
}

-(MyMaker* (^)(CGFloat val))min
{
    _clear = YES;
    return ^id(CGFloat val) {
        
        for (NSString *key in _keys)
        {
            
            for (UIView *myView in _myViews)
            {
                
                ((MyLayoutDime*)[myView valueForKey:key]).min(val);
            }
        }
        return self;
    };

}

-(MyMaker* (^)(CGFloat val))max
{
    _clear = YES;
    return ^id(CGFloat val) {
        
        for (NSString *key in _keys)
        {
            
            for (UIView *myView in _myViews)
            {
                
                ((MyLayoutDime*)[myView valueForKey:key]).max(val);
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

