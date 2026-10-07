#import "@preview/ctheorems:1.1.3": *
#show: thmrules

#import "@preview/algo:0.3.6" as algo

#import "@preview/numbly:0.1.0": numbly

#let thmbox = thmbox.with(breakable: true)
#let definition = thmbox("definition", "定义")
#let theorem = thmbox("theorem", "定理")
#let lemma = thmbox("lemma", "引理")
#let proof = thmproof("proof", "证明")
#let algorithm = thmbox("algorithm", "算法")

#let argmin = $limits(op("argmin"), inline: #false)$
#let argmax = $limits(op("argmax"), inline: #false)$
#let diam = $op("diam")$
#let conv = $op("conv")$
#let sch = $op("sch")$
#let powset = $scr(P)$
#let chev(..args) = $lr(chevron.l #args.pos().join($,$) chevron.r)$
#let prob = $PP$
#let expect = $EE$

#let en-font = "New Computer Modern"
#let cn-font-body = "SimSun"
#let cn-font-heading = "SimHei"
#let cn-font-emph = "KaiTi"

#let spacing = 22pt
#let body-size = 12pt
#let heading-size = 14pt
#let header-size = 10.5pt
#let title-size = 18pt

#set page(
  margin: 2cm,
  header: block(
    width: 100%,
    stroke: (bottom: 0.8pt + black),
    inset: (bottom: 5pt),
    align(center)[
      #text(size: header-size)[操作系统课程实验报告]
    ],
  ),
  numbering: "1"
)
#set text(font: (cn-font-body, en-font), size: body-size)
#show heading: set text(font: (cn-font-heading, en-font), size: heading-size)
#show heading: set block(below: spacing)
#show heading.where(depth: 2): it => pad(left: 1em, it)
#show emph: set text(font: (en-font, cn-font-emph), style: "normal")
#let indent = 2em
#set par(first-line-indent: (amount: indent, all: true), leading: 22pt)
#set heading(numbering: numbly("{1:一}、", "{2}."))
#set underline(offset: 2pt)
#show link: underline
#let ext_link(dest, ..args) = {
  let pos-args = args.pos()
  let content = if pos-args.len() > 0 { pos-args.at(0) } else { dest }
  link(dest, text(fill: rgb("#1a73e8"), content))
}

#set math.mat(delim: "[")
#show figure.where(kind: image): set figure(supplement: "图")
#show figure.where(kind: table): set figure(supplement: "表")

#let algo-keywords = (
  "func",
  "if",
  "else",
  "for",
  "while",
  "break",
  "continue",
  "return",
  "let",
  "true",
  "false",
  "assert",
)
#let alg = algo.algo.with(keywords: algo-keywords, breakable: true)

#align(center)[
  #text(font: "SimHei", size: title-size)[
    实验一#h(1em)编译 Linux 内核
  ]

  班级：#underline[REDACTED]
  学号：#underline[REDACTED]
  姓名：#underline[REDACTED]
]

#linebreak()

= 实验目的

+ 熟悉 Linux 内核配置过程，掌握 make menuconfig、make xconfig 等配置工具。
+ 掌握 Linux 内核的编译、模块编译与安装流程。
+ 掌握新内核的引导配置与启动验证方法。
+ 培养在 Linux 环境下进行系统级操作、故障排查和实验记录的能力。

= 实验内容

安装 Fedora 虚拟机。下载 Linux 内核源码并编译，切换系统原有内核并启动新内核。

= 实验步骤

== 安装 Fedora 虚拟机

下载并安装 VMware Workstation Pro。当前最新版本为 26H1u1。

从 #ext_link("https://fedoraproject.org/")[Fedora 官网] 下载系统镜像。当前最新稳定版本为 Fedora 44。安装到 VMware Workstation。

== 检查内核版本

执行命令 `uname -a`，结果如 @img:init-kernel-version 所示。
#figure(
  caption: [原有内核版本],
)[
  #image("assets/initial-kernel-version.png")
]<img:init-kernel-version>

== 下载 Linux 源码

从 #ext_link("https://kernel.org/")[The Linux Kernel Archives 网站] 下载 Linux 内核源码。当前最新稳定版本为 7.2.9。

+ 下载：
  ```sh
  curl -fLO https://cdn.kernel.org/pub/linux/kernel/v7.x/linux-7.2.9.tar.xz
  ```
+ 解压：
  ```sh
  tar -xf linux-7.2.9.tar.xz
  ```

== 配置

复制当前系统内核的配置，添加版本后缀 `"-joyce"`：
```sh
cp /boot/config-$(uname -r) .config

./scripts/config --set-str LOCALVERSION "-joyce"
./scripts/config --disable LOCALVERSION_AUTO
./scripts/config --set-str SYSTEM_TRUSTED_KEYS ""
./scripts/config --set-str SYSTEM_REVOCATION_KEYS ""

make olddefconfig
make -s kernelrelease
```

== 编译内核

执行 `make -j"$(nproc)"` 进行并行构建。

编译结果如 @img:compile-result 所示，生成了 `bzImage` 文件。
#figure(
  caption: [内核编译结果],
)[
  #image("assets/compile-result.png")
]<img:compile-result>

== 安装模块和内核

执行命令：
```sh
sudo make modules_install
sudo make install
```

== 启动新内核

将编译出的新内核设置为默认内核：
```sh
sudo grubby --set-default="/boot/vmlinuz-7.2.9-joyce"
```

#figure(
  caption: [内核安装结果],
)[
  #image("assets/install-result.png")
]<img:install-result>

重启虚拟机，执行 `uname -a` 查看当前内核版本，结果如 @img:launch-result 所示。

#figure(
  caption: [启动新内核],
)[
  #image("assets/launch-result.png")
]<img:launch-result>

= 实验结果及分析

切换后的内核版本号显示为我们自定义的 `7.2.9-joyce`，实验结果符合预期。

= 实验收获与体会

第一次安装虚拟机时，即使是安装引导程序都卡得要死，令我非常困惑。后来我发现原来是因为我只给他开了 1 个逻辑处理器，增加后就没事了。但我还是不太理解，难道 VMware 默认值是是只开 1 个吗？

我为虚拟机分配了 8 GB 内存、24 个逻辑处理器，我的 CPU 还是 14 代 i9；即便如此，编译内核仍然花了相当长的时间。不过，考虑到这是一个操作系统的内核，以及虚拟机的性能损失，好像也不算太久。

学计算机，电脑配置还是得够好啊……
