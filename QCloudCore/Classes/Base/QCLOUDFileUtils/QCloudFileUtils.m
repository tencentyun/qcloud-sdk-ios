//
//  QCloudFileUtils.m
//  Pods
//
//  Created by stonedong on 16/3/6.
//
//

#import "QCloudFileUtils.h"
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "QCloudSHAPart.h"

void QCloudEnsurePathExist(NSString *path) {
    NSCParameterAssert(path);
    BOOL exist = [NSShareFileManager fileExistsAtPath:path];
    if (!exist) {
        NSError *error = nil;
        [NSShareFileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    }
}

BOOL QCloudFileExist(NSString *path) {
    return [NSShareFileManager fileExistsAtPath:path];
}

NSString *QCloudApplicationDocumentsPath() {
    static NSString *documentsPath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *urls = [NSShareFileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        NSURL *url = urls[0];
        documentsPath = [url path];
    });
    return documentsPath;
}

NSString *QCloudApplicationLibaryPath() {
    static NSString *documentsPath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *urls = [NSShareFileManager URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask];
        NSURL *url = urls[0];
        documentsPath = [url path];
    });
    return documentsPath;
}

NSString *QCloudApplicationDirectory() {
    static NSString *documentsPath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *urls = [NSShareFileManager URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask];
        NSURL *url = urls[0];
        documentsPath = [url path];
        documentsPath = [documentsPath stringByDeletingLastPathComponent];
    });
    return documentsPath;
}
NSString *QCloudApplicationTempPath() {
    return NSTemporaryDirectory();
}
NSString *QCloudCacheDir() {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    return cachePath;
}

NSString *QCloudDocumentsPath() {
    static NSString *documentsPath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *urls = [NSShareFileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        NSURL *url = urls[0];
        documentsPath = [url path];
        documentsPath = [documentsPath stringByAppendingPathComponent:@"MainData"];
        QCloudEnsurePathExist(documentsPath);
    });
    return documentsPath;
}

NSString *QCloudSettingsFilePath() {
    return [QCloudDocumentsPath() stringByAppendingPathComponent:@"settings.plist"];
}

NSString *QCloudAppendPath(NSString *parentPath, NSString *sub) {
    NSString *str = [parentPath stringByAppendingPathComponent:sub];
    QCloudEnsurePathExist(str);
    return str;
}

NSString *QCloudTempDir() {
    return NSTemporaryDirectory();
}

NSString *QCloudMKTempDirectory() {
    NSString *path = [[NSUUID UUID] UUIDString];
    return QCloudAppendPath(QCloudTempDir(), path);
}

NSString *QCloudDocumentsSubPath(NSString *str) {
    return QCloudAppendPath(QCloudDocumentsPath(), str);
}

NSString *QCloudPathJoin(NSString *base, NSString *component) {
    NSCParameterAssert(component);
    if ([base hasSuffix:@"/"]) {
        if ([component hasPrefix:@"/"] && base.length) {
            return [[base substringToIndex:base.length - 1] stringByAppendingString:component];
        } else {
            return [base stringByAppendingString:component];
        }
    } else {
        if (component.length) {
            if ([component hasPrefix:@"/"]) {
                return [base stringByAppendingFormat:@"%@", component];
            } else {
                return [base stringByAppendingFormat:@"/%@", component];
            }
        } else {
            return base;
        }
    }
}

NSString *QCloudTempFilePathWithExtension(NSString *extension) {
    NSString *fileName = [NSUUID UUID].UUIDString;
    NSString *path = QCloudTempDir();
    path = [path stringByAppendingPathComponent:fileName];
    path = [path stringByAppendingPathExtension:extension];
    return path;
}

NSString *QCloudDocumentsTempPath() {
    NSString *path = QCloudPathJoin(QCloudDocumentsPath(), @"temp");
    QCloudEnsurePathExist(path);
    return path;
}

NSString *QCloudDocumentsTempFile(NSString *fileName, NSString *extension) {
    NSString *path = QCloudDocumentsPath();
    path = [path stringByAppendingPathComponent:fileName];
    if (extension) {
        path = [path stringByAppendingPathExtension:extension];
    }
    return path;
}

NSString *QCloudDocumentsTempFilePathWithExcentsion(NSString *extension) {
    NSString *fileName = [NSUUID UUID].UUIDString;
    NSString *path = QCloudDocumentsPath();
    path = [path stringByAppendingPathComponent:fileName];
    if (extension) {
        path = [path stringByAppendingPathExtension:extension];
    }
    return path;
}
void QCloudRemoveFileByPath(NSString *path) {
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
}

NSString *QCloudFileInSubPath(NSString *subPath, NSString *fileName) {
    NSString *sp = QCloudDocumentsSubPath(subPath);
    QCloudEnsurePathExist(sp);
    return [sp stringByAppendingPathComponent:fileName];
}

BOOL QCloudMoveFile(NSString *originPath, NSString *aimPath, NSError *__autoreleasing *error) {
    return [[NSFileManager defaultManager] moveItemAtPath:originPath toPath:aimPath error:error];
}

uint64_t QCloudDirectorySize(NSString *path, NSFileManager *fileManager) {
    BOOL isDirectory = NO;
    BOOL exist = [fileManager fileExistsAtPath:path isDirectory:&isDirectory];
    if (!exist) {
        return 0;
    }

    if (!isDirectory) {
        return 0;
    }

    uint64_t totalSize = 0;

    NSDirectoryEnumerator *itor = [fileManager enumeratorAtPath:path];
    NSString *file;
    while (file = [itor nextObject]) {
        BOOL isD;
        BOOL isE;
        NSString *checkPath = [path stringByAppendingPathComponent:file];
        isE = [fileManager fileExistsAtPath:checkPath isDirectory:&isD];
        if (isE && !isD) {
            NSError *error;
            NSDictionary *attributes = [fileManager attributesOfItemAtPath:checkPath error:&error];
            if (!error && attributes) {
                totalSize += [attributes fileSize];
            }
        }
    }
    return totalSize;
}

