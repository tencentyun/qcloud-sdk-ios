echo "开始运行打包脚本，该打包脚本依赖cocoapods，请确保打包机器安装了cocoapods"
mkdir build
cd build
echo "开始打包QCloudCore..."
pod package ../QCloudCore.podspec --no-mangle --exclude-deps --force
echo "QCloudCore打包完成"
echo "开始打包QCloudCOSXML..."
pod package ../QCloudCOSXML.podspec --no-mangle --exclude-deps --force
echo "QCloudCOSXML打包完成"
mkdir temp
mv QCloud*/ios/*.framework ./temp

