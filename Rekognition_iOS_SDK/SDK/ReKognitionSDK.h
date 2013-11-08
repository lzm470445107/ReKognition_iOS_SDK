//
//  RKPostJobs.h
//  Rekognition_iOS_SDK
//
//  Created by cys on 7/20/13.
//  Copyright (c) 2013 Orbeus Inc. All rights reserved.
//
//  Wrapper for ReKognition APIs.

#import <Foundation/Foundation.h>
#import "ReKognitionResults.h"

@interface ReKognitionSDK : NSObject

// ReKognition Post Jobs Function (to customize your own recognition functions)
+ (NSData *)postReKognitionJobs:(NSDictionary *)jobsDictionary;


// ReKognition Face Detect Function (if not set, jobs is "face_aggressive" by default)
+ (RKFaceDetectResults *)RKFaceDetect:(UIImage*)image
                                 jobs:(NSString *)jobs;            // optional: "face_aggressive"
+ (RKFaceDetectResults *)RKFaceDetectWithUrl:(NSURL *)imageUrl
                                        jobs:(NSString *)jobs;     // optional: "face_aggressive"


// ReKognition Face Add Function
+ (RKFaceDetectResults *)RKFaceAdd:(UIImage*)image
                         nameSpace:(NSString *)name_space          // optional
                            userID:(NSString *)user_id             // optional
                               tag:(NSString *)tag                 // optional
                              jobs:(NSString *)jobs;               // optional: "face_add"
+ (RKFaceDetectResults *)RKFaceAddWithUrl:(NSURL *)imageUrl
                                nameSpace:(NSString *)name_space  // optional
                                   userID:(NSString *)user_id     // optional
                                      tag:(NSString *)tag         // optional
                                     jobs:(NSString *)jobs;       // optional: "face_add"


// ReKognition Face Train Function
+ (RKBaseResults *)RKFaceTrain:(NSString *)name_space        // optional
                        userID:(NSString *)user_id           // optional
                          tags:(NSArray *)tags;              // optional


// ReKognition Face Cluster Function
+ (RKFaceClusterResults *)RKFaceCluster:(NSString *)name_space      // optional
                                 userId:(NSString *)user_id         // optional
                         aggressiveness:(NSNumber *)aggressiveness; // optional: 40


// ReKognition Face Crawl Function
+ (RKFaceCrawlResults *)RKFaceCrawl:(NSString *)fb_id
                       access_token:(NSString *)access_token
                        crawl_fb_id:(NSArray *)friends_ids
                          nameSpace:(NSString *)name_space        // optional
                             userID:(NSString *)user_id;          // optional


// ReKognition Face Recognize Function
+ (RKFaceDetectResults *)RKFaceRecognize:(UIImage *)image
                               nameSpace:(NSString *)name_space    // optional
                                  userID:(NSString *)user_id       // optional
                                    jobs:(NSString *)jobs          // optional: "face_recognize"
                              num_return:(NSNumber *)num_return    // optional: 3
                                    tags:(NSArray *)tags;          // optional
+ (RKFaceDetectResults *)RKFaceRecognizeWithUrl:(NSURL *)imageUrl
                                      nameSpace:(NSString *)name_space     // optional
                                         userID:(NSString *)user_id        // optional
                                           jobs:(NSString *)jobs           // optional: "face_recognize"
                                     num_return:(NSNumber *)num_return     // optional: 3
                                           tags:(NSArray *)tags;           // optional


// ReKognition Face Visualize Function
+ (RKFaceVisualizeResults *)RKFaceVisualize:(NSArray *)tags                       // optional
                                       jobs:(NSString *)jobs                      // optional: "face_visualize_show_default_tag"
                                  nameSpace:(NSString *)name_space                // optional
                                     userID:(NSString *)user_id                   // optional
                             num_tag_return:(NSNumber *)num_tag_return            // optional
                      num_img_return_pertag:(NSNumber *)num_img_return_pertag;    // optional


// ReKognition Face Search Function
+ (RKFaceDetectResults *)RKFaceSearch:(UIImage *)image
                                 jobs:(NSString *)jobs                 // optional: "face_search"
                            nameSpace:(NSString *)name_space           // optional
                               userID:(NSString *)user_id              // optional
                           num_return:(NSNumber *)num_return           // optional
                                 tags:(NSArray *)tags;                 // optional
+ (RKFaceDetectResults *)RKFaceSearchWithUrl:(NSURL *)imageUrl
                                        jobs:(NSString *)jobs          // optional: "face_search"
                                   nameSpace:(NSString *)name_space    // optional
                                      userID:(NSString *)user_id       // optional
                                  num_return:(NSNumber *)num_return    // optional
                                        tags:(NSArray *)tags;          // optional


// ReKognition Face Delete Function
+ (RKBaseResults *)RKFaceDelete:(NSString *)tag                  // optional
                     imageIndex:(NSArray *)img_index_array       // optional
                      nameSpace:(NSString *)name_space           // optional
                         userID:(NSString *)user_id;             // optional


// ReKognition Face Rename/Merge/Assign Function
+ (RKBaseResults *)RKFaceRenameOrMergeTag:(NSString *)oldTag
                                  withTag:(NSString *)newTag
                            selectedFaces:(NSArray *)img_index_array     // optional
                                nameSpace:(NSString *)name_space         // optional
                                   userID:(NSString *)user_id;           // optional


// ReKognition Face Stats
+ (RKNameSpaceStatsResults *)RKNameSpaceStats;
+ (RKUserIdStatsResults *)RKUserIdStats:(NSString *)name_space;


// ReKognition Scene Understadning Function
+ (RKSceneUnderstandingResults *)RKSceneUnderstanding:(UIImage *)image;
+ (RKSceneUnderstandingResults *)RKSceneUnderstandingWithUrl:(NSURL *)imageUrl;


@end
