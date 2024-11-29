sed -i '' "s/^\(.*s.pod_target_xcconfig.*\)$/#\1/" "QCloudTrack.podspec"
sed -i '' "s/^\(.*s.pod_target_xcconfig.*\)$/#\1/" "QCloudCore.podspec"
sed -i '' "s/^\(.*s.user_target_xcconfig.*\)$/#\1/" "QCloudCore.podspec"
sed -i '' "s/^\(.*s.pod_target_xcconfig.*\)$/#\1/" "QCloudCOSXML.podspec"
sed -i '' "s/^\(.*s.user_target_xcconfig.*\)$/#\1/" "QCloudCOSXML.podspec"
sed -i '' "s/^\(.*pod 'QCloudTrack\/Cls'.*\)$/#\1/" "Podfile"

pod install
chmod +x xcframework_package.sh
cd "Pods"

# 设置其他变量
OUTPUT_DIR="xcframework"

# 清理之前的构建
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

../xcframework_package.sh QCloudTrack $OUTPUT_DIR
cp -R "$OUTPUT_DIR"* "../"
../xcframework_package.sh QCloudCore $OUTPUT_DIR
cp -R "$OUTPUT_DIR"* "../"
../xcframework_package.sh QCloudCOSXML $OUTPUT_DIR
cp -R "$OUTPUT_DIR"* "../"

rm -rf "$OUTPUT_DIR"
cd ".."
echo "编译完成. xcframework地址: $OUTPUT_DIR/"

