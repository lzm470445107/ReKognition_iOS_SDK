ReKognition_iOS_SDK
===================

The folder contains our iOS SDKs (folder named SDK) and a simple example to demo the SDK.

1. The SDK contains the following functions:

// ReKognition Post Jobs Function (to customize your own recognition functions)
+ (NSString*) postReKognitionJobs:(NSDictionary *) jobsDictionary;

// ReKognition Face Detect Function (the image you want to recognize and the scaling factor for the image)
+ (NSString *) RKFaceDetect: (UIImage*) image
                      scale: (CGFloat) scale;

// ReKognition Face Add Function
+ (NSString *) RKFaceAdd: (UIImage*) image
                   scale: (CGFloat) scale
               nameSpace: (NSString *) name_space
                  userID: (NSString *) user_id
                     tag: (NSString *) tag;

// ReKognition Face Train Function
+ (NSString *) RKFaceTrain:(NSString *) name_space
                    userID:(NSString *) user_id;

// ReKognition Face Recognize Function
+ (NSString *) RKFaceRecognize: (UIImage *) image
                         scale: (CGFloat) scale
                     nameSpace: (NSString *) name_space
                        userID: (NSString *) user_id;

// ReKognition Face Rename Function
+ (NSString *) RKFaceRename: (NSString *) oldTag
                    withTag: (NSString *) newTag
                  nameSpace: (NSString *) name_space
                     userID: (NSString *) user_id;

// ReKognition Face Crawl Function
+ (NSString *) RKFaceCrawl: (NSString *) access_token
                 nameSpace: (NSString *) name_space
                    userID: (NSString *) user_id
               crawl_fb_id: (NSArray *) crawl_fb_id_array
                     fb_id: (NSString *) fb_id;

// ReKognition Face Visualize Function
+ (NSString *) RKFaceVisualize: (NSArray *) tag_array
                     nameSpace: (NSString *) name_space
                        userID: (NSString *) user_id;

// ReKognition Face Search Function
+ (NSString *) RKFaceSearch: (UIImage *) image
                      scale: (CGFloat) scale
                  nameSpace: (NSString *) name_space
                     userID: (NSString *) user_id;

// ReKognition Face Delete Function
+ (NSString *) RKFaceDelete: (NSString *) tag
                 imageIndex: (NSArray *) img_index_array
                  nameSpace: (NSString *) name_space
                     userID: (NSString *) user_id;

// ReKognition Scene Understadning Function
+ (NSString *) RKSceneUnderstanding: (UIImage *) image
                              scale: (CGFloat) scale;


                              
2. The example allows the users to 
a. select a photo from the album or take a picture using the camera; 
b. recognize the image using the our face detection and scene understanding functions;

Notes: 
a. when processing photo taken by the back camera, it might take a while since the image is not resized (in the to-do list)
b. still working on the iPad version

