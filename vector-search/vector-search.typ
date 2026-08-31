#import "@preview/ctheorems:1.1.3": *
#show: thmrules

#import "@preview/algo:0.3.6" as algo

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
#let powset(..args) = $scr(P)(#args.pos().join($,$))$
#let chev(..args) = $lr(chevron.l #args.pos().join($,$) chevron.r)$
#let prob(..args) = $PP(#args.pos().join($,$))$
#let expect(..args) = $EE(#args.pos().join($,$))$

#let en-font = "New Computer Modern"
#let cn-font-body = "Noto Serif SC"
#let cn-font-heading = "Noto Sans SC"
#let cn-font-emph = "KaiTi"

#set page(margin: 2cm)
#set text(font: (en-font, cn-font-body))
#show emph: set text(font: (en-font, cn-font-emph), style: "normal")
#let indent = 2em
#set par(first-line-indent: (amount: indent, all: true))
#set heading(numbering: "1.")
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
  #text(font: (en-font, cn-font-heading), size: 2em)[
    向量检索
  ],
]

#outline(indent: auto, title: "目录")

#pagebreak()

= 基本概念

== 度量空间

#definition[度量空间][
  称 $(X, delta)$ 为一个#emph[度量空间（metric space）]，其中：
  - $X$ 是一个集合，其中的元素称为#emph[点]。
  - $delta: X^2 -> RR$ 称为 $X$ 的一个#emph[#underline[度量函数（metric function）/距离函数（distance function）]]。任取 $x,y,z in X$，它必须满足
    - 非负性：$delta(x, y) >= 0$。
    - 唯一性：$delta(x, y) = 0 <=> x = y$。
    - 对称性：$delta(x, y) = d(y, x)$。
    - 三角不等式：$delta(x, z) <= delta(x, y) + delta(y, z)$。
]<def:metric-space>

任何一个#emph[赋范向量空间（normed vector space）]都是度量空间。

== 欧几里得空间

#definition[欧几里得空间][
  设 $V$ 是有限维实内积空间（这保证了内积的值域必然是 $[0, +infinity)$），则称 $V$ 是一个#emph[欧几里得空间（Euclidean space）]。可以定义范数
  $
    || dot ||_2: x |-> sqrt(chev(x, x)) space (x in V),
  $
  #h(-indent) 距离
  $
    delta: (x, y) |-> ||y - x||_2 space (x, y in V),
  $
  #h(-indent) 和夹角
  $
    angle: (x, y) |-> arccos(chev(x, y) / (||x||_2 dot ||y||_2)) space (x, y in V).
  $
]<def:euclidean-space>

显然任何欧几里得空间都是度量空间。

任何 $d$ 维欧几里得空间都与定义标准内积的 $RR^d$ 同构。

== 凸包

#definition[凸包][
  设 $V$ 是一个向量空间，$S subset.eq V$。称
  $
    "conv"(S) = {sum_(x in T) lambda(x) dot x: T subset.eq S and |T| in NN and ((forall x in S) space (lambda(x) >= 0)) and sum_(x in S) lambda(x) = 1}
  $
  #h(-indent) 为 $S$ 的#emph[凸包（convex hull）]。
]

== 勒贝格测度

#definition[勒贝格测度][
  考虑 $RR^n$，任何其他欧几里得空间都可以同构到该空间。

  定义 $[l, r] = {x in RR: l <= x <= r}$。特别地，$l > r <==> [l, r] = emptyset$。定义 $cal(I) = {[l, r]: l,r in RR}$。定义闭区间 $[l, r] space (l <= r)$ 的体积（长度）为 $|[l, r]| = r - l$。

  设集合 $I subset.eq RR^n$。如果存在 $(J_i)_(i = 0)^(n - 1) in cal(I)^n$ 满足
  $
    I = product_(i = 0)^(n - 1) J_i,
  $
  #h(-indent) 则称 $I$ 是一个 #emph[$n$ 维闭区间]，并定义其体积为
  $
    |I| = product_(i = 0)^(n - 1) |J_i|.
  $

  对任意 $S in RR^n$，定义其#emph[勒贝格外测度（Lebesgue outer measure）]为
  $
    lambda_n^*(S) = inf{sum_(i = 0)^(+infinity) |I_i|: E subset.eq union.big_(i = 0)^(+infinity) I_i and ((forall i in NN) space (I_i in cal(I)^n))}.
  $
  #h(-indent) 称 $S$ 是#emph[勒贝格可测的（Lebesgue measurable）]，如果
  $
    (forall T subset.eq RR^n) space (lambda_n^*(T) = lambda_n^*(T inter S) + lambda_n^*(T without S)).
  $
  #h(-indent) 将 $RR^n$ 上所有勒贝格可测集记作 $cal(L)(RR^n)$。将 $lambda_n^*$ 限制在 $cal(L)(RR^n)$ 上，得到的函数 $lambda_n = lambda_n^* harpoon.tr cal(L)(RR^n)$ 称为#emph[勒贝格测度（Lebesgue measure）]。
]

== 中位数、几何中位数和中心点

#definition[几何中位数][
  给定 $d$ 维欧几里得空间 $E_d$ 中的有限个点的集合 $D subset.eq E_d$，其#emph[几何中位数（geometric median）]定义为
  $
    op("gmed") D = argmin_(x^* in E_d) sum_(x in D) ||x - x^*||_2,
  $
  #h(-indent) 即#strong[整个 $E_d$ 空间中]到数据集各点距离之和最小的点。
]<def:geometric-median>

显然，对于 $E_d = RR$ 的情况，几何中位数就是我们平时说的统计意义上的中位数。

#definition[中心点][
  给定 $d$ 维欧几里得空间 $E_d$ 中的有限个点的集合 $D subset.eq E_d$，其#emph[中心点（medoid）]定义为
  $
    op("medoid") D = argmin_(x^* in D) sum_(x in D) ||x - x^*||_2,
  $
  #h(-indent) 即#strong[数据集中]到数据集各点距离之和最小的点。
]<def:medoid>

我不认为“中心点”是一个好的翻译，容易让人误以为是指质心。也许叫“中位点”更好？

== 最近邻搜索问题

#definition[$k$-近邻搜索问题][
  给定度量空间 $(cal(X), delta)$ 上的一个有限的点集 $D subset.eq cal(X)$（表示数据点）和 $k in NN space (k <= |D|)$。对每个 $p in cal(X)$，定义偏序关系 $scripts(<=)_p = {(x, y) in cal(X)^2: delta(p, x) <= delta(p, y)}$。我们需要用算法构造函数 $f: cal(X) -> powset(D)$，对于任意给定的查询点 $q in cal(X)$，返回 $f(q) subset.eq D$ 满足
  $
    |f(q)| = k and ((forall x in f(q)) space (forall y in D without f(q)) space (x scripts(<=)_q y)).
  $
]

== 召回率

#definition[召回率][
  设分类问题的输入空间为 $cal(X)$，输出空间 $cal(Y) = {0, 1}$。给定一个分类器 $f: cal(X) -> cal(Y)$，和一个样本集合 $D = ((x_i, y_i))_(i = 0)^(n - 1$，定义：
  - 真阴性（true negative, TN）：$"TN" = {i in NN inter [0, n): y_i = 0 and f(x_i) = 0}$。
  - 真阳性（true positive, TP）：$"TP" = {i in NN inter [0, n): y_i = 1 and f(x_i) = 1}$。
  - 假阴性（false negative, FN）：$"FN" = {i in NN inter [0, n): y_i = 1 and f(x_i) = 0}$。
  - 假阳性（false positive, FP）：$"FP" = {i in NN inter [0, n): y_i = 0 and f(x_i) = 1}$。
  #emph[经验召回率（empirical recall）]定义为
  $
    italic("recall") = (|"TP"|) / (|"TP"| + |"FN"|).
  $
]<def:recall>

