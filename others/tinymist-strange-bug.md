# Tinymist 的神秘 bug

> 环境：
> 
> - typst 0.15.1 (unknown commit)
> - myriad-dreamin.tinymist 0.15.8
> - Visual Studio Code 1.138.0

[该 Typst 文件](./tinymist-strange-bug.assets/templates.typ)在 Tinymist 的预览渲染中，在 VS Code 默认窗口大小（不开启任何侧栏）和缩放下，第 28 页 `phi[i * prime] = phi[i] * prime;`（源文件第 1680 行）的第一个 `*` 会不显示。任何影响预览页面大小的行为（缩放、更改划分窗口位置、将 VSC 取消最大化等）都会破坏这一状态。

不排除与我的显示屏大小有关。
