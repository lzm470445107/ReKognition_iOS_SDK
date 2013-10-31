//
//  ReKognitionResults.h
//  StacheCam
//
//  Created by Yushan on 10/25/13.
//
//

#import <Foundation/Foundation.h>
@class RKRawResponse;
@class RKAPIUsage;
@class RKDetectionResults;
@class RKClusterResults;
@class RKVisualizationResults;
@class RKSearchResults;
@class RKNameSpaceStatsResults;
@class RKFaceUserIdStatsResults;
@class RKSceneUnderstandingResults;

@interface ReKognitionResults : NSObject

+ (RKDetectionResults *) parseDetectionResults: (NSString *) resultString;
+ (RKClusterResults *) parseClusterResults: (NSString *) resultString;
+ (RKVisualizationResults *) parseVisualizationResults: (NSString *) resultString;
+ (RKSearchResults *) parseSearchResults: (NSString *) resultString;
+ (RKNameSpaceStatsResults *) parseNameSpaceStatsResults: (NSString *) resultString;
+ (RKFaceUserIdStatsResults *) parseFaceUserIdStatsResults: (NSString *) resultString;
+ (RKSceneUnderstandingResults *) parseSceneUnderstandingResults: (NSString *) resultString;
- (NSDictionary *) ParseJSONResult:(NSString *)resultString;
@end

@interface RKRawResponse : NSObject
@property (strong, nonatomic) NSDictionary * response;
@property (strong, nonatomic) RKAPIUsage * apiUsage;
@end

@interface RKDetectionResults : RKRawResponse
@property (strong, nonatomic) NSString * url;
@property (strong, nonatomic) NSMutableArray * faceDetection;
@end

@interface RKClusterResults : RKRawResponse
@property (strong, nonatomic) NSMutableArray * faceCluster;
@end

@interface RKVisualizationResults : RKRawResponse
@property (strong, nonatomic) NSMutableArray * faceVisualization;
@end

@interface RKSearchResults : RKRawResponse
@property (strong, nonatomic) NSString * url;
@property (strong, nonatomic) NSMutableArray * faceSearch;
@end

@interface RKNameSpaceStatsResults : RKRawResponse
@property (strong, nonatomic) NSMutableArray * nameSpaceStats;
@end

@interface RKFaceUserIdStatsResults : RKRawResponse
@property (strong, nonatomic) NSMutableArray * faceUserIdStats;
@end

@interface RKSceneUnderstandingResults : RKRawResponse
@property (strong, nonatomic) NSString * url;
@property (strong, nonatomic) NSMutableArray * sceneUnderstanding;
@end

@interface FaceDetection : NSObject
@property (nonatomic) CGRect boundingbox;
@property (strong, nonatomic) NSNumber * confidence;
@property (strong, nonatomic) NSMutableArray * nameMatch;
@property (nonatomic) CGSize ori_img_size;
@property (nonatomic) CGPoint eye_left;
@property (nonatomic) CGPoint eye_right;
@property (nonatomic) CGPoint nose;
@property (nonatomic) CGPoint mouth_l;
@property (nonatomic) CGPoint mouth_r;
@property (strong, nonatomic) NSDictionary * pose;
@property (strong, nonatomic) NSDictionary * emotion;
@property (strong, nonatomic) NSDictionary * race;
@property (strong, nonatomic) NSNumber * smile;
@property (strong, nonatomic) NSNumber * age;
@property (strong, nonatomic) NSNumber * glasses;
@property (strong, nonatomic) NSNumber * eye_closed;
@property (strong, nonatomic) NSNumber * mouth_open_wide;
@property (strong, nonatomic) NSNumber * sex;

@property (strong, nonatomic) NSString * img_index; //obtain when face_add is called
@end

@interface RKAPIUsage : NSObject
@property (strong, nonatomic) NSString * status;
@property (strong, nonatomic) NSNumber * api_id;
@property (strong, nonatomic) NSNumber * quota;
@end

@interface FaceCluster : NSObject
@property (strong, nonatomic) NSString * tag;
@property (strong, nonatomic) NSMutableArray * img_index;
@end

@interface FaceVisualization : NSObject
@property (strong, nonatomic) NSString * tag;
@property (strong, nonatomic) NSString * url;
@property (strong, nonatomic) NSMutableArray * index;
@end

@interface NameMatch : NSObject
@property (strong, nonatomic) NSString * tag;
@property (strong, nonatomic) NSNumber * score;
@end

@interface FaceMatch : NSObject
@property (strong, nonatomic) NSString * tag;
@property (strong, nonatomic) NSString * img_index;
@property (strong, nonatomic) NSNumber * score;
@end

@interface FaceSearch: FaceDetection
@property (strong, nonatomic) FaceMatch * matches;
@end

@interface NameSpaceStats : NSObject
@property (strong, nonatomic) NSString * name_space;
@property (strong, nonatomic) NSNumber * num_user_id;
@property (strong, nonatomic) NSNumber * num_tags;
@property (strong, nonatomic) NSNumber * num_img;
@end

@interface FaceUserIdStats : NSObject
@property (strong, nonatomic) NSString * user_id;
@property (strong, nonatomic) NSNumber * num_tags;
@property (strong, nonatomic) NSNumber * num_img;
@end

@interface SceneUnderstanding : NSObject
@property (strong, nonatomic) NSString * label;
@property (strong, nonatomic) NSNumber * score;
@end