特别地，对于 $k$-ANN 问题，如果精确 $k$-NN 为 $R$，而近似算法的结果为 $tilde(R)$，则召回率为
$
  italic("recall") = (|R inter tilde(R)|) / (|R|) = (|R inter tilde(R)|) / k.
$

== Voronoi 划分、Veronoi 图、Delaunay 图

#definition[Voronoi 划分][
  考虑度量空间 $(X, delta)$。设空间中有一个#strong[有限的]“生成点”集合（实际问题中的已知数据点）$P subset.eq X$。对于任意 $p in P$，其#emph[Voronoi 区域（Voronoi region）]定义为
  $
    V(p) = {x in X: (forall q in P) space (delta(x, p) <= delta(x, q))}.
  $
]<def:voronoi-tessellation>

#definition[Delaunay 图][
  给定度量空间 $(X, delta)$ 和生成点集合 $P subset.eq X$，设 $V$ 表示 Voronoi 划分。$P$ 上的#emph[Delaunay 图（Delaunay Graph）]定义为无向图 $G = (P, E)$，其中
  $
    E = {{p, q} subset.eq P: p != q and V(p) inter V(q) != emptyset}.
  $
]<def:delaunay-graph>

Delaunay 图是 Voronoi 图的对偶图。

= 基于 NSW 图的 ANN 算法 @MALKOV201461

== 基本贪心算法

#algorithm[基本贪心算法][
  #alg(
    title: $italic("greedySearchAnn")$,
    parameters: ($italic("src")$, $italic("qry")$),
  )[
    while true: #algo.i \
    $italic("best") <- italic("src")$ \
    $d_"min" <- delta(italic("best"), italic("qry"))$ \
    for $v in italic("src").italic("adjs")$: #algo.i \
    $d <- delta(v, italic("qry"))$ \
    if $d < d_"min"$: #algo.i \
    $italic("best") <- v$\
    $d_"min" <- d$ #algo.d #algo.d \
    if $italic("best") = italic("src")$: #algo.i \
    return $italic("src")$ #algo.d \
    $italic("src") <- italic("best")$
  ]
]<algo:nsw-greedy-anns>

#algorithm[用于 K-ANN 的基本贪心算法][
  #alg(
    title: $italic("greedySearchAnns")$,
    parameters: ($italic("qry")$, $italic("num")$, $italic("rep")$),
  )[
    $italic("cands") <- emptyset$ \
    $italic("vis") <- emptyset$ \
    $italic("res") <- emptyset$ \
    repeat for $italic("rep")$ times: #algo.i \
    randomly select a $italic("src") in X$ and $italic("cands") <- italic("cands") union {italic("src")}$ \
    $italic("tmp_res") <- emptyset$ \
    while true: #algo.i \
    let $c$ be the closest element to $italic("qry")$ in $italic("cands")$ \
    $italic("cands") <- italic("cands") without {c}$ \
    if $c$ is further from $italic("qry")$ than the $italic("num")$-th element in $italic("res")$: #algo.i \
    break #algo.d \
    for $v in c.italic("adjs")$: #algo.i \
    if $v in.not italic("vis")$: #algo.i \
    $italic("vis") <- italic("vis") union {v}$ \
    $italic("cands") <- italic("cands") union {v}$ \
    $italic("tmp_res") <- italic("tmp_res") union {v}$ #algo.d #algo.d \
    return the nearest $italic("num")$ elements in $italic("res")$
  ]

  可以用平衡树来存储集合，按到 $italic("qry")$ 的距离排序。
]<algo:nsw-greedy-k_anns>

== 数据插入算法

目标是建立一个估计的 Delaunay 图（在高维空间上，精确建图被证明是不可能的）。主要的目标是要最小化虚假的全局最小值点的概率，同时限制边数尽量小。一些办法是利用所使用的度量空间的拓扑性质。

作者的办法是对于每个新增元素，利用 @algo:nsw-greedy-k_anns 在已有的图上查找其 $f$-ANN 并分别与该点连边。这个方法是基于这么一种假设：新增点的精确 Voronoi 邻居和他的 $f$-ANN 的交集应该是比较大的。

建图时，逐个插入元素即可。这种建图办法的好处是，由一维数据上的经验显示，只要加点顺序是随机的，这样建立的图无需额外调整即满足 small world navigation 性质。

=== 参数选择

查询阶段的召回率超过 $0.99$ 后，继续增大召回率对搜索质量没有显著影响。推荐的是将其保持在 $0.95 ~ 0.99$。召回率的变化相对于数据集大小的增长是缓慢的（对数级）。

对于 $d in NN inter [1. 20]$ 维欧氏空间，最优的 $f approx 3 d$。

= 基于 HNSW 图的 ANN 算法 @8594636

Motivation 看不懂，先跳过了。

== 算法

=== 层内搜索算法

#algorithm[层内搜索算法][
  #alg(
    title: $italic("searchLayerAnns")$,
    parameters: ($italic("layer")$, $italic("entries")$, $italic("qry")$, $italic("num")$),
  )[
    $italic("vis") <- italic("entries")$ \
    $italic("cands") <- italic("entries")$ \
    $italic("nns") <- italic("entries")$ \
    while $italic("cands") != emptyset$: #algo.i \
    let $c$ be the closest element #algo.no-emph[to] $italic("qry")$ in $italic("cands")$ \
    let $f$ be the furthest element to $italic("qry")$ in $italic("nns")$ \
    if $delta(italic("qry"), c) > delta(italic("qry"), f)$: #algo.i \
    break #algo.d \
    for $v in c.italic("adjs")$ in $italic("layer")$: #algo.i \
    if $v in italic("vis")$: #algo.i \
    continue #algo.d \
    $italic("vis") <- italic("vis") union {v}$ \
    let $f$ be the furthest element to $italic("qry")$ in $italic("nns")$ \
    if $delta(italic("qry"), v) < delta(italic("qry"), f)$ or $|italic("nns")| < italic("num")$: #algo.i \
    $italic("cands") <- italic("cands") union {v}$ \
    $italic("nns") <- italic("nns") union {v}$ \
    if $|italic("nns")| = italic("num")$: #algo.i \
    $italic("nns") <- italic("nns") without {f}$ #algo.d #algo.d #algo.d #algo.d \
    return $italic("nns")$
  ]
]<algo:hnsw-layer-k_anns>

=== 搜索算法

#algorithm[搜索算法][
  #alg(
    title: $italic("searchAnns")$,
    parameters: ($italic("layers")$, $italic("qry")$, $italic("num")$, $italic("lim")$),
  )[
    $italic("nns") <- emptyset$ \
    $italic("entries") <- italic("layers")_(|italic("layers")| - 1)$ \
    for $l$ from $|italic("layers")| - 1$ down to $1$: #algo.i \
    $italic("nns") <- italic("searchLayerAnns")(italic("layers")_l, italic("entries"), italic("qry"), 1)$ \
    $italic("entries") <- italic("nns")$ #algo.d \
    $italic("nns") <- italic("searchLayerAnns")(italic("layers")_0, italic("entries"), italic("qry"), italic("lim"))$ \
    return the nearest $italic("num")$ elements in $italic("nns")$
  ]
]<algo:hnsw-k_anns>

=== 插入算法

==== 新点参与的层数

