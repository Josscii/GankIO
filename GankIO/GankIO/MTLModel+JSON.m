#import <Mantle/Mantle.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation MTLModel (JSON)

+ (NSArray *)arrayOfModelsWithJSON:(NSArray *)dictionaries {
    return [[dictionaries.rac_sequence map:^id(id value) {
        return [self modelWithJSON:(NSDictionary *)value];
    }] array];
}

+ (instancetype)modelWithJSON:(NSDictionary *)JSONdictionary {
    NSError *error = nil;
    id instance = [self modelWithJSON:JSONdictionary error:&error];
    if (!instance && error) {
        [NSException raise:@"Error creating instance from JSON" format:@"%@", error];
    }
    return instance;
}

+ (instancetype)modelWithJSON:(NSDictionary *)JSONdictionary error:(NSError **)error {
    id initialObject = [MTLJSONAdapter modelOfClass:self fromJSONDictionary:JSONdictionary error:error];
    return initialObject;
}

@end
