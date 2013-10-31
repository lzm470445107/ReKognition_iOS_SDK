//
//  RKPostJobs.h
//  Rekognition_iOS_SDK
//
//  Created by cys on 7/20/13.
//  Copyright (c) 2013 Orbeus Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ReKognitionSDK : NSObject

// ReKognition Post Jobs Function (to customize your own recognition functions)
+ (NSString*)postReKognitionJobs:(NSDictionary *) jobsDictionary;


// ReKognition Face Detect Function (if not set, jobs is "face_aggressive" by default)
+ (NSString *)RKFaceDetect:(UIImage*)image
                      jobs:(NSString *)jobs;            // optional: "face_aggressive"
+ (NSString *)RKFaceDetectWithUrl:(NSURL *)imageUrl
                             jobs:(NSString *)jobs;     // optional: "face_aggressive"


// ReKognition Face Add Function
+ (NSString *)RKFaceAdd:(UIImage*)image
              nameSpace:(NSString *)name_space          // optional
                 userID:(NSString *)user_id             // optional
                    tag:(NSString *)tag                 // optional
                   jobs:(NSString *)jobs;               // optional: "face_add_aggressive"
+ (NSString *) RKFaceAddWithUrl:(NSURL *)imageUrl
                      nameSpace:(NSString *)name_space  // optional
                         userID:(NSString *)user_id     // optional
                            tag:(NSString *)tag         // optional
                           jobs:(NSString *)jobs;       // optional: "face_add_aggressive"


// ReKognition Face Train Function
+ (NSString *)RKFaceTrain:(NSString *)name_space        // optional
                   userID:(NSString *)user_id           // optional
                     tags:(NSArray *)tags;              // optional


// ReKognition Face Cluster Function
+ (NSString *)RKFaceCluster:(NSString *)name_space      // optional
                     userId:(NSString *)user_id         // optional
             aggressiveness:(NSNumber *)aggressiveness; // optional: 40


// ReKognition Face Crawl Function
+ (NSString *)RKFaceCrawl:(NSString *)fb_id
             access_token:(NSString *)access_token
              crawl_fb_id:(NSArray *)friends_ids
                nameSpace:(NSString *)name_space        // optional
                   userID:(NSString *)user_id;          // optional


// ReKognition Face Recognize Function
+ (NSString *)RKFaceRecognize:(UIImage *)image
                    nameSpace:(NSString *)name_space    // optional
                       userID:(NSString *)user_id       // optional
                         jobs:(NSString *)jobs          // optional: "face_recognize"
                   num_return:(NSNumber *)num_return    // optional: 3
                         tags:(NSArray *)tags;          // optional
+ (NSString *)RKFaceRecognizeWithUrl:(NSURL *)imageUrl
                           nameSpace:(NSString *)name_space     // optional
                              userID:(NSString *)user_id        // optional
                                jobs:(NSString *)jobs           // optional: "face_recognize"
                          num_return:(NSNumber *)num_return     // optional: 3
                                tags:(NSArray *)tags;           // optional


// ReKognition Face Visualize Function
+ (NSString *)RKFaceVisualize:(NSArray *)tags                       // optional
                         jobs:(NSString *)jobs                      // optional: "face_visualize_show_default_tag"
                    nameSpace:(NSString *)name_space                // optional
                       userID:(NSString *)user_id                   // optional
               num_tag_return:(NSNumber *)num_tag_return            // optional
        num_img_return_pertag:(NSNumber *)num_img_return_pertag;    // optional


// ReKognition Face Search Function
+ (NSString *)RKFaceSearch:(UIImage *)image
                      jobs:(NSString *)jobs                 // optional: "face_search"
                 nameSpace:(NSString *)name_space           // optional
                    userID:(NSString *)user_id              // optional
                num_return:(NSNumber *)num_return           // optional
                      tags:(NSArray *)tags;                 // optional
+ (NSString *)RKFaceSearchWithUrl:(NSURL *)imageUrl
                             jobs:(NSString *)jobs          // optional: "face_search"
                        nameSpace:(NSString *)name_space    // optional
                           userID:(NSString *)user_id       // optional
                       num_return:(NSNumber *)num_return    // optional
                             tags:(NSArray *)tags;          // optional


// ReKognition Face Delete Function
+ (NSString *)RKFaceDelete:(NSString *)tag                  // optional
                imageIndex:(NSArray *)img_index_array       // optional
                 nameSpace:(NSString *)name_space           // optional
                    userID:(NSString *)user_id;             // optional


// ReKognition Face Rename/Merge/Assign Function
+ (NSString *)RKFaceRenameOrMergeTag:(NSString *)oldTag
                             withTag:(NSString *)newTag
                       selectedFaces:(NSArray *)img_index_array     // optional
                           nameSpace:(NSString *)name_space         // optional
                              userID:(NSString *)user_id;           // optional


// ReKognition Face Stats
+ (NSString *)RKFaceNameSpaceStats;
+ (NSString *)RKFaceUserIdStats:(NSString *)name_space;


// ReKognition Scene Understadning Function
+ (NSString *)RKSceneUnderstanding:(UIImage *)image;
+ (NSString *)RKSceneUnderstandingWithUrl:(NSURL *)imageUrl;


@end