仿照跳表的思想，为新插入的点 $p_"new"$ 设置最大层数 $l_"m"$，他会出现在第 $l$ 层当且仅当 $l in NN inter [0, l_"m"]$。具体来说，设置参数 $p_"e"$ 表示上升概率，将新点放在第 $0$ 层，且对于已经放了该点的第 $i$ 层，这个点有 $p_"e"$ 的概率在下一层也出现，因此 $p_"new"$ 到达的最大层数 $l_"m"$ 满足
$
  prob(l_"m" >= l) = p_"e"^l space (l in NN).
$

下面给出一种具体的取样方法，即取 $u ~ U(0, 1)$，$l_"m" = floor((ln u) / (ln p_"e"))$。因 $u ~ U(0, 1)$，所以 $ln 1 / u ~ E(1)$，$(ln u) / (ln p_"e") = ln(1 \/ u) / ln(1 \/ p_"e") ~ E(1 / p_"e")$（计算一下概率密度函数就可以轻易验证）。因为对于任意 $x in RR^+$ 有
$
  prob((ln u) / (ln p_"e") >= x) = 1 - prob((ln u) / (ln p_"e") < x) = 1 - (1 - p_"e"^x) = p_"e"^x,
$
#h(-indent) 所以这样得到的 $l_"m" = floor((ln u) / (ln p_"e"))$ 服从几何分布 $G(p_"e")$，符合我们的要求。

==== 高层

如果 $l_"m" >= |italic("layers")|$，就跳过这个环节；否则选取顶层的点作为入口。

对于比 $l_"m"$ 高的层，$p_"new"$ 不会出现在这些层中，因此不需要连边，但我们仍需要在他们中搜索最近邻，以简化后续层的搜索。具体来说，对这些层，我们只需从高到低执行 @algo:hnsw-layer-k_anns，并将获得的 $1$-ANN 作为下一层的入口点。

==== 低层

如果有高层传下来的入口就直接使用，否则取最高层的所有点作为入口。

对每一层，执行 @algo:hnsw-layer-k_anns，在结果中选出 $italic("new_edge_num")$ 个点与 $p_"new"$ 连边，再对这些点中度数超过限制的进行修剪。

“从结果中选出 $italic("new_edge_num")$ 个点”这一步，有以下两种办法。

===== 朴素方法

#algorithm[选择新邻居的朴素方法][
  #alg(
    title: $italic("selectNeighborsNaive")$,
    parameters: ($italic("layer")$, $p_"new"$, $italic("cands")$, $italic("new_edge_num")$),
  )[
    return the nearest $italic("new_edge_num")$ elements in $italic("cands")$ to $p_"new"$
  ]
]<algo:hnsw-select-neighbors-naive>

===== 启发式算法

额外的参数：
- $italic("extend_cands")$：是否扩展候选集，只适合再数据高度集中时设为真。
- $italic("keep_pruned_edges")$：是否保留被修剪的边。

#algorithm[选择新邻居的启发式算法][
  #alg(
    title: $italic("selectNeighborsHeuristic")$,
    parameters: (
      $italic("layer")$,
      $p_"new"$,
      $italic("cands")$,
      $italic("new_edge_num")$,
      $italic("extend_cands")$,
      $italic("keep_pruned_edges")$,
    ),
  )[
    $italic("neighbors") <- emptyset$ \
    if $italic("extend_cands")$: #algo.i \
    $italic("extra_cands") <- emptyset$ \
    for $italic("cand") in italic("cands")$: #algo.i \
    for $italic("extra_cand") in italic("cand").italic("adjs")$: #algo.i \
    $italic("extra_cands") <- italic("extra_cands") union {italic("extra_cand")}$ #algo.d #algo.d \
    $italic("cands") <- italic("cands") union italic("extra_cands")$ #algo.d \
    $italic("discarded") <- emptyset$ \
    while $italic("cands") != emptyset$ and $|italic("neighbors")| < italic("new_edge_num")$: #algo.i \
    let $italic("cand")$ be the nearest element to $p_"new"$ in $italic("cands")$ \
    $italic("cands") <- italic("cands") without {italic("cand")}$ \
    let $italic("neighbor")$ be the nearest element to $p_"new"$ in $italic("neighbors")$ \
    if $delta(p_"new", italic("cand")) < delta(p_"new", italic("neighbor"))$: #algo.i \
    $italic("neighbors") <- italic("neighbors") union {italic("cand")}$ #algo.d \
    else: #algo.i \
    $italic("discarded") <- italic("discarded") union {italic("cand")}$ #algo.d #algo.d \
    if $italic("keep_pruned_edges")$: #algo.i \
    while $italic("discarded") != emptyset$ and $|italic("neighbors") < italic("new_edge_num")$: #algo.i \
    let $italic("cand")$ be the nearest element to $p_"new"$ in $italic("discarded")$ \
    $italic("discarded") <- italic("discarded") without {italic("cand")}$ \
    $italic("neighbors") <- italic("neighbors") union {italic("cand")}$ #algo.d #algo.d \
    return $italic("neighbors")$
  ]
]<algo:hnsw-select-neighbors-heuristic>

==== 插入算法

#algorithm[插入算法][
  #alg(
    title: $italic("insert")$,
    parameters: (
      $italic("layers")$,
      $p_"new"$,
      $p_"e"$,
      $italic("new_edge_num")$,
      $italic("deg_lim")$,
      $italic("num")$,
    ),
  )[
    $italic("nns") <- emptyset$ \
    $italic("entries") <- italic("layers")_(|italic("layers")| - 1)$ \
    $u ~ U(0, 1)$ \
    $l_"m" <- floor((ln u) / (ln p_"e"))$ \
    for $l$ from $|italic("layers")| - 1$ down to $l_"m" + 1$: #algo.i \
    $italic("nns") <- italic("searchLayerAnns")(italic("layers")_l, italic("entries"), p_"new", 1)$ \
    $italic("entries") <- italic("nns")$ #algo.d \
    for $l$ from $min{l_"m", |italic("layers")| - 1}$ down to $0$: #algo.i \
    $italic("nns") <- italic("searchLayerAnns")(italic("layers")_l, italic("entries"), p_"new", italic("num"))$ \
    $italic("neighbors") <- italic("selectNeighbors")(p_"new", italic("nns"), italic("new_edge_num"))$ \
    $V(italic("layers")_l) <- V(italic("layers")_l) union {p_"new"}$ \
    for $italic("neighbor") in italic("neighbors")$: #algo.i \
    $E(italic("layers")_l) <- E(italic("layers")_l) union {(p_"new", italic("neighbor")), (italic("neighbor"), p_"new")}$ \
    if $deg italic("neighbor") > italic("deg_lim")$: #algo.i \
    $italic("neighbor").italic("adjs") <- italic("selectNeighbors")(italic("layers")_l, italic("neighbor"), italic("neighbor").italic("adjs"), italic("deg_lim"))$ #algo.d #algo.d \
    $italic("entries") <- italic("nns")$ #algo.d \
    for $l in NN inter [ |italic("layers")|, l_"m"]$: #algo.i \
    $italic("layers")_l <- ({p_"new"}, emptyset)$
  ]
]<algo:hnsw-insert>

== 参数选择

参数 $p_"e"$ 和第 $0$ 层的 $italic("deg_lim")$（记作 $italic("deg_lim")_0$）决定了图的小世界可导航性。考虑几种特殊情况：
- $p_"e" = 0, space italic("deg_lim")_0 = italic("new_edge_lim")$：据说此时建的图是一层有向 $k$-NN 图，据说其查询复杂度是指数级的。
- $p_"e" = 0, space italic("deg_lim")_0 = +infinity$：此时建立的是一层 NSW 图，据说其查询复杂度是对数多项式级别的。
#h(-indent) 一般地，当 $0 < p_"e" < 1$ 时，形成的 HNSW 图的查询复杂度是对数级的。

