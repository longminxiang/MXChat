//
//  FaceItem.m
//  Pods
//
//  Created by longminxiang on 15/10/9.
//
//

#import "FaceItem.h"

@implementation FaceItem

+ (NSArray *)faceItems
{
    static NSArray *array;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *codes = @[@":smile:",
                           @":laughing:",
                           @":blush:",
                           @":smiley:",
                           @":relaxed:",
                           @":smirk:",
                           @":heart_eyes:",
                           @":kissing_heart:",
                           @":kissing_closed_eyes:",
                           @":flushed:",
                           @":relieved:",
                           @":satisfied:",
                           @":grin:",
                           @":wink:",
                           @":stuck_out_tongue_winking_eye:",
                           @":stuck_out_tongue_closed_eyes:",
                           @":grinning:",
                           @":kissing:",
                           @":kissing_smiling_eyes:",
                           @":stuck_out_tongue:",
                           @":sleeping:",
                           @":worried:",
                           @":frowning:",
                           @":anguished:",
                           @":open_mouth:",
                           @":grimacing:",
                           @":confused:",
                           @":hushed:",
                           @":expressionless:",
                           @":unamused:",
                           @":sweat_smile:",
                           @":sweat:",
                           @":disappointed_relieved:",
                           @":weary:",
                           @":pensive:",
                           @":disappointed:",
                           @":confounded:",
                           @":fearful:",
                           @":cold_sweat:",
                           @":persevere:",
                           @":cry:",
                           @":sob:",
                           @":joy:",
                           @":astonished:",
                           @":scream:",
                           @":tired_face:",
                           @":angry:",
                           @":rage:",
                           @":triumph:",
                           @":sleepy:",
                           @":yum:",
                           @":mask:",
                           @":sunglasses:",
                           @":dizzy_face:",
                           @":neutral_face:",
                           @":no_mouth:",
                           @":innocent:",
                           @":thumbsup:",
                           @":thumbsdown:",
                           @":clap:",
                           @":point_right:",
                           @":point_left:"];
        
        NSMutableArray *faces = [NSMutableArray new];
        for (int i = 0; i < codes.count; i++) {
            FaceItem *item = [FaceItem new];
            item.code = codes[i];
            NSString *imageName = [item.code substringFromIndex:1];
            imageName = [imageName substringToIndex:imageName.length - 1];
            imageName = [NSString stringWithFormat:@"emoji_%@@2x.png", imageName];
            item.imageName = imageName;
            [faces addObject:item];
        }
        array = faces;
    });
    return array;
}

+ (FaceItem *)itemWithCode:(NSString *)code
{
    for (FaceItem *item in [self faceItems]) {
        if ([item.code isEqualToString:code]) {
            return item;
        }
    }
    return nil;
}

@end
