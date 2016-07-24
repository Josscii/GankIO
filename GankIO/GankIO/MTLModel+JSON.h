#import <Mantle/Mantle.h>


@interface MTLModel (JSON)

+ (NSArray *)arrayOfModelsWithJSON:(NSArray *)dictionaries;
+ (instancetype)modelWithJSON:(NSDictionary *)JSONdictionary;
+ (instancetype)modelWithJSON:(NSDictionary *)JSONdictionary error:(NSError **)error;

@end