为了最大化可控层级结构的性能优势，对每个点来说，其在不同层上的共同邻居应尽量少。为了减少这个共同邻居，我们需要减小 $p_"e"$。但同时，减小 $p_"e"$ 又会让每一层上贪心搜索的步数增加。我们需要找到最佳的 $p_"e"$ 来平衡二者，以达到最优性能。

一个简单的选择是 $p_"e" = 1 / (italic("new_edge_num"))$。说是实验证明的。

论文建议 $italic("deg_lim")_0 = 2 italic("new_edge_num")$。他们发现 $italic("deg_lim")_0 = italic("new_edge_num")$ 时对于高目标召回率的性能会严重下降。

在选取邻居时，使用 @algo:hnsw-select-neighbors-heuristic 的性能会有与使用 @algo:hnsw-select-neighbors-naive 相比更优或相近的性能，且优势对于低维数据、中维数据的高目标召回率和高度集群的数据更加显著。

论文建议选择 $italic("new_edge_num") in NN inter [5, 48]$。实验显示较小的 $italic("new_edge_num")$ 对于低目标召回率和低维数据的结果更好，而较大的 $italic("new_edge_num")$ 对于高目标召回率和高维数据的结果更好。我没太看懂。算法的空间消耗正比于该参数。

建图时的 $italic("num")$ 必须足够大，以使算法在建图阶段的召回率接近统一（对于大多数应用情况 $0.95$ 足够了）@MALKOV201461。这个参数可以通过使用样例数据来自动配置 @MALKOV201461。我也没懂。

建图过程可以并行化，没有几个同步点（同步点是甚么？），对索引质量也没有影响（索引应该指的就是建出来的 HNSW 图？）。建图速度与索引质量之间的平衡由建图时的 $italic("num")$ 控制。作者用实验测出一个合理的选择是 $italic("num") = 100$。

== 复杂度分析

=== 查询的时间复杂度

看不懂推导，要求的背景知识太多了。

似乎查询复杂度是 $O(log n)$ 的，我觉得是意料之中，毕竟模仿了跳表的结构。

=== 建图的时间复杂度

论文说插入一个新点只不过是在各层上执行层内近似 KNN 搜索，并使用启发式的 @algo:hnsw-select-neighbors-heuristic 筛选邻居。固定 $italic("num")$ 时，@algo:hnsw-select-neighbors-heuristic 的复杂度是 $O(1)$。一个新点参与的层数的期望
$
  expect(l_m + 1) = 1 / p_"e" + 1
$
#h(-indent) 与数据规模 $n$ 无关。因此，至少对于相对低维的数据（我不知道为甚么有这个限制），建图的总复杂度为 $O(n log n)$。

=== 空间复杂度

每个元素的平均空间占用是 $italic("new_edge_num")_0 + 1 / p_"e" dot italic("new_edge_num")$ 条边。

== 方法对比和讨论

先跳过了。

= 基于 NSG 的 ANN 算法 #label("10.14778/3303753.3303754")

这个 navigating spreading-out graph 也不知道怎么翻译，导航伸展图？

基于图的方法降低了索引复杂度，在百万级数据集上展现了革命性的性能，但仍不能扩展到（scale to）数十亿节点的数据库。为了进一步提升基于图的方法的搜索效率和 （规模的）可扩展性（scalability），这篇论文从四个方面考虑：
+ 保证图的连通性。
+ 降低图的平均出度，以加快遍历。
+ 缩短搜索路径。
+ 减小索引大小。
#h(-indent) 然后，他们提出了一个新的图结构，称为单调相对邻近图（monotonic relative neighborhood graph, MRNG），他能使搜索复杂度非常低（接近对数时间）。为了进一步降低索引复杂度，并让该方法能实际用于十亿节点的 ANNS 问题，他们通过对 MRNG 做近似，又提出了一种新的图结构，称作导航伸展图（我自己翻译的，navigating spreading-out graph, NSG）。这种图结构同时考虑到了上面说的四个方面。大量实验证明 NSG 显著优于所有现有算法，屌得没边。另外，NSG 在淘宝得电商搜索中展现了优越的性能，而且已经被整合进了他们十亿节点规模的搜索引擎（牛逼）。

这篇论文#strong[只考虑欧几里得空间]。

#algorithm[贪心搜索算法][
  #alg(
    title: $italic("greedySearchAnns")$,
    parameters: ($G$, $italic("src")$, $italic("qry")$, $italic("num")$, $italic("pool_sz")$),
  )[
    $italic("cands") <- (italic("src"))$ \
    $italic("seen") <- emptyset$ \
    $italic("checked") <- emptyset$ \
    while true: #algo.i \
    $italic("fst") <- 0$ \
    while $italic("fst") < |italic("cands")|$ and $italic("cands")_italic("fst") in italic("checked")$: #algo.i \
    $italic("fst") <- italic("fst") + 1$ #algo.d \
    if $italic("fst") = |italic("cands")|$: #algo.i \
    break #algo.d \
    $italic("checked") <- italic("checked") union {italic("cands")_italic("fst")}$ \
    for $italic("neighbor") in V(G)$ s.t. $(italic("cands")_italic("fst"), italic("neighbor")) in E(G)$: #algo.i \
    if $italic("neighbor") in.not italic("seen")$: #algo.i \
    $italic("seen") <- italic("seen") union {italic("neighbor")}$ \
    $italic("cands") <- mat(italic("cands"); italic("neighbor"))$ #algo.d #algo.d \
    sort $italic("cands")$ by distance to $italic("qry")$ \
    keey only the first $italic("pool_sz")$ elements in $italic("cands")$ #algo.d \
    return the first $italic("num")$ elements in $italic("cands")$
  ]
]<algo:nsg-greedy-k_anns>

== 动机

影响贪心算法效率最关键的两个因素是：
- 从起始点到结果的步数。
- 每一步寻找下一个落脚点的计算代价。
#h(-indent) 论文将一次查询的时间复杂度写为 $O(o dot l)$，其中 $o = 1 / (|V(G)|) sum_(v in V(G)) deg^+ v$ 表示图的平均出度，而 $l$ 为搜索路径的长度。

在最近提出的基于图的算法中，图的出度被当作一个可调控的参数。在作者的实验中，对于给定的数据集和目标准确度，他们发现这些算法存在最优的出度，搜索性能最优。一个可能的解释是，对于给定的目标准确度，$o dot l$ 是关于 $o$ 的凸函数（convex function，下凸）。在高准确度区间，一些算法（例如 GNNS、NSW、DPG）的最优出度非常巨大，这导致了非常大的图尺寸。其他的算法使用了额外的索引结构来改进贪心算法的初始位置，以直接减小 $l$，但这也会导致索引空间变大。

作者希望通过同时减小 $o$ 和 $l$ 来提高性能。人们总是忽略的一件事是必须首先保证图的连通性。于是作者提出了之前说的四个考虑方面。对于初始点可能变化的情况，必须保证图强连通；如果初始点是固定的，只需保证整张图从初始点单向连通。

我操，我突然想到，HNSW 的 @algo:hnsw-insert 在建图时，每一层加入新点并双向连边后会对出度过高的邻居进行修剪，这显然可能导致图不强连通。此时有一些最优点会因为图上到达不了而无法被访问。

== 图的单调性

考虑 $d$ 维欧几里得空间 $E_d$。

#definition[开球][
  对任何 $c in E_d$，称
  $
    B(c, r) = {x in E_d: delta(c, x) < r} space (c in E_d, r >= 0)
  $
  #h(-indent) 为以 $c$ 为球心，$r$ 为半径的#emph[开球（open sphere）]。
]<def:open-sphere>

