//
//  QCloudLogModel.m
//  Pods
//
//  Created by Dong Zhao on 2017/3/15.
//
//

#import "QCloudLogModel.h"




@implementation QCloudLogModel
///--------------------------------------
#pragma mark - Logging Messages
///--------------------------------------
+ (NSString *)_descriptionForLogLevel:(QCloudLogLevel)logLevel {
    NSString *description = nil;
    switch (logLevel) {
        case QCloudLogLevelNone:
            break;
        case QCloudLogLevelDebug:
            description = @"Debug";
            break;
        case QCloudLogLevelError:
            description = @"Error";
            break;
        case QCloudLogLevelWarning:
            description = @"Warning";
            break;
        case QCloudLogLevelInfo:
            description = @"Info";
            break;
        case QCloudLogLevelVerbose:
            description = @"Verbose";
            break;
    }
    return description;
}

- (NSString*) debugDescription
{
    static BOOL willOutputColor = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        char* xcodeColor = getenv("XcodeColors");
        if (xcodeColor && (strcmp(xcodeColor, "YES") == 0))
        {
            willOutputColor = YES;
            setenv("XcodeColors", "YES", 0);
        }
    });
    NSString* description;
    if (willOutputColor) {
        description = [NSMutableString stringWithFormat:@"%@[%@]%@%@",[QCloudLogModel consoleLogColorWithLevel:self.level],[QCloudLogModel _descriptionForLogLevel:self.level],[QCloudLogModel consoleLogColorWithLevel:self.level],self.message];
    } else {
         description = [NSMutableString stringWithFormat:@"[%@]%@",[QCloudLogModel _descriptionForLogLevel:self.level],self.message];
    }
    return description;
}

+ (NSString*) consoleLogColorWithLevel:(QCloudLogLevel)level
{
    switch (level) {
        case QCloudLogLevelInfo:
            return @"🔷";
        case QCloudLogLevelNone:
            return @"";
        case QCloudLogLevelDebug:
            return @"◾️ ";
        case QCloudLogLevelError:
            return @"🛑";
        case QCloudLogLevelWarning:
            return @"🔶";
        default:
            break;
    }
    return @"";
}

+ (NSString*) consoleRestLogColorWithLevel:(QCloudLogLevel)level
{
    switch (level) {
        case QCloudLogLevelInfo:
            return @"\033[fg0,0,0;\033[bg255,255,255;";
        case QCloudLogLevelNone:
            return @"\033[fg0,0,0;\033[bg255,255,255;";
        case QCloudLogLevelDebug:
            return @"\033[fg0,0,0;\033[bg255,255,255;";
        case QCloudLogLevelError:
            return @"\033[fg0,0,0;\033[bg200,0,0;";
        case QCloudLogLevelWarning:
            return @"\033[fg0,0,0;\033[bg100,100,100;";
        default:
            break;
    }
    return @"";
}
- (NSString*) fileLogColorWithLevel:(QCloudLogLevel)level
{
    switch (level) {
        case QCloudLogLevelInfo:
            return @"\e[38;5;38;82m";
        case QCloudLogLevelNone:
            return @"\e[0m";
        case QCloudLogLevelDebug:
            return @"\e[30;48;5;50m";
        case QCloudLogLevelError:
            return @"\e[41;41;41;256m";
        case QCloudLogLevelWarning:
            return @"\e[38;5;251;203m";
        default:
            break;
    }
    return @"";
}
- (NSString*) fileDescription
{
    NSString* color = [self fileLogColorWithLevel:self.level];
    NSMutableString* log = [NSMutableString new];
    [log appendString:color];
    [log appendFormat:@"[%@]", self.date];
    [log appendFormat:@"[%@]" , [QCloudLogModel _descriptionForLogLevel:self.level]];
    [log appendString:@"\e[0m"];
    if (self.file.length) {
        [log appendFormat:@"[%@]", [self.file componentsSeparatedByString:@"/"].lastObject];
    }
    if (self.funciton.length) {
        [log appendFormat:@"[%@]", self.funciton];
    }
    if (self.line > 0) {
        [log appendFormat:@"[%d]",self.line];
    }
    [log appendString:self.message];
    return log;
}

@end
