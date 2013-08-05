Current Version: 1.0
===============================

The folder contains our ReKognition iOS SDKs (ReKognitionSDK.h and ReKognitionSDK.m under folder named SDK) and 
a simple example to demo the SDK. For more information about our ReKognition API, please read our 
<a href="http://v2.rekognition.com/developer/docs">documentation</a>.

The ReKognitionSDK.h and ReKognitionSDK.m files contain the following functions:

// ReKognition Post Jobs Function (to customize your own recognition functions)
<pre><code>+ (NSString*) postReKognitionJobs:(NSDictionary *) jobsDictionary;
</code></pre>

// ReKognition Face Detect Function (the image you want to recognize and the scaling factor for the image)
<pre><code>+ (NSString *) RKFaceDetect: (UIImage*) image
                      scale: (CGFloat) scale;
</code></pre>

// ReKognition Face Add Function
<pre><code>+ (NSString *) RKFaceAdd: (UIImage*) image
                   scale: (CGFloat) scale
               nameSpace: (NSString *) name_space
                  userID: (NSString *) user_id
                     tag: (NSString *) tag;
</code></pre>

// ReKognition Face Train Function
<pre><code>+ (NSString *) RKFaceTrain:(NSString *) name_space
                    userID:(NSString *) user_id;
</code></pre>

// ReKognition Face Recognize Function
<pre><code>+ (NSString *) RKFaceRecognize: (UIImage *) image
                         scale: (CGFloat) scale
                     nameSpace: (NSString *) name_space
                        userID: (NSString *) user_id;
</code></pre>

// ReKognition Face Rename Function
<pre><code>+ (NSString *) RKFaceRename: (NSString *) oldTag
                    withTag: (NSString *) newTag
                  nameSpace: (NSString *) name_space
                     userID: (NSString *) user_id;
</code></pre>

// ReKognition Face Crawl Function
<pre><code>+ (NSString *) RKFaceCrawl: (NSString *) access_token
                 nameSpace: (NSString *) name_space
                    userID: (NSString *) user_id
               crawl_fb_id: (NSArray *) crawl_fb_id_array
                     fb_id: (NSString *) fb_id;
</code></pre>

// ReKognition Face Visualize Function
<pre><code>+ (NSString *) RKFaceVisualize: (NSArray *) tag_array
                     nameSpace: (NSString *) name_space
                        userID: (NSString *) user_id;
</code></pre>

// ReKognition Face Search Function
<pre><code>+ (NSString *) RKFaceSearch: (UIImage *) image
                      scale: (CGFloat) scale
                  nameSpace: (NSString *) name_space
                     userID: (NSString *) user_id;
</code></pre>

// ReKognition Face Delete Function
<pre><code>+ (NSString *) RKFaceDelete: (NSString *) tag
                 imageIndex: (NSArray *) img_index_array
                  nameSpace: (NSString *) name_space
                     userID: (NSString *) user_id;
</code></pre>

// ReKognition Scene Understadning Function
<pre><code>+ (NSString *) RKSceneUnderstanding: (UIImage *) image
                              scale: (CGFloat) scale;
</code></pre>

Configuration:
===============================

(a) Click <a href="http://v2.rekognition.com/user/create">here</a> to register a ReKognition account, and you will receive the API key and secret by email.

(b) Use your own API Key and Secret in RekognitionSDK.m
 
<pre><code>static NSString *API_Key = @"YOUR_API_KEY";
static NSString *API_Secret = @"YOUR_API_SECRET";
</code></pre>
                              
The ReKo SDK example: 
===============================

(a) Select a photo from the album or take a picture using the camera; 

(b) Recognize the image using the our face detection and scene understanding functions;

Notes: 

(a) When processing photo taken by the back camera, it might take a while since the image is not resized (in the to-do list)

(b) The iPad version is still under construction

For any questions, please contact eng@orbe.us