#definition[单调路径][
  给定有限的点集 $S subset.eq E_d$、图 $G space (V(G) = S)$ 和点 $p,q in S$。设 $v = (v_i)_(i = 0)^(n - 1) in S^n space (n in NN)$ 是 $G$ 上一条从 $p$ 到 $q$ 的路径（path）。称 $v$ 是从 $p$ 到 $q$ 的一条#emph[单调路径（monotonic path）]，当且仅当
  $
    (forall i in NN inter [1, n)) space (delta(q, v_i) < delta(q, v_(i - 1))).
  $
]<def:monotonic-path>

#definition[单调搜索网络][
  给定有限的点集 $S subset.eq E_d$ 和图 $G space (V(G) = S)$。称 $G$ 是一个#emph[单调搜索网络（monotonic search network, MSNET）]，当且仅当对任意 $p,q in S$ 都存在从 $p$ 到 $q$ 的单调路径。
]<def:monotonic-search-network>

MSNET 因为保证图上任意两点之间都存在路径而天然是强连通的。

作者认为，在 MSNET 上，只需执行贪心算法就可以按照单调路径到达目标点而无需在到达局部最优时回溯（但我感到困惑的是，实际查询时输入的是一个不在图上的点（查询的点在图上是一个平凡的情况），@def:monotonic-search-network 保证的却是图上已有的点之间都存在单调路径，这个逻辑链并不完整）。MSNET 的单调性使贪心算法的搜索行为几乎是确定且可分析的。

#theorem[MSNET 上的贪心路径单调性][
  设 $S subset.eq E_d$ 是 $E_d$ 中随机分布（甚么叫随机分布？）的有限个点的集合，图 $G space (V(G) = S)$ 是 MSNET，则对任意 $p,q in S$ 都可以在 $G$ 上执行 @algo:nsg-greedy-k_anns 得到一条从 $p$ 到 $q$ 的单调路径。
]<thm:msnet-greedy-path-monotonicity>

作者把证明放到了附录，那我就先不管了。

#lemma[MSNET 的开球定义][
  给定有限的点集 $S subset.eq E_d$ 和图 $G space (V(G) = S)$，则 $G$ 是一个 MSNET，当且仅当
  $
    (forall p,q in S) space (exists r in S) space ((p, r) in E(G) and r in B(q, delta(q, p))).
  $
]<lem:msnet-open-sphere-definition>

这个引理倒是比较显然，瞪一眼就可以看出证明。

#cite(label("10.14778/3303753.3303754"), supplement: [Theorem 2]) 表述一片混乱，条件不清晰，叽里咕噜不知道说甚么，GPT 甚至怀疑他不严谨，跳过得了。狗屎东西，怎么写的论文。

== MRNG

HNSW 和 FANNG 都采用了相对邻近图（relative neighborhood graph, RNG），以使图稀疏。作者说，有人发现 RNG 的边不够多，不能形成 MSNET，所以在 RNG 上的搜索路径长度没有理论保证，可能会绕很长的远路。然而，这篇论文我下载不了，ScienceDirect 提示说我的学校没订阅。神了。

作者认为这个问题主要是由于 RNG 的选边策略。前人尝试了通过向 RNG 加入额外的边来用最少的边构建 MSNET，但这个办法非常耗时间。于是，受 RNG 的启发，作者提出了一种新的选边策略来构建单调图。这样构建的图可能不是最小的 MSNET，但也非常稀疏。基于该策略，他们提出了新的图结构 MRNG：
#definition[单调相对邻近图][
  给定一个有限的点集 $S subset.eq E_d$。有向图 $G$ 称为 $S$ 上的一张#emph[单调相对邻近图（monotonic relative neighborhood graph, MRNG）]，当且仅当
  $
    (forall p,q in S) space ((p, q) in E(G) <-> ((forall r in italic("lune")(p, q) inter S) space ((p, r) in.not E(G)))),
  $
  #h(-indent) 其中
  $
    italic("lune"): (p, q) |-> B(p, delta(p, q)) inter B(q, delta(p, q)) space (p, q in E_d).
  $
]<def:monotonic-relative-neighborhood-graph>

我不知道为甚么把两个球得交集叫做 lune（弓形/半月形），明明这是两个弓形啊？

这是一个递归定义。因为
$
  r in italic("lune")(p, q) -> delta(p, r) < delta(p, q),
$
#h(-indent) 所以在考虑 $p$ 要连哪些边时，按 $scripts(<=)_p$ 排序各点，对每个点 $q$，$(p, q)$ 要不要加到图中，可以完全由比 $q$ 更靠近 $p$ 的点的连边情况决定。

RNG 要求 $(p, q) in E(G) <--> italic("lune")(p, q) inter S = emptyset$，即两点之间的凸透镜形区域内不能有别的点（否则应把两个点分别连接到该中介点上来替代）。而 MRNG 放宽要求，要么是空集，不是空集的话，只要从起始点到中介点没有连边就行。一张 RNG 必然是一张 MRNG。

特别地，论文加强了 $scripts(<=)_p$ 的定义。他通过为为每个点 $x in S$ 分配唯一编号 $italic("id")(x)$，定义
$
  scripts(<=)_p = {(x, y) in S^2: delta(p, x) < delta(p, y) or (delta(p, x) = delta(p, y) and italic("id")(x) < italic("id")(y))}.
$
#h(-indent) 在这种定义下，$scripts(<=)_p$ 构成一个全序关系。这样，将点按照到某一点的距离排序时，排序结果是唯一确定的。

#theorem[MRNG 是 MSNET][
  给定有限的点集 $S subset.eq E_d$，设 $G space (V(G) = S)$ 是 $S$ 上的 MRNG，则 $G$ 是 MSNET。
]<thm:mrng-is-msnet>

#definition[最近邻图][
  给定有限的点集 $S subset.eq E_d$。有向图 $G$ 称为 $S$ 上的一张#emph[最近邻图（nearest neighbor graph, NNG）]，当且仅当
  $
    (forall p in S) space (forall q in S) space ((p, q) in E(G) <-> ((forall r in S) space (delta(p, q) < delta(p, r)))).
  $
]<def:nearest-neighbor-graph>

同一个 $S$ 上的任何 NNG、RNG、MRNG 都满足
$
  E(italic("NNG")) subset.eq E(italic("RNG")) subset.eq E(italic("MRNG")).
$

#lemma[
  设 $G$ 是 $E_d$ 中的一个 MRNG，则 $G$ 的最大度数 $Delta(G)$ 是与 $|V(G)|$ 无关的常量。
]<lem:mrng-constant-max-degree>

由 @lem:mrng-constant-max-degree、@thm:msnet-greedy-path-monotonicity 和那个写得乱七八糟不知道在说甚么的定理，作者得出 MRNG 上的搜索复杂度是 $O((a dot n^(1 / d) log n^(1 / d)) / (Delta r))$，其中 $n = |V(G)|$，$a = 1 / n sum_(v in V(G)) deg v$，$Delta r$ 是 $n$ 的非常地递减的函数。

作者采用了一种朴素的方式来构建 MRNG，即对每个顶点应用选边策略。具体来说，
#algorithm[MRNG 构建算法][
  给定一个有限的点集 $S subset.eq E_d$。记 $n = |S|$。对每个点 $p in S$：
  + 将 $S without {p}$ 按 $scripts(<)_p$ 排序，记作 $r = (r_i)_(i = 0)^(n - 2)$。
  + 设已选择的点形成集合 $A$。初始时，$A = emptyset$。
  + 让 $i$ 从 $0$ 遍历到 $n - 2$：
    + 如果存在 $q in A$ 满足 $p r_i$ 不是 $triangle p q r_i$ 中最长的边，即 $delta(p, r_i) < max{delta(p, q), delta(r_i, q)}$，则 $A <- A inter {r_i}$。

  算法的时间复杂度是 $O(n^2 log n + a dot n^2)$，其中 $a$ 是 MRNG 的平均出度。
]<algo:mrng-construction>

