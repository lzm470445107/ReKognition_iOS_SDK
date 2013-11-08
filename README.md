Current Version: 2.0
===============================
Updates:
<ol>
<li>
Implemented FaceThumbnailCropper and UIImageRotationFixer that serve as helper classes that work with ReKognitionSDK.<br>
FaceThumbnailCropper crops face thumbnails out of the raw image, merges thumbnails into a single compressed image, and serves that image as the source for ReKognition API.<br>
UIImageRotationFixer rotates the underlining CGImageRef of an UIImage to its up un-mirrored position. It is used to correct the source images whose orientation is other than upwards, like images taken from camera roll.
</li>
<li>
ReKognitionResults provides data classes and parsing methods for ReKognition API response.
</li>
</ol>
===============================

This ReKognition iOS SDK is intent for developers who want to integrate ReKognition API into their 
iOS applications. The folder contains our ReKognition iOS SDKs (ReKognitionSDK.h and ReKognitionSDK.m under folder named SDK) and 
a simple example to demo the SDK. For more information about our ReKognition API, please read our 
<a href="http://v2.rekognition.com/developer/docs">documentation</a>.

The ReKognitionSDK.h and ReKognitionSDK.m files contain the following functions:

// ReKognition Post Jobs Function (to customize your own recognition functions)
<pre><code>+ (NSData *)postReKognitionJobs:(NSDictionary *)jobsDictionary;
</code></pre>

// ReKognition Face Detect Function (if not set, jobs is "face_aggressive" by default)
<pre><code>+ (RKFaceDetectResults *)RKFaceDetect:(UIImage*)image
                                 jobs:(NSString *)jobs;            // optional: "face_aggressive"
+ (RKFaceDetectResults *)RKFaceDetectWithUrl:(NSURL *)imageUrl
                                        jobs:(NSString *)jobs;     // optional: "face_aggressive"
</code></pre>

// ReKognition Face Add Function
<pre><code>+ (RKFaceDetectResults *)RKFaceAdd:(UIImage*)image
                         nameSpace:(NSString *)name_space          // optional
                            userID:(NSString *)user_id             // optional
                               tag:(NSString *)tag                 // optional
                              jobs:(NSString *)jobs;               // optional: "face_add"
+ (RKFaceDetectResults *)RKFaceAddWithUrl:(NSURL *)imageUrl
                                nameSpace:(NSString *)name_space  // optional
                                   userID:(NSString *)user_id     // optional
                                      tag:(NSString *)tag         // optional
                                     jobs:(NSString *)jobs;       // optional: "face_add"
</code></pre>

// ReKognition Face Train Function
<pre><code>+ (RKBaseResults *)RKFaceTrain:(NSString *)name_space        // optional
                        userID:(NSString *)user_id           // optional
                          tags:(NSArray *)tags;              // optional
</code></pre>

// ReKognition Face Cluster Function
<pre><code>+ (RKFaceClusterResults *)RKFaceCluster:(NSString *)name_space      // optional
                                 userId:(NSString *)user_id         // optional
                         aggressiveness:(NSNumber *)aggressiveness; // optional: 40
</code></pre>

// ReKognition Face Crawl Function
<pre><code>+ (RKFaceCrawlResults *)RKFaceCrawl:(NSString *)fb_id
                       access_token:(NSString *)access_token
                        crawl_fb_id:(NSArray *)friends_ids
                          nameSpace:(NSString *)name_space        // optional
                             userID:(NSString *)user_id;          // optional
</code></pre>

// ReKognition Face Recognize Function
<pre><code>+ (RKFaceDetectResults *)RKFaceRecognize:(UIImage *)image
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
</code></pre>

// ReKognition Face Visualize Function
<pre><code>+ (RKFaceVisualizeResults *)RKFaceVisualize:(NSArray *)tags                       // optional
                                       jobs:(NSString *)jobs                      // optional: "face_visualize_show_default_tag"
                                  nameSpace:(NSString *)name_space                // optional
                                     userID:(NSString *)user_id                   // optional
                             num_tag_return:(NSNumber *)num_tag_return            // optional
                      num_img_return_pertag:(NSNumber *)num_img_return_pertag;    // optional
</code></pre>

// ReKognition Face Search Function
<pre><code>+ (RKFaceDetectResults *)RKFaceSearch:(UIImage *)image
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
</code></pre>

// ReKognition Face Delete Function
<pre><code>+ (RKBaseResults *)RKFaceDelete:(NSString *)tag                  // optional
                     imageIndex:(NSArray *)img_index_array       // optional
                      nameSpace:(NSString *)name_space           // optional
                         userID:(NSString *)user_id;             // optional
</code></pre>

// ReKognition Face Rename/Merge/Assign Function
<pre><code>+ (RKBaseResults *)RKFaceRenameOrMergeTag:(NSString *)oldTag
                                  withTag:(NSString *)newTag
                            selectedFaces:(NSArray *)img_index_array     // optional
                                nameSpace:(NSString *)name_space         // optional
                                   userID:(NSString *)user_id;           // optional
</code></pre>

// ReKognition Face Stats
<pre><code>+ (RKNameSpaceStatsResults *)RKNameSpaceStats;
+ (RKUserIdStatsResults *)RKUserIdStats:(NSString *)name_space;
</code></pre>

// ReKognition Scene Understadning Function
<pre><code>+ (RKSceneUnderstandingResults *)RKSceneUnderstanding:(UIImage *)image;
+ (RKSceneUnderstandingResults *)RKSceneUnderstandingWithUrl:(NSURL *)imageUrl;
</code></pre>

Configuration:
===============================
<ol>
<li> Click <a href="http://v2.rekognition.com/user/create">here</a> to register a ReKognition account, and you will receive the API key and secret by email.</li>

<li> Use your own API Key and Secret in RekognitionSDK.m</li>
 
<pre><code>static NSString *API_Key = @"YOUR_API_KEY";
static NSString *API_Secret = @"YOUR_API_SECRET";
</code></pre>

</ol>


Example: 
===============================
This demo allows you to perform the following tasks:
<ol>
<li> Select a photo from the album or take a picture using the camera; </li> 

<li> Recognize the image using the our face detection and scene understanding functions;</li> 
</ol>

Notes: 

<ul>
<li> When processing photo taken by the back camera, it might take a while since the image is not resized (in the to-do list)
</li>
<li> The iPad version is still under construction
</li>
</ul>

For any questions, please contact eng@orbe.us
