# Current Version: 2.0

### Updates:

1. Implemented [FaceThumbnailCropper][1] and [UIImageRotationFixer][2] that serve as helper classes for [ReKognitionSDK][3].

   [FaceThumbnailCropper][1] crops face thumbnails out of the raw image, merges thumbnails into a single compressed image, and serves that image as the source for ReKognition API.

   [UIImageRotationFixer][2] rotates the underlining CGImageRef of an UIImage to its up un-mirrored position. It is used to correct the source images whose orientation is other than upwards, like images taken from camera roll.

2. [ReKognitionResults][4] provides data classes and parsing methods for ReKognition API response.

[1]: https://github.com/orbeus/ReKognition_iOS_SDK/blob/master/Rekognition_iOS_SDK/SDK/FaceThumbnailCropper.h
[2]: https://github.com/orbeus/ReKognition_iOS_SDK/blob/master/Rekognition_iOS_SDK/SDK/UIImageRotationFixer.h
[3]: https://github.com/orbeus/ReKognition_iOS_SDK/blob/master/Rekognition_iOS_SDK/SDK/ReKognitionSDK.h
[4]: https://github.com/orbeus/ReKognition_iOS_SDK/blob/master/Rekognition_iOS_SDK/SDK/ReKognitionResults.h

-----------------------------
This ReKognition iOS SDK is intent for developers who want to integrate ReKognition API into their 
iOS applications. The folder contains our ReKognition iOS SDKs (ReKognitionSDK.h and ReKognitionSDK.m under folder named SDK) and 
a simple example to demo the SDK. For more information about our ReKognition API, please read our 
[documentation](http://v2.rekognition.com/developer/docs).

[ReKognitionSDK][3] class contain the following functions:

To customize your own recognition functions:
```objective-c
+ (NSData *)postReKognitionJobs:(NSDictionary *)jobsDictionary;
```

ReKognition [Face Detect](http://rekognition.com/developer/docs#facedetect) Function (if not set, jobs is `face_aggressive` by default)
```objective-c
+ (RKFaceDetectResults *)RKFaceDetect:(UIImage*)image
                                 jobs:(NSString *)jobs;            // optional: "face_aggressive"
+ (RKFaceDetectResults *)RKFaceDetectWithUrl:(NSURL *)imageUrl
                                        jobs:(NSString *)jobs;     // optional: "face_aggressive"
```

ReKognition [Face Add](http://rekognition.com/developer/docs#faceadd) Function
```objective-c
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
```

ReKognition [Face Train](http://rekognition.com/developer/docs#facetrain) Function
```objective-c
+ (RKBaseResults *)RKFaceTrain:(NSString *)name_space        // optional
                        userID:(NSString *)user_id           // optional
                          tags:(NSArray *)tags;              // optional
```

ReKognition [Face Cluster](http://rekognition.com/developer/docs#facecluster) Function
```objective-c
+ (RKFaceClusterResults *)RKFaceCluster:(NSString *)name_space      // optional
                                 userId:(NSString *)user_id         // optional
                         aggressiveness:(NSNumber *)aggressiveness; // optional: 40
```

ReKognition [Face Crawl](http://rekognition.com/developer/docs#facecrawl) Function
```objective-c
+ (RKFaceCrawlResults *)RKFaceCrawl:(NSString *)fb_id
                       access_token:(NSString *)access_token
                        crawl_fb_id:(NSArray *)friends_ids
                          nameSpace:(NSString *)name_space        // optional
                             userID:(NSString *)user_id;          // optional
```

ReKognition [Face Recognize](http://rekognition.com/developer/docs#facerecognize) Function
```objective-c
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
```

ReKognition [Face Visualize](http://rekognition.com/developer/docs#facevirtualize) Function
```objective-c
+ (RKFaceVisualizeResults *)RKFaceVisualize:(NSArray *)tags                       // optional
                                       jobs:(NSString *)jobs                      // optional: "face_visualize_show_default_tag"
                                  nameSpace:(NSString *)name_space                // optional
                                     userID:(NSString *)user_id                   // optional
                             num_tag_return:(NSNumber *)num_tag_return            // optional
                      num_img_return_pertag:(NSNumber *)num_img_return_pertag;    // optional
```

ReKognition [Face Search](http://rekognition.com/developer/docs#facesearch) Function
```objective-c
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
```

ReKognition [Face Delete](http://rekognition.com/developer/docs#facedelete) Function
```objective-c
+ (RKBaseResults *)RKFaceDelete:(NSString *)tag                  // optional
                     imageIndex:(NSArray *)img_index_array       // optional
                      nameSpace:(NSString *)name_space           // optional
                         userID:(NSString *)user_id;             // optional
```

ReKognition [Face Rename](http://rekognition.com/developer/docs#facerename) Function
```objective-c
+ (RKBaseResults *)RKFaceRenameOrMergeTag:(NSString *)oldTag
                                  withTag:(NSString *)newTag
                            selectedFaces:(NSArray *)img_index_array     // optional
                                nameSpace:(NSString *)name_space         // optional
                                   userID:(NSString *)user_id;           // optional
```

ReKognition [Face Stats](http://rekognition.com/developer/docs#facestats) Function
```objective-c
+ (RKNameSpaceStatsResults *)RKNameSpaceStats;

+ (RKUserIdStatsResults *)RKUserIdStats:(NSString *)name_space;
```

ReKognition [Scene Understadning](http://rekognition.com/developer/docs#scenecatagorize) Function
```objective-c
+ (RKSceneUnderstandingResults *)RKSceneUnderstanding:(UIImage *)image;

+ (RKSceneUnderstandingResults *)RKSceneUnderstandingWithUrl:(NSURL *)imageUrl;
```

### Configuration:
1. Click [here](http://v2.rekognition.com/user/create) to register a ReKognition account, and you will receive the API key and secret by email.

2. Use your own API Key and Secret in [RekognitionSDK][3].

```objective-c 
static NSString *API_Key = @"YOUR_API_KEY";
static NSString *API_Secret = @"YOUR_API_SECRET";
```

### Demo: 
This demo app allows you to perform the following tasks:

* Select a photo from the album or take a picture using the camera;

* Recognize the image using the our face detection and scene understanding functions;

Notes: the demo app shows the proper usage of [FaceThumbnailCropper][1] and [UIImageRotationFixer][2] helper classes.

For any questions, please contact eng@orbe.us
