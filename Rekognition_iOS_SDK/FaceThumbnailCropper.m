//
//  FaceThumbnailCropper.m
//  ReKo SDK
//
//  Created by Kuang Han on 10/20/13.
//  Copyright (c) 2013 Orbeus Inc. All rights reserved.
//

#import "FaceThumbnailCropper.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>

@interface FaceThumbnailCropper()
@property (strong, nonatomic) NSMutableArray *rawFaceRectArray;
@property (strong, nonatomic) NSMutableArray *formattedFaceRectArray;
@end

@implementation FaceThumbnailCropper

const float THUMBNAIL_MAX_EDGE = 200.0;
const float MERGED_IMAGE_MAX_WIDTH = 800.0;

- (NSData *)cropFaceThumbnailsInUIImage:(UIImage *)uiImage {
//    [self saveUIImageToAlbum:uiImage];
    NSLog(@"%d", [uiImage imageOrientation]);
    
    CIImage *ciImage = uiImage.CIImage;
    if (!ciImage) {
        ciImage = [CIImage imageWithCGImage:uiImage.CGImage];
    }
    return [self cropFaceThumbnailsInCIImage:ciImage];
}


- (NSData *)cropFaceThumbnailsInNSData:(NSData *)imageData {
    CIImage *ciImage = [CIImage imageWithData:imageData];
    return [self cropFaceThumbnailsInCIImage:ciImage];
}


- (NSData *)cropFaceThumbnailsInCIImage:(CIImage *)ciImage {
    CGFloat rawImageWidth = ciImage.extent.size.width;
    CGFloat rawImageHeight = ciImage.extent.size.height;
    
    NSDictionary *detectorOptions = @{ CIDetectorAccuracy : CIDetectorAccuracyHigh };
	CIDetector *faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];
    NSNumber* cgOrienation = [ciImage.properties objectForKey:(NSString*)kCGImagePropertyOrientation];
    NSLog(@"CGOrientation: %@", cgOrienation);
    if (cgOrienation == nil) {
        cgOrienation = @1;
    }
    NSDictionary *imageOptions = @{ CIDetectorImageOrientation : cgOrienation};
    NSArray *features = [faceDetector featuresInImage:ciImage options:imageOptions];
    
    self.rawFaceRectArray = [NSMutableArray arrayWithCapacity:10];
    self.formattedFaceRectArray = [NSMutableArray arrayWithCapacity:10];
    int curX = 0, curY = 0, curRowHeight = 0, mergedImageWidth = 0, mergedImageHeight = 0;
    for (int i = 0; i < [features count]; i++) {
        NSLog(@"%d", i);
        CIFaceFeature *ff = features[i];
//        CIImage *temp = [ciImage imageByCroppingToRect:ff.bounds];
//        [self saveUIImageToAlbum:[UIImage imageWithCIImage:temp]];
        
        CGFloat width = ff.bounds.size.width * 2;
        CGFloat height = ff.bounds.size.height * 2;
        CGFloat x0 = ff.bounds.origin.x - ff.bounds.size.width * 0.5;
        CGFloat y0 = ciImage.extent.size.height - ff.bounds.origin.y - ff.bounds.size.height * 1.5;
        CGFloat x1 = x0 + width;
        CGFloat y1 = y0 + height;
        x0 = (x0 < 0) ? 0 : x0;
        y0 = (y0 < 0) ? 0 : y0;
        x1 = (x1 > rawImageWidth) ? rawImageWidth : x1;
        y1 = (y1 > rawImageHeight) ? rawImageHeight : y1;
        width = x1 - x0;
        height = y1 - y0;
        CGRect rawFaceRect = CGRectMake(x0, y0, width, height);
        NSLog(@"raw: %f, %f, %f, %f", x0, y0, width, height);
        [self.rawFaceRectArray addObject:[NSValue valueWithCGRect:rawFaceRect]];
        
        CGSize formattedFaceSize = rawFaceRect.size;
        if (rawFaceRect.size.width > THUMBNAIL_MAX_EDGE || rawFaceRect.size.height > THUMBNAIL_MAX_EDGE) {
            if (rawFaceRect.size.width > rawFaceRect.size.height) {
                formattedFaceSize = CGSizeMake(THUMBNAIL_MAX_EDGE, rawFaceRect.size.height / rawFaceRect.size.width * THUMBNAIL_MAX_EDGE);
            } else {
                formattedFaceSize = CGSizeMake(rawFaceRect.size.width / rawFaceRect.size.height * THUMBNAIL_MAX_EDGE, THUMBNAIL_MAX_EDGE);
            }
        }
        
        if (curX + formattedFaceSize.width > MERGED_IMAGE_MAX_WIDTH) {
            mergedImageWidth = MAX(mergedImageWidth, curX);
            curX = 0;
            curY += curRowHeight;
        }
        CGRect formattedFaceRect = CGRectMake(curX, curY, formattedFaceSize.width, formattedFaceSize.height);
        NSLog(@"formatted: %f, %f, %f, %f", formattedFaceRect.origin.x, formattedFaceRect.origin.y, formattedFaceRect.size.width, formattedFaceRect.size.height);
        [self.formattedFaceRectArray addObject:[NSValue valueWithCGRect:formattedFaceRect]];
        curRowHeight = MAX(curRowHeight, formattedFaceSize.height);
        curX += formattedFaceSize.width;
    }
    mergedImageWidth = MAX(mergedImageWidth, curX);
    mergedImageHeight = curY + curRowHeight;
    
    NSLog(@"%d, %d", mergedImageWidth, mergedImageHeight);
    UIGraphicsBeginImageContext(CGSizeMake(mergedImageWidth, mergedImageHeight));
    for (int i = 0; i < [self.rawFaceRectArray count]; i++) {
        CGRect rawFaceRect = [(NSValue *) self.rawFaceRectArray[i] CGRectValue];
        CGRect formattedFaceRect = [(NSValue *) self.formattedFaceRectArray[i] CGRectValue];
        CGRect ciRect = CGRectMake(rawFaceRect.origin.x, rawImageHeight - rawFaceRect.origin.y - rawFaceRect.size.height, rawFaceRect.size.width, rawFaceRect.size.height);
        CIImage *ciThumbnail = [ciImage imageByCroppingToRect:ciRect];
        UIImage *thumbnail = [UIImage imageWithCIImage:ciThumbnail];
        [thumbnail drawInRect:formattedFaceRect];
//        [self saveImageToAlbum:thumbnail];
    }
    UIImage *mergedImage = UIGraphicsGetImageFromCurrentImageContext();
    [self saveUIImageToAlbum:mergedImage];
    UIGraphicsEndImageContext();
    
    return UIImageJPEGRepresentation(mergedImage, 1.0f);
}


- (void)saveUIImageToAlbum:(UIImage *)image {
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
//    return;
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