前人构造 MSNET 索引的方法的时间复杂度在随机点分布下最少为 $O(n^(2 - 2 / (d + 1) + epsilon) + n^2 log n + n^3)$，@algo:mrng-construction 的时间复杂度比他小得多。

== NSG：MRNG 的实用近似

尽管 MRNG 能保证很快的搜索速度，他的索引时间还是高到不能实际用于大规模问题。于是，作者通过近似 MRNG，给出了一个实用的方法，他们把这样构造出来的图命名为导航伸展图（navigating spreading-out graph, NSG，这个中文名是我自己翻译的）。

=== 构造

#algorithm[NSG 构造算法][
  + 用现有的最先进的方法构建一张近似 $italic("num")$-NN 图 $G$。
  + 估计数据集的中心点（medoid）。
    + 计算数据集的质心（centroid）。
    + 在 $G$ 上对质心执行 @algo:nsg-greedy-k_anns，将其得到的最近的那个邻居作为近似的中心点。将这个点称作#emph[导航节点（navigating node）]，因为所有的搜索都会从这一点出发。
  + 对每个点，从候选集中选取邻居，形成候选邻居集。具体来说，对于每个 点 $p$：
    + 在 $G$ 上，从中心点出发对 $p$ 执行 @algo:nsg-greedy-k_anns，
    + 在搜索过程中，把每个计算过距离的点 $q$ 加入到候选集。
    + 按照 MRNG 的选边策略，从候选集中选出最多 $Delta^+(italic("NSG"))$（人为设置的参数，即构建出的 $italic("NSG")$ 的最大出度）个邻居。
  + 在以上步骤构建出的图上，生成从导航节点出发的 DFS 树。如果还有孤立的点，就将他们连到通过执行 @algo:nsg-greedy-k_anns 获得的近似最近邻上，然后继续 DFS。

  #alg(
    title: $italic("buildNsg")$,
    parameters: ($G$, $Delta^+(italic("NSG"))$, $italic("pool_sz")$),
    breakable: true,
  )[
    $c <- 1 / (|V(G)|) sum_(v in V(G)) v$ \
    let $italic("rand")$ be a random vertex in $V(G)$ \
    ${italic("nav")} <- italic("greedySearchAnns")(G, italic("rand"), c, 1, italic("pool_sz"))$ \
    $italic("NSG") <- (V(G), emptyset)$ \
    for $v in V(G)$ #algo.i \
    let $italic("vis")$ be the set of all the vertices visited when perfoming $italic("greedySearchAnns")(G, italic("nav"), v, 1, italic("pool_sz"))$ \
    $italic("vis") <- italic("vis") union {italic("neighbor") in V(G): (v, italic("neighbor")) in E(G)}$ \
    let $italic("vis")$ be the sorted list of $italic("vis")$ by $scripts(<)_v$ \
    $italic("res") <- emptyset$ \
    for $i$ from $0$ to $|italic("vis")| - 1$: #algo.i \
    if $|italic("res")| == Delta^+(italic("NSG"))$: #algo.i \
    break #algo.d \
    $italic("has_conflict") <-$ false \
    for $r in italic("res")$: #algo.i \
    assert $delta(v, r) <= delta(v, italic("vis")_i)$, i.e., $r in B(v, delta(v, italic("vis")_i))$ \
    if $delta(r, italic("vis")_i) < delta(v, italic("vis")_i)$: #algo.i \
    assert $r in italic("lune")(v, italic("vis")_i) = B(v, delta(v, italic("vis")_i)) inter B(italic("vis")_i, delta(v, italic("vis")_i))$
    $italic("has_conflict") <-$ true \
    break #algo.d #algo.d \
    if $italic("has_conflict")$: #algo.i \
    continue #algo.d \
    $italic("res") <- italic("res") union {italic("vis")_i}$ \
    $E(italic("NSG")) <- E(italic("NSG")) union {(v, italic("vis")_i)}$ #algo.d #algo.d \
    $italic("vis") <- emptyset$ \
    func $italic("dfs")(italic("cur"))$: #algo.i \
    $italic("vis") <- italic("vis") union {italic("cur")}$ \
    for $italic("nxt") in V(italic("NSG"))$  s.t. $(italic("cur"), italic("nxt")) in E(italic("NSG"))$: #algo.i \
    if $italic("nxt") in.not italic("vis")$: #algo.i \
    $italic("dfs")(italic("nxt"))$ #algo.d #algo.d #algo.d \
    $italic("dfs")(italic("nav"))$ \
    while $|italic("vis")| < |V(italic("NSG"))|$: #algo.i \
    let $v$ be any vertex in $V(italic("NSG")) without italic("vis")$ \
    ${italic("ann")} <- italic("greedySearchAnns")(italic("NSG"), italic("nav"), v, 1, italic("pool_sz"))$ \
    assert $italic("ann") in italic("vis")$ \
    $E(italic("NSG")) <- E(italic("NSG")) union {(italic("ann"), v)}$ \
    $italic("dfs")(v)$ #algo.d \
    return $italic("NSG")$
  ]
]<algo:nsg-construction>

=== 动机

+ MRNG 保证任意两点间都存在至少一条单调路径。然而，这个性质太强了，以至于构造这样一张图是比较麻烦的。作为替代，作者选出仅仅一个点，并努力保证从这一个点到其他任何点都存在单调路径，并把这个点称作导航点。当执行搜索时，总是从导航点开始，这使得 NSG 上的搜索几乎和 MRNG 上的一样高效。
+ MRNG 的选边策略把其他所有点都当作当前点的候选邻居，这使得构造 MRNG 的时间复杂度很高。为了加速这一过程，作者希望对每个点生成一个比较小的候选点子集。这些候选点包括两部分：
  + 最近邻是为了保证单调性而必要的部分。求解精确 NNG 是非常耗时间的，所以作者转向了近似 KNN 图。一张高质量的近似 KNN 图常常包含了高质量的 NNG。只有一小部分点没有连到其最近邻是可以接受的。
  + 因为 NSG 上的搜索总是从导航点 $italic("nav")$ 开始，对给定的点 $p$，我们只需要考虑在从 $italic("nav")$ 到 $p$ 的搜索路径上的点。因此，考虑在预先构建的 KNN 图上执行 @algo:nsg-greedy-k_anns，将搜索过程中访问到的点以及 $p$ 的邻接点作为候选集。从 $italic("nav")$ 到 $p$ 的单调路径很可能包含在这个候选集中。当我们在这些候选点中执行 MRNG 选边策略时，NSG 很可能继承从 $italic("nav")$ 到 $p$ 的单调路径。
  + 以上方法的一个可能的问题是有些顶点可能发生度数爆炸，特别是导航点以及密集区域的点，他们会扮演交通枢纽的角色。在 HNSW 中也有这个问题 @8594636，他们的办法是构建一个分层的图结构，但这个解决方案显著增加了内存使用。作者的方案是把所有点的出度都限制在一个比较小的值，度数过大时舍弃掉较长的边。这样做的结果是，图的连通性因删边而不再得到保证。
  + 为了解决连通性的问题，他们又引入了一个新的基于 DFS 生成树的方法。尽管在最坏情况下这个方法会牺牲一些性能，但只要预先构建的近似 KNN 图质量足够高并选择一个合适的最大出度限制，NSG 上绕的远路就会被最小化。

