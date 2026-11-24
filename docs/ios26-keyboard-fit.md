# Xeyboard iOS 26 键盘尺寸测试包

本分支保留 Beta 2 的 Hex 1.0.2 基线及拼音补丁，仅回移上游 [Hex #2358](https://github.com/anomalyco/hex/pull/2358) 在 KeyboardLayout.swift 中的尺寸修正。不同 iOS 版本、普通 iPhone、Pro Max、横竖屏分别取对应尺寸。基线已带 [Hex #2280](https://github.com/anomalyco/hex/pull/2280) 的系统实际高度适配，不重复同步。

CI 只编译 iPhone IPA，不编译模拟器，不覆盖 Beta 2。IPA 未签名；同一台设备、同一个输入框里对比系统键盘和 Xeyboard，分别检查底排、横屏与中文候选栏。