NSString *QCloudFilteLocalPath(NSString *originPath) {
    if (!originPath || originPath.length < QCloudApplicationDirectory().length) {
        return originPath;
    }
    NSRange range = [originPath rangeOfString:QCloudApplicationDirectory()];
    if (range.location != NSNotFound) {
        return [originPath substringFromIndex:range.location + range.length];
    }
    return originPath;
}

NSString *QCloudGenerateLocalPath(NSString *pathCompents) {
    return [QCloudApplicationDirectory() stringByAppendingPathComponent:pathCompents];
}

NSURL *QCloudMediaURL(NSString *path) {
    if ([path hasPrefix:@"http"]) {
        return [NSURL URLWithString:path];
    } else {
        return [NSURL fileURLWithPath:QCloudGenerateLocalPath(path)];
    }
}

uint64_t QCloudFileSize(NSString *path) {
    if (path.length == 0) {
        return 0;
    }
    BOOL isDirectory = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory]) {
        if (isDirectory) {
            return 0;
        }
        NSDictionary *attribute = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        return [attribute fileSize];
    }
    return 0;
}

NSArray<QCloudSHAPart *> *QCloudIncreaseFileSHAData(NSString *path, uint64_t sliceSize) {
    NSURL *fileURL = [NSURL fileURLWithPath:path];

    if (fileURL == nil) {
        return nil;
    }
    sliceSize = MIN(QCloudFileSize(path), sliceSize);
    if (sliceSize == 0) {
        return nil;
    }
#ifdef DEBUG
    CFTimeInterval beginTime = CFAbsoluteTimeGetCurrent();
#endif
    NSInputStream *stream = [NSInputStream inputStreamWithURL:fileURL];
    [stream open];
    NSMutableArray *arr = [NSMutableArray new];
    CC_SHA1_CTX sha;
    CC_SHA1_Init(&sha);
    BOOL done = NO;
    int64_t totalData = 0;
    int64_t offset = 0;
    while (!done) {
        @autoreleasepool {
            if (![stream hasBytesAvailable]) {
                [stream close];
                break;
            }
            uint64_t partNeedLoad = sliceSize;
            uint64_t partLength = 0;
            while (partNeedLoad > 0 && [stream hasBytesAvailable]) {
#define READ_SLICE_SIZE 1024 * 10
                uint8_t *buffer = malloc(READ_SLICE_SIZE * sizeof(uint8_t));
                memset(buffer, 0, READ_SLICE_SIZE);
                NSUInteger willReadMaxLength = (NSUInteger)MIN(READ_SLICE_SIZE, partNeedLoad);
                NSInteger readLength = [stream read:buffer maxLength:willReadMaxLength];
                if (readLength <= 0) {
                    free(buffer);
                    break;
                }
                CC_SHA1_Update(&sha, buffer, (unsigned int)readLength);
                partNeedLoad -= readLength;
                partLength += readLength;
                free(buffer);
            }
            if (partLength == 0) {
                done = YES;
                break;
            }
            QCloudSHAPart *part = [[QCloudSHAPart alloc] init];
            part.offset = offset;
            part.datalen = partLength;
            offset += partLength;
            totalData += partLength;
            unsigned char *digest = (unsigned char *)&sha.h0;
            NSString *result = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                                                          digest[0], digest[1], digest[2], digest[3], digest[4], digest[5], digest[6], digest[7],
                                                          digest[8], digest[9], digest[10], digest[11], digest[12], digest[13], digest[14],
                                                          digest[15], digest[16], digest[17], digest[18], digest[19]];
            part.datasha = result;
            [arr addObject:part];
        }
    }
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1_Final(digest, &sha);

    NSString *result =
        [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", digest[0], digest[1],
                                   digest[2], digest[3], digest[4], digest[5], digest[6], digest[7], digest[8], digest[9], digest[10], digest[11],
                                   digest[12], digest[13], digest[14], digest[15], digest[16], digest[17], digest[18], digest[19]];
    QCloudSHAPart *part = [[QCloudSHAPart alloc] init];
    part.offset = 0;
    part.datalen = totalData;
    part.datasha = result;
    [arr addObject:part];
#ifdef DEBUG
    NSLog(@"sh1 time is %f", CFAbsoluteTimeGetCurrent() - beginTime);
#endif
    return arr;
}