通过对 MRNG 做近似，NSG 可以继承与之相近的低搜索复杂度。同时，设置的度数上线让整张图非常稀疏。而生成树操作又保证了 NSG 的连通性。NSG 的索引只包括一张稀疏的图，没有其他辅助结构。

=== 复杂度分析

==== 索引复杂度

总的索引复杂度包括两部分：
+ KNN 图的构建。
+ NSG 的预处理步骤：
  + 搜索-收集-选择操作。
  + 树的生成。

因为 KNN 图是对 Delaunay 图的近似，而 Delaunay 图又是一种 MSNET，所以 $k$-NN 图上的搜索复杂度近似是 $O(k dot n^(1 / d) log n^(1 / d) \/ Delta r)$。因为要对所有的点都执行搜索，所以总的复杂度大约是 $O(k dot n^(1 + 1 / d) log n^(1 / d) \/ Delta r)$。选边的复杂度是 $O(n dot |italic("vis")| dot Delta^+(italic("NSG")))$，其中 $italic("vis")$ 是在 KNN 图上执行 @algo:nsg-greedy-k_anns 访问的点的集合。因为实际中 $|italic("vis")|$ 和 $Delta^+(italic("NSG"))$ 通常非常小（$|italic("vis")|, Delta^+(italic("NSG")) << n$），所以这个过程非常快。而树生成也非常快，因为图的强连通分量的个数通常远远小于 $n$，我们只需额外加很少数量的边。可以看到，最耗时的环节是“搜索-收集”部分，因此这些过程的总复杂度大约就是 $O(k dot n^(1 + 1/ d) log n^(1 / d) \/ Delta r)$，实验也验证了这一点。作者在实验中还发现 $Delta r$ 几乎是常数。

作者的实现给出的经验复杂度是 $O(k dot n^(1 + 1 / d) log n^(1 / d) + f(n))$，其中使用 $italic("nn")$-下降算法时 $f(n) = n^1.16$，而使用 Faiss 时 $f(n) = n log n$。这比 MRNG 的 $O(n^2 log n + a dot n^2)$ 要小得多。

==== 搜索复杂度

作者说平均搜索复杂度近似是 $O(Delta^+(italic("NSG") dot n^(1 / d) log n^(1 / d) \/ Delta r))$。在他们的实验中，$Delta r approx O(n^(- epsilon / d)) space (0 < epsilon << d)$，因此经验的平均复杂度是 $O(Delta^+(italic("NSG")) dot n^((1 + epsilon) / d) log n^(1 / d)) approx O(log n)$。

== 实验

跳过。

== 讨论

作者觉得他们的方法屌爆了。

作者认为让 NSG 支持增量索引是可能的，他们将其留给后人。

= 基于图的 ANNS 的综述与实验对比

这论文怎么每句话都引参考文献……

== 引言

根据采用的索引，现有的 ANNS 算法可以分为四大类：
- 基于哈希的。
- 基于树的。
- 基于量化的。
- 基于图的。
#h(-indent) 近年来，基于图的算法作为 ANNS 的一个效果非常好的选项而兴起。由于他们表示邻近关系的超凡能力，他们需要计算的点更少，获得的结果反而还更精确。

=== 动机

作者觉得现有的 survey 有以下几个问题。

==== 缺乏合理分类和算法间比较分析

现有的基于图的 ANNS 算法一般是从不同视角对四种经典基础图的派生：
- Delaunay 图（Delaunay graph, DG）。
- 相对邻近图（relative neighborhood graph, RNG）。
- K-近邻图（k-nearest neighbor graph, KNNG）。
- 最小生成树（minimum spanning tree, MST）。

==== 缺少对算法内细粒度组件的分析和比较

作者认为，许多研究仅仅比较和分析了两个粗粒度的组件，即构造和搜索，而阻碍了对关键组件的理解。作者认为，构造和搜索可以被进一步划分称许多细粒度组件，例如候选邻居的获取、邻居选择、种子选择和路由。作者在对这些细粒度组件的分析中发现了一些有趣的现象。

==== 人们需要更丰富的指标来评估基于图的 ANNS 算法的总体

作者认为，许多评估都聚焦于准确度与效率的权衡，这主要反映的是算法的搜索性能。随着数据规模的爆炸式增长和日渐增加的对高频更新数据的要求，索引构建的效率和算法的索引空间大小受到了越来越多的关注。相关的指标，例如图质量（可以由连到了最近邻的顶点的比例来衡量）、平均出度等，间接影响着索引的构造效率和大小。

==== 多样化的数据集对于基于图的 ANNS 算法的可扩展性评估是必要的

一些基于图的 ANNS 算法仅仅在少量的数据集上进行了评估，这限制了对他们在不同数据集上的可扩展性的分析。

=== 贡献

+ 基于四种基本图，作者提供了一种基于图的 ANNS 算法的新的分类方法。
+ 作者展示了由七个用于分析基于图的 ANNS 算法的细粒度组件组成的统一管道（？）。
+ 作者使用更多指标和多种数据集，组织了一场对代表性的基于图的 ANNS 算法的综合评估。
+ 作者关于基于图的 ANNS 算法讨论了推荐选项、指导方针、改进、趋势和挑战。

== 基于图的 ANNS 的概览

作者只考虑 $d$ 维欧几里得空间 $E_d$。

=== ANNS 的基图

==== DG

只考虑欧几里得空间时，Delaunay 图（DG）可以有比 @def:delaunay-graph 更强的定义：
#theorem[欧几里得空间的 Delaunay 图][
  设欧几里得空间 $E_d$ 中有一个有限点集 $P$，则 $P$ 上的 Delaunay 图 $G = (P, E)$ 满足
  $
    E = {{p, q} subset.eq P: p != q and ((exists c in E_d) space (exists r > 0) space (p,q in partial B(c, r) and P inter B(c, r) = emptyset))}.
  $
]<thm:delaunay-graph-in-euclidean-space>

DG 保证 ANNS 总是返回精确结果，但其弊端时当 $d$ 极高时，DG 几乎是完全图，这导致搜索空间会非常大。

==== RNG

在 $E_d$ 中的有限点集 $P$ 上构建的 RNG 为无向图 $G = (P, E)$，其中
$
  E = {{p, q} subset.eq P: p != q and ((forall r in P without {p, q}) space (delta(p, q) <= max{delta(p, r), delta(q, r)}))}.
$

相比于 DG，RNG 切除了一些多余的邻居（互相过于靠近），并使剩余 的邻居沿各个方向分布，由此减少 ANNS 的距离计算次数。然而，构建 RNG 的时间复杂度是 $O(|P|^3)$。

==== KNNG

$k$-NNG 是一张有向图，每个点连到离他最近的 $k$ 个点上。$k$-NNG 将每个点的最大出度限制在最大为 $k$，在存储空间有限和对效率要求很高的场景下表现很好。但 KNNG 不保证图的全局强连通性，对 ANNS 不是很友好。

==== MST

尽管 MST 尚未被大多数现有的基于图的 ANNS 算法使用，但 HCNNG 确认了 MST 作为 ANNS 的一种邻居选择策略的有效性。使用 MST 作为基图的主要好处在于 MST 能使用最少的边来保证图的全局连通性，以便在保持低度数的同时让任意两个点都可达。然而，因为却反捷径，在 MST 上搜索可能会绕远路。

=== 基于图的 ANNS 算法

==== 基于 DG 和 RNG 的 ANNS 算法

为了解决 DG 在高维清醒下的高度数问题，有人提出了一些轻微的改进。然而，他们高度依赖 DG 的质量，而且也存在维度诅咒。因此，一些算法在 DG 上添加了一张近似的 RNG 来让邻居的分布更多样。

