//
//  AllTest10Model.m
//  FriendListDemo
//
//  Created by bsj_mac_2 on 2018/5/9.
//  Copyright © 2018年 bsj_mac_2. All rights reserved.
//

#import "AllTest10Model.h"

@implementation AllTest10Model

+ (NSString *)randTestComments {
    NSArray *textMessages = @[NSLocalizedString(@"A single line text", @""),
                              NSLocalizedString(@"This Demo is used to introduce the solution when use layout view to realize the UITableViewCell's dynamic height. We only need to use the layout view's sizeThatFits method to evaluate the size of the layout view. and you can touch the Cell to shrink the height when the Cell has a picture.", @""),
                              NSLocalizedString(@"Through layout view's sizeThatFits method can assess a UITableViewCell dynamic height.EstimateLayoutRect just to evaluate layout size but not set the size of the layout. here don't preach the width of 0 is the cause of the above UITableViewCell set the default width is 320 (regardless of any screen), so if we pass the width of 0 will be according to the width of 320 to evaluate UITableViewCell dynamic height, so when in 375 and 375 the width of the assessment of height will not be right, so here you need to specify the real width dimension;And the height is set to 0 mean height is not a fixed value need to evaluate. you can use all type layout view to realize UITableViewCell.", @""),
                              NSLocalizedString(@"This section not only has text but also hav picture. and picture below at text, text will wrap", @"")
                              ];
    return textMessages[arc4random_uniform((uint32_t)textMessages.count)];
}

+ (NSArray<AllTest10Model *>*)getRandTestDatasWithNumber:(NSInteger)modelsNumber {
    
    NSArray *headImages = @[@"head1",
                            @"head2",
                            @"minions1",
                            @"minions4"
                            ];
    
    NSArray *nickNames = @[@"欧阳大哥",
                           @"醉里挑灯看键",
                           @"张三",
                           @"李四"
                           ];
    
    NSArray *contentTexts = @[@"",
                              NSLocalizedString(@"A single line text", @""),
                              NSLocalizedString(@"This Demo is used to introduce the solution when use layout view to realize the UITableViewCell's dynamic height. We only need to use the layout view's sizeThatFits method to evaluate the size of the layout view. and you can touch the Cell to shrink the height when the Cell has a picture.", @""),
                              NSLocalizedString(@"Through layout view's sizeThatFits method can assess a UITableViewCell dynamic height.EstimateLayoutRect just to evaluate layout size but not set the size of the layout. here don't preach the width of 0 is the cause of the above UITableViewCell set the default width is 320 (regardless of any screen), so if we pass the width of 0 will be according to the width of 320 to evaluate UITableViewCell dynamic height, so when in 375 and 375 the width of the assessment of height will not be right, so here you need to specify the real width dimension;And the height is set to 0 mean height is not a fixed value need to evaluate. you can use all type layout view to realize UITableViewCell.", @""),
                              NSLocalizedString(@"This section not only has text but also hav picture. and picture below at text, text will wrap", @"")
                              ];
    
    NSArray *textMessages = @[NSLocalizedString(@"A single line text", @""),
                              NSLocalizedString(@"This Demo is used to introduce the solution when use layout view to realize the UITableViewCell's dynamic height. We only need to use the layout view's sizeThatFits method to evaluate the size of the layout view. and you can touch the Cell to shrink the height when the Cell has a picture.", @""),
                              NSLocalizedString(@"Through layout view's sizeThatFits method can assess a UITableViewCell dynamic height.EstimateLayoutRect just to evaluate layout size but not set the size of the layout. here don't preach the width of 0 is the cause of the above UITableViewCell set the default width is 320 (regardless of any screen), so if we pass the width of 0 will be according to the width of 320 to evaluate UITableViewCell dynamic height, so when in 375 and 375 the width of the assessment of height will not be right, so here you need to specify the real width dimension;And the height is set to 0 mean height is not a fixed value need to evaluate. you can use all type layout view to realize UITableViewCell.", @""),
                              NSLocalizedString(@"This section not only has text but also hav picture. and picture below at text, text will wrap", @"")
                              ];
    
    NSArray *commentsImageUrls = @[@"head1",@"head2",@"bk3",@"image1",@"image2",@"image3",@"image4"];
    
    NSMutableArray *arrays = [NSMutableArray array];
    for (int i = 0; i<modelsNumber; i++) {
        AllTest10Model *model = [[AllTest10Model alloc] init];
        model.icon = headImages[arc4random_uniform((uint32_t)headImages.count)];
        model.name = nickNames[arc4random_uniform((uint32_t)nickNames.count)];
        model.content = contentTexts[arc4random_uniform((uint32_t)contentTexts.count)];
        model.browCount = arc4random_uniform(100);
        model.time = @"2018-05-09 22:00:00";
        if (i == 0 || i == 5 || i == 10) {
            model.giveLikeNames = [NSMutableArray array];
            model.commentsImageUrls = [NSMutableArray array];
            model.comments = [NSMutableArray array];
        } else {
            model.giveLikeNames = [NSMutableArray arrayWithArray:nickNames];
            NSMutableArray *imageArray = [NSMutableArray array];
            NSInteger maxCount = arc4random_uniform((uint32_t)8);
            while ([imageArray count] < maxCount) {
                int r = arc4random() % [commentsImageUrls count];
                [imageArray addObject:[commentsImageUrls objectAtIndex:r]];
            }
            model.commentsImageUrls = [imageArray copy];
            if (imageArray.count == 0 && model.name.length == 0) {
                model.commentsImageUrls = @[@"image1",@"image2",@"image3"];
            }
            model.comments = [NSMutableArray arrayWithArray:textMessages];
        }
        
        [arrays addObject:model];
    }
    return [arrays copy];
}

@end
