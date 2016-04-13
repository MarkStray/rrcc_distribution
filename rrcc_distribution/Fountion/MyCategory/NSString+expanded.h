//
//  StringRef.h
//  beta1
//
typedef enum {
    imageSmallType,
    imageMiddlType,
    imageBigType,
}imageType;
#import <Foundation/Foundation.h>

@interface NSString(expanded) 

-(NSString*)replaceControlString;
-(NSString*)imagePathType:(imageType)__type;

- (NSString *)indentLength:(CGFloat)_len font:(UIFont *)_font;
- (BOOL)notEmptyOrNull;
+ (NSString *)replaceEmptyOrNull:(NSString *)checkString;
-(NSString*)replaceTime;
-(NSString*)replaceStoreKey;
- (NSString*)soapMessage:(NSString *)key,...;
- (NSString *)md5;


@end