===== NSW

NSW 通过连续插入元素并保证全局连通性，构造出一张无向图（近似的 DG）。这里的直觉是，对于精确 DG 来说，从任意种子出发的贪心搜索的结果总是精确最近邻。在构造初期形成的长边具有小世界导航性能，保证了搜索的效率；后插入的点形成的短边则保证了搜索的准确性。然而，NSW 提供的效率与效果权衡是有限的，因为他的搜索复杂度是对数多项式级别的。

===== HNSW

为了克服 NSW 的对数多项式搜索复杂度，有论文提出了一种改进方向。由此启发了 HNSW，他生成一张分级的图并且固定每个点的度数上界，由此实现了对数复杂度的搜索。他的基本想法是把邻居按照距离的规模分到不同的层级上，然后搜索就是一个从上到下的迭代过程。对于一个新插入的点，HNSW 不仅选取其最近的邻居们（形成近似 DG），还考虑了邻居的分布（形成近似 RNG）。然而，他的多层结构显著增加了存储使用，使他难以扩展到更大的数据集。同时，实验证明，随着#strong[内在维度]增加，分级结构的优势会逐渐消失。

===== FANNG

快速近似近邻图（fast approximate nearest neighbor graph, FANNG）提出了一种遮挡规则来切除多余的邻居（近似 RNG）@7780985。不过看起来这个遮挡规则在理想情况下就是 MRNG 的选边策略。因为遮挡规则要应用到除了数据集中目标点以外的所有点，所以其构造复杂度非常高。@7780985 提出了两种直觉的优化来缓解该问题。为了提高准确性，FANNG 会回溯到次近的顶点并考虑他尚未探索过的边。

===== NGT

邻域图与树（Neighborhood Graph and Tree, NGT）是由 Yahoo 日本发布的用来进行高速 ANNS 的库。他包括两种构建方法：
- 将 KNNG 转变为双向的 KNNG（Bi-directed KNNG, BKNNG）。
- 像 NSW 一样增量构建。与 NSW 不同的地方在于构建期间使用了范围搜索（贪心搜索的一个变体）。
#h(-indent) 这两种方法都会使特定的枢纽节点具有较高的出度。因此，NGT 使用了三种度数调整方法来缓解该问题，其中最有效是对 RNG 的一种近似。这减小了空间开销并提高了搜索效率。NGT 通过 VP-树来获得种子顶点（即初始顶点），然后使用范围搜索来进行路由。

==== 基于 KNNG 的 ANNS 算法

KNNG 的朴素构造方法是琼剧所有点对并比较距离，这对于大的数据集来说是令人望而却步地慢且不合适的。一些早期的解决方案会构造一个额外的索引（例如树或哈希），然后通过 ANNS 寻找每个点的邻居。然而，这些方法一般都苦于高的索引构建复杂度。有两种只聚焦于图构建的代表性解决方案。

===== SPTAG

一种方案是基于分治，其代表是空间划分树与图（Space Partitioning Tree and Graph, SPTAG），这是由微软发布的一个库。SPTAG 通过三投影树将数据集层次化地划分为若干子集，然后在每个子集上构建起一张精确 KNNG。另外，SPTAG 通过执行邻域传播，进一步提高了 KNNG 的准确性。

早期版本的 SPTAG 在数据集上增加了多个 KD-树，但在极高维度的数据集上，这些 KD-树会产生不准确的距离界限估计。因此，他们现在构建平衡 K-均值树来替代 KD-树。

===== KGraph

另一种方案是基于 NN-下降的。他的基本思路是“我的邻居的邻居很可能是我的邻居”。KGraph 第一个采用了这种思想，把KNNG 的构造复杂度降低到了 $O(n^1.14)$。他达到了比 NSW 更优的搜索性能。因此，人们发展了一些基于 NN-下降的衍生方法来探索他的潜能。

===== EFANNA 和 IEH

在构造过程中没有（像 KGraph 一样）进行随机初始化，极快的 ANNS 算法（extremely fast approximate nearest neighbor algorithm, EFANNA）先在数据集上构建多个 KD-树，然后通过在这些 KD-树上执行 ANNS 来更好地初始化每个点的邻居，再运行 NN-下降。再搜索阶段，EFANNA 也使用了这些 KD-树来获得更靠近查询点的种子点。通过附加结构来初始化种子点的想法是受到了迭代式扩展哈希（iterative expanding hashing, IEH）的启发，这种算法使用哈希桶来获得更优的种子。然而，IEH 的 KNNG 在其原论文中是通过暴力法构建的。

==== 基于 KNNG 和 RNG 的 ANNS 算法

对 KGraph 的早期优化仅限于提高图的质量，其直觉是更高的图质量能导致更优的搜索性能。因此每个顶点仅仅连接到最近的若干个邻居而没有考虑邻居的分布。如果一个访问到的点的邻居互相比较接近的话，这个顶点会让搜索走向相同的位置。

===== DPG

为了克服这一问题，多样化的邻近图（diversified proximity graph, DPG）实行优化来控制 KGraph 上邻居的分布。他设置同一顶点的邻居间的夹角阈值，以使该顶点的邻居在各个方向均匀分布。这只是 RNG 在另一个方面上的近似实现。另外，为了处理有大量聚类的数据集，DPG 在图上保留了双向连接的边。

===== NSG

尽管 DPG 的搜索性能可以媲美 HNSW，他仍苦于巨大的索引。为了解决这一问题并进一步提高搜索性能，NSG 提出了一种基于 MRNG 的选边策略，这种策略实际上等价于 HNSW 的策略。他的构造就框架受到 DPG 的启发，也就是在 KNNG 上修剪边。NSG 通过在 KGraph 上执行 ANNS 获得候选邻居来保证高构建效率。

===== NSSG

导航卫星系统图（navigating satellite system graph, NSSG）继续探索了在 KNNG 上修剪边的潜力，并提出了一种基于卫星系统图（satellite system graph, SSG）的选边策略。当获得了一个顶点的候选邻居时，这种算法不是像 NSG 一样实施 ANNS，而是得到这个顶点在 KNNG 上的邻居们和邻居们的邻居们，从而显著提高了构建效率。SSG 和 MRNG 都是对 RNG 的近似，但 SSG 修剪边的条件更弱，因此有更大的出度。尽管原论文相信 SSG 比 MRNG 更有利于 ANNS，作者通过更公平的评估得出了相反的结论（没绷住）。

===== Vamana

微软最近提出了 Vamana 来结合固态硬盘的特点，以适配数十亿规模的数据。他分析了 HNSW 和 NSG 的构建细节，提取并结合了他们的精华部分。他的构建框架受到 NSG 的启发。不是使用 KGraph 来初始化，Vamana 的初始化是随机的。当选择邻居时，Vamana 通过增加一个参数 $alpha$ 来增加选边的灵活性，并用不同的 $alpha$ 来运行两次，从而改进 HNSW 的策略。实验证明他构建的图在搜索时拥有更短的平均路径长度。

==== 基于 MST 的 ANNS 算法

===== HCNNG

不同于之前的工艺，最近一项名为层次化的基于聚类的近邻图（hierarchical clustering-based nearest neighbor graph, HCNNG）的方法使用 MST 来连接数据集上的点。HCNNG 通过多个层次化的聚类来划分数据集，而每个聚类内部的点通过 MST 连接。HCNNG 使用多个全局 KD-树来获得种子（就像 SPTAG 和 EFANNA 一样）。然后，为了提高效率，他执行一种高效的有引导的搜索，而非使用传统的贪心搜索。

#pagebreak()

#bibliography(
  "references.bib",
  title: "参考文献",
  full: true,
)
