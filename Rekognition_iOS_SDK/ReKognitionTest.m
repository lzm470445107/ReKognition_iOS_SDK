//
//  ReKognitionTest.m
//  ReKo SDK
//
//  Created by Kuang Han on 11/6/13.
//  Copyright (c) 2013 Orbeus Inc. All rights reserved.
//

#import "ReKognitionTest.h"
#import "ReKognitionSDK.h"
#import "FaceThumbnailCropper.h"

@implementation ReKognitionTest

+ (void)run {
//    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/testimages/IMG_1327.JPG"];
//    UIImage *image = [UIImage imageWithContentsOfFile:path];
//    FaceThumbnailCropper *cropper = [[FaceThumbnailCropper alloc] init];
//    UIImage *cropped = [cropper cropFaceThumbnailsInUIImage:image];
//
//    RKFaceDetectResults *detect = [ReKognitionSDK RKFaceDetect:cropped jobs:@"face_part_gender_emotion_race_age_glass_mouth_open_wide_eye_closed"];
//    [cropper correctFaceDetectResult:detect];
//    detect = [ReKognitionSDK RKFaceDetectWithUrl:[NSURL URLWithString:@"http://cdn.pingwest.com/wp-content/uploads/2013/01/0830_ChiStartups_630x420.jpg"] jobs:@"face_part_gender_emotion_race_age_glass_mouth_open_wide_eye_closed"];
//  
//    RKFaceDetectResults *add = [ReKognitionSDK RKFaceAdd:cropped nameSpace:@"asdf" userID:@"demo" tag:nil jobs:nil];
//    [cropper correctFaceDetectResult:add];
//  
//    RKFaceClusterResults *cluster = [ReKognitionSDK RKFaceCluster:@"asdf" userId:@"demo" aggressiveness:nil];
//  
//    RKFaceVisualizeResults *visualize = [ReKognitionSDK RKFaceVisualize:nil jobs:nil nameSpace:@"asdf" userID:@"demo" num_tag_return:nil num_img_return_pertag:nil];
//
//    RKBaseResults *rename = [ReKognitionSDK RKFaceRenameOrMergeTag:@"cluster2" withTag:@"meng" selectedFaces:nil nameSpace:@"asdf" userID:@"demo"];
//
//    RKBaseResults *train = [ReKognitionSDK RKFaceTrain:@"asdf" userID:@"demo" tags:nil];
//    
//    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/testimages/IMG_1320.JPG"];
//    UIImage *image = [UIImage imageWithContentsOfFile:path];
//    FaceThumbnailCropper *cropper = [[FaceThumbnailCropper alloc] init];
//    UIImage *cropped = [cropper cropFaceThumbnailsInUIImage:image];
//    RKFaceDetectResults *recognize = [ReKognitionSDK RKFaceRecognize:cropped nameSpace:@"asdf" userID:@"demo" jobs:@"face_recognize_nodetect" num_return:nil tags:nil];
//    [cropper correctFaceDetectResult:recognize];
//
//    RKFaceDetectResults *recognize = [ReKognitionSDK RKFaceRecognizeWithUrl:[NSURL URLWithString:@"http://cdn.pingwest.com/wp-content/uploads/2013/01/0830_ChiStartups_630x420.jpg"] nameSpace:@"asdf" userID:@"demo" jobs:nil num_return:nil tags:nil];
//
//    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/testimages/IMG_1320.JPG"];
//    UIImage *image = [UIImage imageWithContentsOfFile:path];
//    FaceThumbnailCropper *cropper = [[FaceThumbnailCropper alloc] init];
//    UIImage *cropped = [cropper cropFaceThumbnailsInUIImage:image];
//    RKFaceDetectResults *search = [ReKognitionSDK RKFaceSearch:cropped jobs:nil nameSpace:@"asdf" userID:@"demo" num_return:nil tags:nil];
//    [cropper correctFaceDetectResult:search];
//    RKFaceDetectResults *urlsearch = [ReKognitionSDK RKFaceSearchWithUrl:[NSURL URLWithString:@"http://cdn.pingwest.com/wp-content/uploads/2013/01/0830_ChiStartups_630x420.jpg"] jobs:nil nameSpace:@"asdf" userID:@"demo" num_return:nil tags:nil];
//
//
//    RKBaseResults *delete = [ReKognitionSDK RKFaceDelete:@"demo" imageIndex:nil nameSpace:@"asdf" userID:@"demo"];
//
//    RKNameSpaceStatsResults *namespace = [ReKognitionSDK RKNameSpaceStats];
//    RKUserIdStatsResults *userid = [ReKognitionSDK RKUserIdStats:@"asdf"];
}

@end