NSString *detemineFileMemeType(NSURL *filePathURL, NSString *fileName) {
    NSDictionary *mimeMap = @ {
        @"aw" : @"application/applixware",
        @"atom" : @"application/atom+xml",
        @"atomcat" : @"application/atomcat+xml",
        @"atomsvc" : @"application/atomsvc+xml",
        @"ccxml" : @"application/ccxml+xml",
        @"cdmia" : @"application/cdmi-capability",
        @"cdmic" : @"application/cdmi-container",
        @"cdmid" : @"application/cdmi-domain",
        @"cdmio" : @"application/cdmi-object",
        @"cdmiq" : @"application/cdmi-queue",
        @"cu" : @"application/cu-seeme",
        @"davmount" : @"application/davmount+xml",
        @"dssc" : @"application/dssc+der",
        @"xdssc" : @"application/dssc+xml",
        @"es" : @"application/ecmascript",
        @"emma" : @"application/emma+xml",
        @"epub" : @"application/epub+zip",
        @"exi" : @"application/exi",
        @"pfr" : @"application/font-tdpfr",
        @"stk" : @"application/hyperstudio",
        @"ipfix" : @"application/ipfix",
        @"jar" : @"application/java-archive",
        @"ser" : @"application/java-serialized-object",
        @"class" : @"application/java-vm",
        @"js" : @"application/javascript",
        @"json" : @"application/json",
        @"hqx" : @"application/mac-binhex40",
        @"cpt" : @"application/mac-compactpro",
        @"mads" : @"application/mads+xml",
        @"mrc" : @"application/marc",
        @"mrcx" : @"application/marcxml+xml",
        @"ma" : @"application/mathematica",
        @"mathml" : @"application/mathml+xml",
        @"mbox" : @"application/mbox",
        @"mscml" : @"application/mediaservercontrol+xml",
        @"meta4" : @"application/metalink4+xml",
        @"mets" : @"application/mets+xml",
        @"mods" : @"application/mods+xml",
        @"m21" : @"application/mp21",
        @"mp4" : @"video/mp4",
        @"doc" : @"application/msword",
        @"mxf" : @"application/mxf",
        @"bin" : @"application/octet-stream",
        @"oda" : @"application/oda",
        @"opf" : @"application/oebps-package+xml",
        @"ogx" : @"application/ogg",
        @"onetoc" : @"application/onenote",
        @"xer" : @"application/patch-ops-error+xml",
        @"pdf" : @"application/pdf",
        @"pgp" : @"application/pgp-signature",
        @"prf" : @"application/pics-rules",
        @"p10" : @"application/pkcs10",
        @"p7m" : @"application/pkcs7-mime",
        @"p7s" : @"application/pkcs7-signature",
        @"p8" : @"application/pkcs8",
        @"ac" : @"application/pkix-attr-cert",
        @"cer" : @"application/pkix-cert",
        @"crl" : @"application/pkix-crl",
        @"pkipath" : @"application/pkix-pkipath",
        @"pki" : @"application/pkixcmp",
        @"pls" : @"application/pls+xml",
        @"ai" : @"application/postscript",
        @"cww" : @"application/prs.cww",
        @"pskcxml" : @"application/pskc+xml",
        @"rdf" : @"application/rdf+xml",
        @"rif" : @"application/reginfo+xml",
        @"rnc" : @"application/relax-ng-compact-syntax",
        @"rl" : @"application/resource-lists+xml",
        @"rld" : @"application/resource-lists-diff+xml",
        @"rs" : @"application/rls-services+xml",
        @"rsd" : @"application/rsd+xml",
        @"rss" : @"application/rss+xml",
        @"rtf" : @"application/rtf",
        @"sbml" : @"application/sbml+xml",
        @"scq" : @"application/scvp-cv-request",
        @"scs" : @"application/scvp-cv-response",
        @"spq" : @"application/scvp-vp-request",
        @"spp" : @"application/scvp-vp-response",
        @"sdp" : @"application/sdp",
        @"setpay" : @"application/set-payment-initiation",
        @"setreg" : @"application/set-registration-initiation",
        @"shf" : @"application/shf+xml",
        @"smi" : @"application/smil+xml",
        @"rq" : @"application/sparql-query",
        @"srx" : @"application/sparql-results+xml",
        @"gram" : @"application/srgs",
        @"grxml" : @"application/srgs+xml",
        @"sru" : @"application/sru+xml",
        @"ssml" : @"application/ssml+xml",
        @"tei" : @"application/tei+xml",
        @"tfi" : @"application/thraud+xml",
        @"tsd" : @"application/timestamped-data",
        @"plb" : @"application/vnd.3gpp.pic-bw-large",
        @"psb" : @"application/vnd.3gpp.pic-bw-small",
        @"pvb" : @"application/vnd.3gpp.pic-bw-var",
        @"tcap" : @"application/vnd.3gpp2.tcap",
        @"pwn" : @"application/vnd.3m.post-it-notes",
        @"aso" : @"application/vnd.accpac.simply.aso",
        @"imp" : @"application/vnd.accpac.simply.imp",
        @"acu" : @"application/vnd.acucobol",
        @"atc" : @"application/vnd.acucorp",
        @"air" : @"application/vnd.adobe.air-application-installer-package+zip",
        @"fxp" : @"application/vnd.adobe.fxp",
        @"xdp" : @"application/vnd.adobe.xdp+xml",
        @"xfdf" : @"application/vnd.adobe.xfdf",
        @"ahead" : @"application/vnd.ahead.space",
        @"azf" : @"application/vnd.airzip.filesecure.azf",
        @"azs" : @"application/vnd.airzip.filesecure.azs",
        @"azw" : @"application/vnd.amazon.ebook",
        @"acc" : @"application/vnd.americandynamics.acc",
        @"ami" : @"application/vnd.amiga.ami",
        @"apk" : @"application/vnd.android.package-archive",
        @"cii" : @"application/vnd.anser-web-certificate-issue-initiation",
        @"fti" : @"application/vnd.anser-web-funds-transfer-initiation",
        @"atx" : @"application/vnd.antix.game-component",
        @"mpkg" : @"application/vnd.apple.installer+xml",
        @"m3u8" : @"application/vnd.apple.mpegurl",
        @"swi" : @"application/vnd.aristanetworks.swi",
        @"aep" : @"application/vnd.audiograph",
        @"mpm" : @"application/vnd.blueice.multipass",
        @"bmi" : @"application/vnd.bmi",
        @"rep" : @"application/vnd.businessobjects",
        @"cdxml" : @"application/vnd.chemdraw+xml",
        @"mmd" : @"application/vnd.chipnuts.karaoke-mmd",
        @"cdy" : @"application/vnd.cinderella",
        @"cla" : @"application/vnd.claymore",
        @"rp9" : @"application/vnd.cloanto.rp9",
        @"c4g" : @"application/vnd.clonk.c4group",
        @"c11amc" : @"application/vnd.cluetrust.cartomobile-config",
        @"c11amz" : @"application/vnd.cluetrust.cartomobile-config-pkg",
        @"csp" : @"application/vnd.commonspace",
        @"cdbcmsg" : @"application/vnd.contact.cmsg",
        @"cmc" : @"application/vnd.cosmocaller",
        @"clkx" : @"application/vnd.crick.clicker",
        @"clkk" : @"application/vnd.crick.clicker.keyboard",
        @"clkp" : @"application/vnd.crick.clicker.palette",
        @"clkt" : @"application/vnd.crick.clicker.template",
        @"clkw" : @"application/vnd.crick.clicker.wordbank",
        @"wbs" : @"application/vnd.criticaltools.wbs+xml",
        @"pml" : @"application/vnd.ctc-posml",
        @"ppd" : @"application/vnd.cups-ppd",
        @"car" : @"application/vnd.curl.car",
        @"pcurl" : @"application/vnd.curl.pcurl",
        @"rdz" : @"application/vnd.data-vision.rdz",
        @"fe_launch" : @"application/vnd.denovo.fcselayout-link",
        @"dna" : @"application/vnd.dna",
        @"mlp" : @"application/vnd.dolby.mlp",
        @"dpg" : @"application/vnd.dpgraph",
        @"dfac" : @"application/vnd.dreamfactory",
        @"ait" : @"application/vnd.dvb.ait",
        @"svc" : @"application/vnd.dvb.service",
        @"geo" : @"application/vnd.dynageo",
        @"mag" : @"application/vnd.ecowin.chart",
        @"nml" : @"application/vnd.enliven",
        @"esf" : @"application/vnd.epson.esf",
        @"msf" : @"application/vnd.epson.msf",
        @"qam" : @"application/vnd.epson.quickanime",
        @"slt" : @"application/vnd.epson.salt",
        @"ssf" : @"application/vnd.epson.ssf",
        @"es3" : @"application/vnd.eszigno3+xml",
        @"ez2" : @"application/vnd.ezpix-album",
        @"ez3" : @"application/vnd.ezpix-package",
        @"fdf" : @"application/vnd.fdf",
        @"seed" : @"application/vnd.fdsn.seed",
        @"gph" : @"application/vnd.flographit",
        @"ftc" : @"application/vnd.fluxtime.clip",
        @"fm" : @"application/vnd.framemaker",
        @"fnc" : @"application/vnd.frogans.fnc",
        @"ltf" : @"application/vnd.frogans.ltf",
        @"fsc" : @"application/vnd.fsc.weblaunch",
        @"oas" : @"application/vnd.fujitsu.oasys",
        @"oa2" : @"application/vnd.fujitsu.oasys2",
        @"oa3" : @"application/vnd.fujitsu.oasys3",
        @"fg5" : @"application/vnd.fujitsu.oasysgp",
        @"bh2" : @"application/vnd.fujitsu.oasysprs",
        @"ddd" : @"application/vnd.fujixerox.ddd",
        @"xdw" : @"application/vnd.fujixerox.docuworks",
        @"xbd" : @"application/vnd.fujixerox.docuworks.binder",
        @"fzs" : @"application/vnd.fuzzysheet",
        @"txd" : @"application/vnd.genomatix.tuxedo",
        @"ggb" : @"application/vnd.geogebra.file",
        @"ggt" : @"application/vnd.geogebra.tool",
        @"gex" : @"application/vnd.geometry-explorer",
        @"gxt" : @"application/vnd.geonext",
        @"g2w" : @"application/vnd.geoplan",
        @"g3w" : @"application/vnd.geospace",
        @"gmx" : @"application/vnd.gmx",
        @"kml" : @"application/vnd.google-earth.kml+xml",
        @"kmz" : @"application/vnd.google-earth.kmz",
        @"gqf" : @"application/vnd.grafeq",
        @"gac" : @"application/vnd.groove-account",
        @"ghf" : @"application/vnd.groove-help",
        @"gim" : @"application/vnd.groove-identity-message",
        @"grv" : @"application/vnd.groove-injector",
        @"gtm" : @"application/vnd.groove-tool-message",
        @"tpl" : @"application/vnd.groove-tool-template",
        @"vcg" : @"application/vnd.groove-vcard",
        @"hal" : @"application/vnd.hal+xml",
        @"zmm" : @"application/vnd.handheld-entertainment+xml",
        @"hbci" : @"application/vnd.hbci",
        @"les" : @"application/vnd.hhe.lesson-player",
        @"hpgl" : @"application/vnd.hp-hpgl",
        @"hpid" : @"application/vnd.hp-hpid",
        @"hps" : @"application/vnd.hp-hps",
        @"jlt" : @"application/vnd.hp-jlyt",
        @"pcl" : @"application/vnd.hp-pcl",
        @"pclxl" : @"application/vnd.hp-pclxl",
        @"sfd-hdstx" : @"application/vnd.hydrostatix.sof-data",
        @"x3d" : @"application/vnd.hzn-3d-crossword",
        @"mpy" : @"application/vnd.ibm.minipay",
        @"afp" : @"application/vnd.ibm.modcap",
        @"irm" : @"application/vnd.ibm.rights-management",
        @"sc" : @"application/vnd.ibm.secure-container",
        @"icc" : @"application/vnd.iccprofile",
        @"igl" : @"application/vnd.igloader",
        @"ivp" : @"application/vnd.immervision-ivp",
        @"ivu" : @"application/vnd.immervision-ivu",
        @"igm" : @"application/vnd.insors.igm",
        @"xpw" : @"application/vnd.intercon.formnet",
        @"i2g" : @"application/vnd.intergeo",
        @"qbo" : @"application/vnd.intu.qbo",
        @"qfx" : @"application/vnd.intu.qfx",
        @"rcprofile" : @"application/vnd.ipunplugged.rcprofile",
        @"irp" : @"application/vnd.irepository.package+xml",
        @"xpr" : @"application/vnd.is-xpr",
        @"fcs" : @"application/vnd.isac.fcs",
        @"jam" : @"application/vnd.jam",
        @"rms" : @"application/vnd.jcp.javame.midlet-rms",
        @"jisp" : @"application/vnd.jisp",
        @"joda" : @"application/vnd.joost.joda-archive",
        @"ktz" : @"application/vnd.kahootz",
        @"karbon" : @"application/vnd.kde.karbon",
        @"chrt" : @"application/vnd.kde.kchart",
        @"kfo" : @"application/vnd.kde.kformula",
        @"flw" : @"application/vnd.kde.kivio",
        @"kon" : @"application/vnd.kde.kontour",
        @"kpr" : @"application/vnd.kde.kpresenter",
        @"ksp" : @"application/vnd.kde.kspread",
        @"kwd" : @"application/vnd.kde.kword",
        @"htke" : @"application/vnd.kenameaapp",
        @"kia" : @"application/vnd.kidspiration",
        @"kne" : @"application/vnd.kinar",
        @"skp" : @"application/vnd.koan",
        @"sse" : @"application/vnd.kodak-descriptor",
        @"lasxml" : @"application/vnd.las.las+xml",
        @"lbd" : @"application/vnd.llamagraphics.life-balance.desktop",
        @"lbe" : @"application/vnd.llamagraphics.life-balance.exchange+xml",
        @"123" : @"application/vnd.lotus-1-2-3",
        @"apr" : @"application/vnd.lotus-approach",
        @"pre" : @"application/vnd.lotus-freelance",
        @"nsf" : @"application/vnd.lotus-notes",
        @"org" : @"application/vnd.lotus-organizer",
        @"scm" : @"application/vnd.lotus-screencam",
        @"lwp" : @"application/vnd.lotus-wordpro",
        @"portpkg" : @"application/vnd.macports.portpkg",
        @"mcd" : @"application/vnd.mcd",
        @"mc1" : @"application/vnd.medcalcdata",
        @"cdkey" : @"application/vnd.mediastation.cdkey",
        @"mwf" : @"application/vnd.mfer",
        @"mfm" : @"application/vnd.mfmp",
        @"flo" : @"application/vnd.micrografx.flo",
        @"igx" : @"application/vnd.micrografx.igx",
        @"mif" : @"application/vnd.mif",
        @"daf" : @"application/vnd.mobius.daf",
        @"dis" : @"application/vnd.mobius.dis",
        @"mbk" : @"application/vnd.mobius.mbk",
        @"mqy" : @"application/vnd.mobius.mqy",
        @"msl" : @"application/vnd.mobius.msl",
        @"plc" : @"application/vnd.mobius.plc",
        @"txf" : @"application/vnd.mobius.txf",
        @"mpn" : @"application/vnd.mophun.application",
        @"mpc" : @"application/vnd.mophun.certificate",
        @"xul" : @"application/vnd.mozilla.xul+xml",
        @"cil" : @"application/vnd.ms-artgalry",
        @"cab" : @"application/vnd.ms-cab-compressed",
        @"xls" : @"application/vnd.ms-excel",
        @"xlam" : @"application/vnd.ms-excel.addin.macroenabled.12",
        @"xlsb" : @"application/vnd.ms-excel.sheet.binary.macroenabled.12",
        @"xlsm" : @"application/vnd.ms-excel.sheet.macroenabled.12",
        @"xltm" : @"application/vnd.ms-excel.template.macroenabled.12",
        @"eot" : @"application/vnd.ms-fontobject",
        @"chm" : @"application/vnd.ms-htmlhelp",
        @"ims" : @"application/vnd.ms-ims",
        @"lrm" : @"application/vnd.ms-lrm",
        @"thmx" : @"application/vnd.ms-officetheme",
        @"cat" : @"application/vnd.ms-pki.seccat",
        @"stl" : @"application/vnd.ms-pki.stl",
        @"ppt" : @"application/vnd.ms-powerpoint",
        @"ppam" : @"application/vnd.ms-powerpoint.addin.macroenabled.12",
        @"pptm" : @"application/vnd.ms-powerpoint.presentation.macroenabled.12",
        @"sldm" : @"application/vnd.ms-powerpoint.slide.macroenabled.12",
        @"ppsm" : @"application/vnd.ms-powerpoint.slideshow.macroenabled.12",
        @"potm" : @"application/vnd.ms-powerpoint.template.macroenabled.12",
        @"mpp" : @"application/vnd.ms-project",
        @"docm" : @"application/vnd.ms-word.document.macroenabled.12",
        @"dotm" : @"application/vnd.ms-word.template.macroenabled.12",
        @"wps" : @"application/vnd.ms-works",
        @"wpl" : @"application/vnd.ms-wpl",
        @"xps" : @"application/vnd.ms-xpsdocument",
        @"mseq" : @"application/vnd.mseq",
        @"mus" : @"application/vnd.musician",
        @"msty" : @"application/vnd.muvee.style",
        @"nlu" : @"application/vnd.neurolanguage.nlu",
        @"nnd" : @"application/vnd.noblenet-directory",
        @"nns" : @"application/vnd.noblenet-sealer",
        @"nnw" : @"application/vnd.noblenet-web",
        @"ngdat" : @"application/vnd.nokia.n-gage.data",
        @"n-gage" : @"application/vnd.nokia.n-gage.symbian.install",
        @"rpst" : @"application/vnd.nokia.radio-preset",
        @"rpss" : @"application/vnd.nokia.radio-presets",
        @"edm" : @"application/vnd.novadigm.edm",
        @"edx" : @"application/vnd.novadigm.edx",
        @"ext" : @"application/vnd.novadigm.ext",
        @"odc" : @"application/vnd.oasis.opendocument.chart",
        @"otc" : @"application/vnd.oasis.opendocument.chart-template",
        @"odb" : @"application/vnd.oasis.opendocument.database",
        @"odf" : @"application/vnd.oasis.opendocument.formula",
        @"odft" : @"application/vnd.oasis.opendocument.formula-template",
        @"odg" : @"application/vnd.oasis.opendocument.graphics",
        @"otg" : @"application/vnd.oasis.opendocument.graphics-template",
        @"odi" : @"application/vnd.oasis.opendocument.image",
        @"oti" : @"application/vnd.oasis.opendocument.image-template",
        @"odp" : @"application/vnd.oasis.opendocument.presentation",
        @"otp" : @"application/vnd.oasis.opendocument.presentation-template",
        @"ods" : @"application/vnd.oasis.opendocument.spreadsheet",
        @"ots" : @"application/vnd.oasis.opendocument.spreadsheet-template",
        @"odt" : @"application/vnd.oasis.opendocument.text",
        @"odm" : @"application/vnd.oasis.opendocument.text-master",
        @"ott" : @"application/vnd.oasis.opendocument.text-template",
        @"oth" : @"application/vnd.oasis.opendocument.text-web",
        @"xo" : @"application/vnd.olpc-sugar",
        @"dd2" : @"application/vnd.oma.dd2+xml",
        @"oxt" : @"application/vnd.openofficeorg.extension",
        @"pptx" : @"application/vnd.openxmlformats-officedocument.presentationml.presentation",
        @"sldx" : @"application/vnd.openxmlformats-officedocument.presentationml.slide",
        @"ppsx" : @"application/vnd.openxmlformats-officedocument.presentationml.slideshow",
        @"potx" : @"application/vnd.openxmlformats-officedocument.presentationml.template",
        @"xlsx" : @"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        @"xltx" : @"application/vnd.openxmlformats-officedocument.spreadsheetml.template",
        @"docx" : @"application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        @"dotx" : @"application/vnd.openxmlformats-officedocument.wordprocessingml.template",
        @"mgp" : @"application/vnd.osgeo.mapguide.package",
        @"dp" : @"application/vnd.osgi.dp",
        @"pdb" : @"application/vnd.palm",
        @"paw" : @"application/vnd.pawaafile",
        @"str" : @"application/vnd.pg.format",
        @"ei6" : @"application/vnd.pg.osasli",
        @"efif" : @"application/vnd.picsel",
        @"wg" : @"application/vnd.pmi.widget",
        @"plf" : @"application/vnd.pocketlearn",
        @"pbd" : @"application/vnd.powerbuilder6",
        @"box" : @"application/vnd.previewsystems.box",
        @"mgz" : @"application/vnd.proteus.magazine",
        @"qps" : @"application/vnd.publishare-delta-tree",
        @"ptid" : @"application/vnd.pvi.ptid1",
        @"qxd" : @"application/vnd.quark.quarkxpress",
        @"bed" : @"application/vnd.realvnc.bed",
        @"mxl" : @"application/vnd.recordare.musicxml",
        @"musicxml" : @"application/vnd.recordare.musicxml+xml",
        @"cryptonote" : @"application/vnd.rig.cryptonote",
        @"cod" : @"application/vnd.rim.cod",
        @"rm" : @"application/vnd.rn-realmedia",
        @"link66" : @"application/vnd.route66.link66+xml",
        @"st" : @"application/vnd.sailingtracker.track",
        @"see" : @"application/vnd.seemail",
        @"sema" : @"application/vnd.sema",
        @"semd" : @"application/vnd.semd",
        @"semf" : @"application/vnd.semf",
        @"ifm" : @"application/vnd.shana.informed.formdata",
        @"itp" : @"application/vnd.shana.informed.formtemplate",
        @"iif" : @"application/vnd.shana.informed.interchange",
        @"ipk" : @"application/vnd.shana.informed.package",
        @"twd" : @"application/vnd.simtech-mindmapper",
        @"mmf" : @"application/vnd.smaf",
        @"teacher" : @"application/vnd.smart.teacher",
        @"sdkm" : @"application/vnd.solent.sdkm+xml",
        @"dxp" : @"application/vnd.spotfire.dxp",
        @"sfs" : @"application/vnd.spotfire.sfs",
        @"sdc" : @"application/vnd.stardivision.calc",
        @"sda" : @"application/vnd.stardivision.draw",
        @"sdd" : @"application/vnd.stardivision.impress",
        @"smf" : @"application/vnd.stardivision.math",
        @"sdw" : @"application/vnd.stardivision.writer",
        @"sgl" : @"application/vnd.stardivision.writer-global",
        @"sm" : @"application/vnd.stepmania.stepchart",
        @"sxc" : @"application/vnd.sun.xml.calc",
        @"stc" : @"application/vnd.sun.xml.calc.template",
        @"sxd" : @"application/vnd.sun.xml.draw",
        @"std" : @"application/vnd.sun.xml.draw.template",
        @"sxi" : @"application/vnd.sun.xml.impress",
        @"sti" : @"application/vnd.sun.xml.impress.template",
        @"sxm" : @"application/vnd.sun.xml.math",
        @"sxw" : @"application/vnd.sun.xml.writer",
        @"sxg" : @"application/vnd.sun.xml.writer.global",
        @"stw" : @"application/vnd.sun.xml.writer.template",
        @"sus" : @"application/vnd.sus-calendar",
        @"svd" : @"application/vnd.svd",
        @"sis" : @"application/vnd.symbian.install",
        @"xsm" : @"application/vnd.syncml+xml",
        @"bdm" : @"application/vnd.syncml.dm+wbxml",
        @"xdm" : @"application/vnd.syncml.dm+xml",
        @"tao" : @"application/vnd.tao.intent-module-archive",
        @"tmo" : @"application/vnd.tmobile-livetv",
        @"tpt" : @"application/vnd.trid.tpt",
        @"mxs" : @"application/vnd.triscape.mxs",
        @"tra" : @"application/vnd.trueapp",
        @"ufd" : @"application/vnd.ufdl",
        @"utz" : @"application/vnd.uiq.theme",
        @"umj" : @"application/vnd.umajin",
        @"unityweb" : @"application/vnd.unity",
        @"uoml" : @"application/vnd.uoml+xml",
        @"vcx" : @"application/vnd.vcx",
        @"vsd" : @"application/vnd.visio",
        @"vis" : @"application/vnd.visionary",
        @"vsf" : @"application/vnd.vsf",
        @"wbxml" : @"application/vnd.wap.wbxml",
        @"wmlc" : @"application/vnd.wap.wmlc",
        @"wmlsc" : @"application/vnd.wap.wmlscriptc",
        @"wtb" : @"application/vnd.webturbo",
        @"nbp" : @"application/vnd.wolfram.player",
        @"wpd" : @"application/vnd.wordperfect",
        @"wqd" : @"application/vnd.wqd",
        @"stf" : @"application/vnd.wt.stf",
        @"xar" : @"application/vnd.xara",
        @"xfdl" : @"application/vnd.xfdl",
        @"hvd" : @"application/vnd.yamaha.hv-dic",
        @"hvs" : @"application/vnd.yamaha.hv-script",
        @"hvp" : @"application/vnd.yamaha.hv-voice",
        @"osf" : @"application/vnd.yamaha.openscoreformat",
        @"osfpvg" : @"application/vnd.yamaha.openscoreformat.osfpvg+xml",
        @"saf" : @"application/vnd.yamaha.smaf-audio",
        @"spf" : @"application/vnd.yamaha.smaf-phrase",
        @"cmp" : @"application/vnd.yellowriver-custom-menu",
        @"zir" : @"application/vnd.zul",
        @"zaz" : @"application/vnd.zzazz.deck+xml",
        @"vxml" : @"application/voicexml+xml",
        @"wgt" : @"application/widget",
        @"hlp" : @"application/winhlp",
        @"wsdl" : @"application/wsdl+xml",
        @"wspolicy" : @"application/wspolicy+xml",
        @"7z" : @"application/x-7z-compressed",
        @"abw" : @"application/x-abiword",
        @"ace" : @"application/x-ace-compressed",
        @"aab" : @"application/x-authorware-bin",
        @"aam" : @"application/x-authorware-map",
        @"aas" : @"application/x-authorware-seg",
        @"bcpio" : @"application/x-bcpio",
        @"torrent" : @"application/x-bittorrent",
        @"bz" : @"application/x-bzip",
        @"bz2" : @"application/x-bzip2",
        @"vcd" : @"application/x-cdlink",
        @"chat" : @"application/x-chat",
        @"pgn" : @"application/x-chess-pgn",
        @"cpio" : @"application/x-cpio",
        @"csh" : @"application/x-csh",
        @"deb" : @"application/x-debian-package",
        @"dir" : @"application/x-director",
        @"wad" : @"application/x-doom",
        @"ncx" : @"application/x-dtbncx+xml",
        @"dtb" : @"application/x-dtbook+xml",
        @"res" : @"application/x-dtbresource+xml",
        @"dvi" : @"application/x-dvi",
        @"bdf" : @"application/x-font-bdf",
        @"gsf" : @"application/x-font-ghostscript",
        @"psf" : @"application/x-font-linux-psf",
        @"otf" : @"application/x-font-otf",
        @"pcf" : @"application/x-font-pcf",
        @"snf" : @"application/x-font-snf",
        @"ttf" : @"application/x-font-ttf",
        @"pfa" : @"application/x-font-type1",
        @"woff" : @"application/x-font-woff",
        @"spl" : @"application/x-futuresplash",
        @"gnumeric" : @"application/x-gnumeric",
        @"gtar" : @"application/x-gtar",
        @"hdf" : @"application/x-hdf",
        @"jnlp" : @"application/x-java-jnlp-file",
        @"latex" : @"application/x-latex",
        @"prc" : @"application/x-mobipocket-ebook",
        @"application" : @"application/x-ms-application",
        @"wmd" : @"application/x-ms-wmd",
        @"wmz" : @"application/x-ms-wmz",
        @"xbap" : @"application/x-ms-xbap",
        @"mdb" : @"application/x-msaccess",
        @"obd" : @"application/x-msbinder",
        @"crd" : @"application/x-mscardfile",
        @"clp" : @"application/x-msclip",
        @"exe" : @"application/x-msdownload",
        @"mvb" : @"application/x-msmediaview",
        @"wmf" : @"application/x-msmetafile",
        @"mny" : @"application/x-msmoney",
        @"pub" : @"application/x-mspublisher",
        @"scd" : @"application/x-msschedule",
        @"trm" : @"application/x-msterminal",
        @"wri" : @"application/x-mswrite",
        @"nc" : @"application/x-netcdf",
        @"p12" : @"application/x-pkcs12",
        @"p7b" : @"application/x-pkcs7-certificates",
        @"p7r" : @"application/x-pkcs7-certreqresp",
        @"rar" : @"application/x-rar-compressed",
        @"sh" : @"application/x-sh",
        @"shar" : @"application/x-shar",
        @"swf" : @"application/x-shockwave-flash",
        @"xap" : @"application/x-silverlight-app",
        @"sit" : @"application/x-stuffit",
        @"sitx" : @"application/x-stuffitx",
        @"sv4cpio" : @"application/x-sv4cpio",
        @"sv4crc" : @"application/x-sv4crc",
        @"tar" : @"application/x-tar",
        @"tcl" : @"application/x-tcl",
        @"tex" : @"application/x-tex",
        @"tfm" : @"application/x-tex-tfm",
        @"texinfo" : @"application/x-texinfo",
        @"ustar" : @"application/x-ustar",
        @"src" : @"application/x-wais-source",
        @"der" : @"application/x-x509-ca-cert",
        @"fig" : @"application/x-xfig",
        @"xpi" : @"application/x-xpinstall",
        @"xdf" : @"application/xcap-diff+xml",
        @"xenc" : @"application/xenc+xml",
        @"xhtml" : @"application/xhtml+xml",
        @"xml" : @"application/xml",
        @"dtd" : @"application/xml-dtd",
        @"xop" : @"application/xop+xml",
        @"xslt" : @"application/xslt+xml",
        @"xspf" : @"application/xspf+xml",
        @"mxml" : @"application/xv+xml",
        @"yang" : @"application/yang",
        @"yin" : @"application/yin+xml",
        @"zip" : @"application/zip",
        @"adp" : @"audio/adpcm",
        @"au" : @"audio/basic",
        @"mid" : @"audio/midi",
        @"mp4a" : @"audio/mp4",
        @"mpga" : @"audio/mpeg",
        @"oga" : @"audio/ogg",
        @"uva" : @"audio/vnd.dece.audio",
        @"eol" : @"audio/vnd.digital-winds",
        @"dra" : @"audio/vnd.dra",
        @"dts" : @"audio/vnd.dts",
        @"dtshd" : @"audio/vnd.dts.hd",
        @"lvp" : @"audio/vnd.lucent.voice",
        @"pya" : @"audio/vnd.ms-playready.media.pya",
        @"ecelp4800" : @"audio/vnd.nuera.ecelp4800",
        @"ecelp7470" : @"audio/vnd.nuera.ecelp7470",
        @"ecelp9600" : @"audio/vnd.nuera.ecelp9600",
        @"rip" : @"audio/vnd.rip",
        @"weba" : @"audio/webm",
        @"aac" : @"audio/x-aac",
        @"aif" : @"audio/x-aiff",
        @"m3u" : @"audio/x-mpegurl",
        @"wax" : @"audio/x-ms-wax",
        @"wma" : @"audio/x-ms-wma",
        @"ram" : @"audio/x-pn-realaudio",
        @"rmp" : @"audio/x-pn-realaudio-plugin",
        @"wav" : @"audio/x-wav",
        @"cdx" : @"chemical/x-cdx",
        @"cif" : @"chemical/x-cif",
        @"cmdf" : @"chemical/x-cmdf",
        @"cml" : @"chemical/x-cml",
        @"csml" : @"chemical/x-csml",
        @"xyz" : @"chemical/x-xyz",
        @"bmp" : @"image/bmp",
        @"cgm" : @"image/cgm",
        @"g3" : @"image/g3fax",
        @"gif" : @"image/gif",
        @"ief" : @"image/ief",
        @"jpeg" : @"image/jpeg",
        @"jpg" : @"image/jpeg",
        @"ktx" : @"image/ktx",
        @"png" : @"image/png",
        @"btif" : @"image/prs.btif",
        @"svg" : @"image/svg+xml",
        @"tiff" : @"image/tiff",
        @"psd" : @"image/vnd.adobe.photoshop",
        @"uvi" : @"image/vnd.dece.graphic",
        @"sub" : @"image/vnd.dvb.subtitle",
        @"djvu" : @"image/vnd.djvu",
        @"dwg" : @"image/vnd.dwg",
        @"dxf" : @"image/vnd.dxf",
        @"fbs" : @"image/vnd.fastbidsheet",
        @"fpx" : @"image/vnd.fpx",
        @"fst" : @"image/vnd.fst",
        @"mmr" : @"image/vnd.fujixerox.edmics-mmr",
        @"rlc" : @"image/vnd.fujixerox.edmics-rlc",
        @"mdi" : @"image/vnd.ms-modi",
        @"npx" : @"image/vnd.net-fpx",
        @"wbmp" : @"image/vnd.wap.wbmp",
        @"xif" : @"image/vnd.xiff",
        @"webp" : @"image/webp",
        @"ras" : @"image/x-cmu-raster",
        @"cmx" : @"image/x-cmx",
        @"fh" : @"image/x-freehand",
        @"ico" : @"image/x-icon",
        @"pcx" : @"image/x-pcx",
        @"pic" : @"image/x-pict",
        @"pnm" : @"image/x-portable-anymap",
        @"pbm" : @"image/x-portable-bitmap",
        @"pgm" : @"image/x-portable-graymap",
        @"ppm" : @"image/x-portable-pixmap",
        @"rgb" : @"image/x-rgb",
        @"xbm" : @"image/x-xbitmap",
        @"xpm" : @"image/x-xpixmap",
        @"xwd" : @"image/x-xwindowdump",
        @"eml" : @"message/rfc822",
        @"igs" : @"model/iges",
        @"msh" : @"model/mesh",
        @"dae" : @"model/vnd.collada+xml",
        @"dwf" : @"model/vnd.dwf",
        @"gdl" : @"model/vnd.gdl",
        @"gtw" : @"model/vnd.gtw",
        @"mts" : @"model/vnd.mts",
        @"vtu" : @"model/vnd.vtu",
        @"wrl" : @"model/vrml",
        @"ics" : @"text/calendar",
        @"css" : @"text/css",
        @"csv" : @"text/csv",
        @"html" : @"text/html",
        @"n3" : @"text/n3",
        @"txt" : @"text/plain",
        @"dsc" : @"text/prs.lines.tag",
        @"rtx" : @"text/richtext",
        @"sgml" : @"text/sgml",
        @"tsv" : @"text/tab-separated-values",
        @"t" : @"text/troff",
        @"ttl" : @"text/turtle",
        @"uri" : @"text/uri-list",
        @"curl" : @"text/vnd.curl",
        @"dcurl" : @"text/vnd.curl.dcurl",
        @"scurl" : @"text/vnd.curl.scurl",
        @"mcurl" : @"text/vnd.curl.mcurl",
        @"fly" : @"text/vnd.fly",
        @"flx" : @"text/vnd.fmi.flexstor",
        @"gv" : @"text/vnd.graphviz",
        @"3dml" : @"text/vnd.in3d.3dml",
        @"spot" : @"text/vnd.in3d.spot",
        @"jad" : @"text/vnd.sun.j2me.app-descriptor",
        @"wml" : @"text/vnd.wap.wml",
        @"wmls" : @"text/vnd.wap.wmlscript",
        @"s" : @"text/x-asm",
        @"c" : @"text/x-c",
        @"f" : @"text/x-fortran",
        @"p" : @"text/x-pascal",
        @"java" : @"text/x-java-source",
        @"etx" : @"text/x-setext",
        @"uu" : @"text/x-uuencode",
        @"vcs" : @"text/x-vcalendar",
        @"vcf" : @"text/x-vcard",
        @"3gp" : @"video/3gpp",
        @"3g2" : @"video/3gpp2",
        @"h261" : @"video/h261",
        @"h263" : @"video/h263",
        @"h264" : @"video/h264",
        @"jpgv" : @"video/jpeg",
        @"jpm" : @"video/jpm",
        @"mj2" : @"video/mj2",
        @"mp4" : @"video/mp4",
        @"mpeg" : @"video/mpeg",
        @"ogv" : @"video/ogg",
        @"qt" : @"video/quicktime",
        @"uvh" : @"video/vnd.dece.hd",
        @"uvm" : @"video/vnd.dece.mobile",
        @"uvp" : @"video/vnd.dece.pd",
        @"uvs" : @"video/vnd.dece.sd",
        @"uvv" : @"video/vnd.dece.video",
        @"fvt" : @"video/vnd.fvt",
        @"mxu" : @"video/vnd.mpegurl",
        @"pyv" : @"video/vnd.ms-playready.media.pyv",
        @"uvu" : @"video/vnd.uvvu.mp4",
        @"viv" : @"video/vnd.vivo",
        @"webm" : @"video/webm",
        @"f4v" : @"video/x-f4v",
        @"fli" : @"video/x-fli",
        @"flv" : @"video/x-flv",
        @"m4v" : @"video/x-m4v",
        @"asf" : @"video/x-ms-asf",
        @"wm" : @"video/x-ms-wm",
        @"wmv" : @"video/x-ms-wmv",
        @"wmx" : @"video/x-ms-wmx",
        @"wvx" : @"video/x-ms-wvx",
        @"avi" : @"video/x-msvideo",
        @"movie" : @"video/x-sgi-movie",
        @"ice" : @"x-conference/x-cooltalk",
        @"par " : @"text/plain-bas",
        @"yaml" : @"text/yaml"
    };
    NSString *pathExtension;
    if (filePathURL) {
        pathExtension = filePathURL.pathExtension;
    }
    if (!(pathExtension.length) && fileName) {
        pathExtension = fileName.pathExtension;
    }
    if (!pathExtension) {
        return @"application/octet-stream";
    }
    NSString *mineType = mimeMap[pathExtension.lowercaseString];
    return mineType ? mineType : @"application/octet-stream";
}
