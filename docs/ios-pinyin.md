# Xeyboard 的 iOS 拼音输入方案

## 基线

截至 2026-11-23，美国 App Store 显示 Hex iOS 最新版为 **1.0.2**。上游发布标签 `ios-beta-appstore-1.0.2` 指向 `a5adb4c23b5cc3dafa1026bbae1672c73175a15c`，该提交是 fork 的祖先。建议以这个 SHA 作为首版开发基线，方便与商店版做功能回归对照。[App Store](https://apps.apple.com/us/app/hex-voice-dictation-keyboard/id6836837368) · [上游发布标签](https://github.com/anomalyco/hex/releases/tag/ios-beta-appstore-1.0.2)

| 版本 | 提交 | 提交时间（UTC） |
| --- | --- | --- |
| App Store 1.0.2 对应标签 | [`a5adb4c`](https://github.com/anomalyco/hex/commit/a5adb4c23b5cc3dafa1026bbae1672c73175a15c) | 2026-11-22 00:42:09 |
| `xyydys/hex` 的 `dev` | [`72b293e`](https://github.com/xyydys/hex/commit/72b293e29b6063d53b2da2558206cfc88349cfe9) | 2026-11-22 00:57:44 |
| `anomalyco/hex` 的 `dev` | [`8d8b586`](https://github.com/anomalyco/hex/commit/8d8b5867e31807f61268aaf98fbae94ea88d46c5) | 2026-11-23 18:01:20 |

对照商店标签和 fork 的 `dev`，fork 多 3 个提交，变更文件均在 `ios/` 之外。上游 `dev` 在这次核对时比 fork 多 160 个提交。这是对 Git 源码的比对。商店构建由 Xcode Cloud 在打包时写入版本号。[商店标签与 fork 对照](https://github.com/anomalyco/hex/compare/a5adb4c23b5cc3dafa1026bbae1672c73175a15c...72b293e29b6063d53b2da2558206cfc88349cfe9) · [fork 与上游对照](https://github.com/anomalyco/hex/compare/72b293e29b6063d53b2da2558206cfc88349cfe9...8d8b5867e31807f61268aaf98fbae94ea88d46c5) · [iOS 发布说明](https://github.com/anomalyco/hex/blob/a5adb4c23b5cc3dafa1026bbae1672c73175a15c/ios/README.md#internal-testflight-releases)

## 首版做什么

在 iPhone 的 Full 键盘增加可选的**简体中文 26 键全拼**。沿用字母键位，在候选区显示尚未上屏的拼音和汉字候选，覆盖单字和常用词。比如输入 `zhongwen`，点候选或按空格可以上屏「中文」。普通打字和词库查询在本地完成，关闭「允许完全访问」时也能用。首版集中解决听写后的补字和短句，整句转换、个性化词频、繁体、九键和手写可后续评估。[上游拼音需求 #2181](https://github.com/anomalyco/hex/issues/2181)

## 接入现有扩展

1. 在 `KeyboardLanguage` 中增加简体拼音模式。复用现有 QWERTY 字母布局，并通过现有语言切换入口切回英文。既有听写语言的手动选择保持有效。[KeyboardLanguage.swift](https://github.com/anomalyco/hex/blob/a5adb4c23b5cc3dafa1026bbae1672c73175a15c/ios/HEXShared/FullKeyboard/KeyboardLanguage.swift)
2. 在 `FullKeyboardEngine` 的字符处理入口捕获拼音字母，在组合状态下跳过英文纠错和滑行识别。退格先删除拼音，长按退格也遵循同一规则。组合为空时沿用现有按键行为。上屏时走现有 `KeyboardTextTarget`，纯拼音留在键盘候选区。[FullKeyboardEngine.swift](https://github.com/anomalyco/hex/blob/a5adb4c23b5cc3dafa1026bbae1672c73175a15c/ios/HEXShared/FullKeyboard/FullKeyboardEngine.swift)
3. 用 `FullKeyboardView` 的现有候选条显示预编辑文本和候选。组合期间，候选优先于剪贴板建议和 Emoji。切换文本字段或输入语言时清空组合，开始听写前先结算组合，避免把候选带进另一段文本。[FullKeyboardView.swift](https://github.com/anomalyco/hex/blob/a5adb4c23b5cc3dafa1026bbae1672c73175a15c/ios/HEXShared/FullKeyboard/FullKeyboardView.swift) · [KeyboardViewController.swift](https://github.com/anomalyco/hex/blob/a5adb4c23b5cc3dafa1026bbae1672c73175a15c/ios/HEXKeyboard/KeyboardViewController.swift)
4. 打包一份有明确再分发许可的本地单字和常用词词库。用词频排序，限制每次候选数，在真机检查加载耗时和内存，尤其是与键盘内听写交替使用时。词库及任何第三方引擎的许可须分别核对，沿用 Hex 源码时保留 MIT 许可和版权声明。[Hex LICENSE](https://github.com/anomalyco/hex/blob/a5adb4c23b5cc3dafa1026bbae1672c73175a15c/LICENSE) · [第三方声明](https://github.com/anomalyco/hex/blob/a5adb4c23b5cc3dafa1026bbae1672c73175a15c/THIRD_PARTY_NOTICES.md)

## 构建和验收

用 Xcode 26+ 和 XcodeGen 2.46+ 生成 iOS 工程。Xeyboard 独立安装时，用自己的 Apple 开发团队配置主 App、键盘扩展、Widget 的 Bundle ID，并统一更新 App Group 和 URL scheme。先用键盘引擎测试验证连续拼音、同音候选、空格与点选上屏、退格、无候选以及中英切换，再在 iPhone 真机检查跨 App 打字、完全访问关闭时打字、有权限时从打字切到中文听写。此文档记录源码调研和设计，功能实现、构建和真机验收尚未开始。[构建说明](https://github.com/anomalyco/hex/blob/a5adb4c23b5cc3dafa1026bbae1672c73175a15c/ios/README.md#build--test) · [工程配置](https://github.com/anomalyco/hex/blob/a5adb4c23b5cc3dafa1026bbae1672c73175a15c/ios/project.yml)
