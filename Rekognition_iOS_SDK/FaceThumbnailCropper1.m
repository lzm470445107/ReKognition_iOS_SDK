//
//  FaceThumbnailCropper.m
//  ReKo SDK
//
//  Created by Kuang Han on 10/20/13.
//  Copyright (c) 2013 Orbeus Inc. All rights reserved.
//

#import "FaceThumbnailCropper1.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>

@implementation RKFace
@end

@implementation FaceThumbnailCropper1

const float THUMBNAIL_EDGE_LENGTH = 200;

+ (NSInteger)CGImageOrientationForUIImageOrientation:(UIImageOrientation)orientation {
  switch (orientation) {
    case UIImageOrientationUp:
      return 1;
    case UIImageOrientationDown:
      return 3;
    case UIImageOrientationLeft:
      return 8;
    case UIImageOrientationRight:
      return 6;
    case UIImageOrientationUpMirrored:
      return 2;
    case UIImageOrientationDownMirrored:
      return 4;
    case UIImageOrientationLeftMirrored:
      return 5;
    case UIImageOrientationRightMirrored:
      return 7;
  }
  return 1;
}

+ (UIImageOrientation)UIImageOrientationForCGImageOrienation:(NSUInteger)orientation {
  switch (orientation) {
    case 1: return UIImageOrientationUp;
    case 2: return UIImageOrientationUpMirrored;
    case 3: return UIImageOrientationDown;
    case 4: return UIImageOrientationDownMirrored;
    case 5: return UIImageOrientationLeftMirrored;
    case 6: return UIImageOrientationRight;
    case 7: return UIImageOrientationRightMirrored;
    case 8: return UIImageOrientationLeft;
  }
  return UIImageOrientationUp;
}

+ (NSArray *)cropFaceThumbnails:(NSData *)image {
  return [self cropFaceThumbnails:image returnBB:NO];
}

+ (NSArray*)cropFaceThumbnails:(NSData*)data returnBB:(BOOL)returnBB {
  CIImage* ciImage = [CIImage imageWithData:data];
  NSDictionary *detectorOptions = @{ CIDetectorAccuracy : CIDetectorAccuracyHigh };
  CIDetector *faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];
  NSNumber* cgImageOrienation = [ciImage.properties objectForKey:(NSString*)kCGImagePropertyOrientation];
  if (cgImageOrienation == nil) cgImageOrienation = @1;
  NSDictionary *imageOptions = @{ CIDetectorImageOrientation : cgImageOrienation};
  NSArray *features = [faceDetector featuresInImage:ciImage options:imageOptions];
  CGFloat imageWidth = [ciImage.properties[(NSString*)kCGImagePropertyPixelWidth] floatValue];
  CGFloat imageHeight = [ciImage.properties[(NSString*)kCGImagePropertyPixelHeight] floatValue];
  NSMutableArray *thumbnails = [NSMutableArray array];
  for (CIFaceFeature *ff in features) {
    CGRect rect = CGRectInset(ff.bounds, -ff.bounds.size.width, -ff.bounds.size.height);
    CIImage* thumbnailImage = [ciImage imageByCroppingToRect:rect];
    UIImage* thumbnail = [UIImage imageWithCIImage:thumbnailImage scale:1 orientation:[self UIImageOrientationForCGImageOrienation:[cgImageOrienation integerValue]]];
    if (thumbnail.size.width > THUMBNAIL_EDGE_LENGTH && thumbnail.size.height > THUMBNAIL_EDGE_LENGTH) {
      CGSize newSize;
      if (thumbnail.size.width > thumbnail.size.height) {
        newSize = CGSizeMake(thumbnail.size.width / thumbnail.size.height * THUMBNAIL_EDGE_LENGTH, THUMBNAIL_EDGE_LENGTH);
      } else {
        newSize = CGSizeMake(THUMBNAIL_EDGE_LENGTH, thumbnail.size.height / thumbnail.size.width * THUMBNAIL_EDGE_LENGTH);
      }
      thumbnail = [FaceThumbnailCropper1 imageWithImage:thumbnail scaledToSize:newSize];
    }
    if (returnBB) {
      RKFace* face = [[RKFace alloc] init];
      face.image = thumbnail;
      // We normalize the BBox.
      face.bb = CGRectMake(ff.bounds.origin.x / imageWidth, ff.bounds.origin.y / imageHeight, ff.bounds.size.width / imageWidth, ff.bounds.size.height / imageHeight);
      [thumbnails addObject:face];
    } else {
      [thumbnails addObject:thumbnail];
    }
  }
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
