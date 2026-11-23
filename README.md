# Xeyboard iOS 拼音 Beta

基于 Hex iOS 1.0.2 的 Swift 键盘扩展，加入简体中文 26 键全拼。词库随键盘打包，支持离线查询。候选栏左侧显示拼音，中间和右侧是两个汉字候选。点选或按空格上屏，退格优先删除尚未上屏的拼音。

启用 Xeyboard Keyboard 后，短滑空格键可以切换拼音，也可以在 App 的 Settings → Keyboard → Languages 选择「简体拼音」。没有候选时，按空格上屏原始拼音。语音输入沿用 Hex 的权限和本地听写流程。

## 下载

macOS 构建完成后，下载见 [GitHub Releases](https://github.com/xyydys/Xeyboard/releases)。

- iOS Simulator ZIP 解压后可在 macOS 的 iPhone 模拟器安装。
- iPhone IPA 为未签名构建，装到实体 iPhone 前需要为主 App 和扩展配置签名及描述文件。

## 源码和构建

构建流程检出 Hex 的固定提交 `a5adb4c23b5cc3dafa1026bbae1672c73175a15c`，应用 [iOS 补丁](patches/ios-pinyin.patch)，再打包本地词库。主 App、键盘扩展和 Widget 使用 Xeyboard 的 Bundle ID。Hex 源码沿用 MIT 许可，词库许可及来源见 [PinyinLexicon-LICENSE.txt](assets/PinyinLexicon-LICENSE.txt)。

[版本对照与设计](docs/ios-pinyin.md)
