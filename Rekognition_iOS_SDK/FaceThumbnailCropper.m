//
//  FaceThumbnailCropper.m
//  ReKo SDK
//
//  Created by Kuang Han on 10/20/13.
//  Copyright (c) 2013 Orbeus Inc. All rights reserved.
//

#import "FaceThumbnailCropper.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation FaceThumbnailCropper

const float THUMBNAIL_EDGE_LENGTH = 180.0;

+ (NSArray *)cropFaceThumbnails:(UIImage *)image {
    CIImage *ciImage = image.CIImage;
    if (!ciImage) {
        CGImageRef cgImage = image.CGImage;
        ciImage = [CIImage imageWithCGImage:cgImage];
    }
    NSDictionary *detectorOptions = @{ CIDetectorAccuracy : CIDetectorAccuracyHigh };
	CIDetector *faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];
    NSDictionary *imageOptions = @{ CIDetectorImageOrientation : [NSNumber numberWithInt:1] };
    NSArray *features = [faceDetector featuresInImage:ciImage options:imageOptions];
    
    NSMutableArray *thumbnails = [NSMutableArray arrayWithCapacity:5];
    for (CIFaceFeature *ff in features) {
        CGFloat width = ff.bounds.size.width * 2;
        CGFloat height = ff.bounds.size.height * 2;
        CGFloat x = ff.bounds.origin.x - ff.bounds.size.width * 0.5;
        CGFloat y = ciImage.extent.size.height - ff.bounds.origin.y - ff.bounds.size.height * 1.7;
        UIImage *thumbnail = [FaceThumbnailCropper cropImage:image inRect:CGRectMake(x, y, width, height)];

        if (thumbnail.size.width > THUMBNAIL_EDGE_LENGTH || thumbnail.size.height > THUMBNAIL_EDGE_LENGTH) {
            CGSize newSize;
            if (thumbnail.size.width > thumbnail.size.height) {
                newSize = CGSizeMake(THUMBNAIL_EDGE_LENGTH, thumbnail.size.height / thumbnail.size.width * THUMBNAIL_EDGE_LENGTH);
            } else {
                newSize = CGSizeMake(thumbnail.size.width / thumbnail.size.height * THUMBNAIL_EDGE_LENGTH, THUMBNAIL_EDGE_LENGTH);
            }
            thumbnail = [FaceThumbnailCropper imageWithImage:thumbnail scaledToSize:newSize];
        }
        [thumbnails addObject:thumbnail];
        [FaceThumbnailCropper saveImageToAlbum:thumbnail];
    }
    NSLog(@"%@", thumbnails);
    return thumbnails;
}


+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


+ (UIImage *)cropImage:(UIImage*)image inRect:(CGRect)rect {
    CGImageRef cgImage = image.CGImage;
    CGImageRef cgImageTemp;
    UIImage *imageToReturn;
    if (!cgImage) {
        CIContext *context = [CIContext contextWithOptions:nil];
        cgImageTemp = [context createCGImage:image.CIImage fromRect:rect];
    } else {
        cgImageTemp = CGImageCreateWithImageInRect(cgImage, rect);
    }
    imageToReturn = [UIImage imageWithCGImage:cgImageTemp];
    CGImageRelease(cgImageTemp);
    return imageToReturn;
}


+ (void)saveImageToAlbum:(UIImage *)image {
    CGImageRef cgImage = image.CGImage;
    BOOL releaseCGImage = NO;
    if (!cgImage) {
        CIContext *context = [CIContext contextWithOptions:nil];
        cgImage = [context createCGImage:image.CIImage fromRect:image.CIImage.extent];
        releaseCGImage = YES;
    }
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:cgImage
                              orientation:0
                          completionBlock:^(NSURL *assetURL, NSError *error) {
                              if (releaseCGImage) {
                                  CGImageRelease(cgImage);
                              }
                          }];
}

@end
