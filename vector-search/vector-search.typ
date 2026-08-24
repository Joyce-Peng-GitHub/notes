#import "@preview/ctheorems:1.1.3": *
#show: thmrules
#import "@preview/algo:0.3.6": algo, code, comment, d, i, no-emph

#let definition = thmbox("definition", "定义")
#let theorem = thmbox("theorem", "定理")
#let lemma = thmbox("lemma", "引理")
#let proof = thmproof("proof", "证明")
#let algorithm = thmbox("algorithm", "算法")

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

#let algo-keywords = ("func", "if", "else", "for", "while", "break", "continue", "return", "let")

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
  考虑度量空间 $(X, delta)$。设空间中有一个#strong[有限的]“生成点”集合（实际问题中的已知数据点）$P subset.eq X$。对于任意 $p in P$，其#emph[Veronoi 区域（Voronoi region）]定义为
  $
    V(p) = {x in X: (forall q in X, space q != p) space (delta(x, p) <= delta(x, q))}.
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
  $
     1 & space bold("func") italic("greedySearchAnn")(italic("src"), italic("qry")): \
     2 & space wide bold("while") italic("true"): \
     3 & space wide wide italic("best") <- italic("src") \
     4 & space wide wide d_"min" <- delta(italic("best"), italic("qry")) \
     5 & space wide wide bold("for") v in italic("src").italic("adjs"): \
     6 & space wide wide wide d <- delta(v, italic("qry")) \
     7 & space wide wide wide bold("if") d < d_"min": \
     8 & space wide wide wide wide italic("best") <- v \
     9 & space wide wide wide wide d_"min" <- d \
    10 & space wide wide bold("if") italic("best") = italic("src"): \
    11 & space wide wide wide bold("return") italic("src") \
    12 & space wide wide italic("src") <- italic("best")
  $
]<algo:nsw-greedy-anns>

#algorithm[用于 K-ANN 的基本贪心算法][
  $
    1 & space bold("func") italic("greedySearchKAnn")(italic("qry"), italic("num"), italic("rep")): \
    2 & space wide italic("cands") <- emptyset \
    3& space wide italic("vis") <- emptyset \
    4 & space wide italic("res") <- emptyset \
    5 & space wide #text[repeat for $italic("rep")$ times:] \
    6 & space wide wide #text[randomly select a $italic("src") in X$ and $italic("cands") <- italic("cands") union {italic("src")}$] \
    7 & space wide wide italic("tmp_res") <- emptyset \
    8 & space wide wide bold("while") italic("true"): \
    9 & space wide wide #text[let $c$ be the closest to $italic("qry")$ in $italic("cands")$] \
    10 & space wide wide italic("cands") <- italic("cands") without {c} \
    11 & space wide wide #text[#strong[if] $c$ is further from $italic("qry")$ than the $italic("num")$-th element in $italic("res")$:] \
    12 & space wide wide wide bold("break") \
    13 & space wide wide bold("for") v in c.italic("adjs"): \
    14 & space wide wide wide bold("if") v in.not italic("vis"): \
    15 & space wide wide wide wide italic("vis") <- italic("vis") union {v} \
    16 & space wide wide wide wide italic("cands") <- italic("cands") union {v} \
    17 & space wide wide wide wide italic("tmp_res") <- italic("tmp_res") union {v} \
    18 & space wide #text[#strong[return] the nearest $italic("num")$ elements in $italic("res")$]
  $

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
  #algo(
    title: $italic("searchLayerAnns")$,
    parameters: ($italic("layer")$, $italic("entries")$, $italic("qry")$, $italic("num")$),
    keywords: algo-keywords,
  )[
    $italic("vis") <- italic("entries")$ \
    $italic("cands") <- italic("entries")$ \
    $italic("nns") <- italic("entries")$ \
    while $italic("cands") != emptyset$: #i \
    let $c$ be the closest element #no-emph[to] $italic("qry")$ in $italic("cands")$ \
    let $f$ be the furthest element to $italic("qry")$ in $italic("nns")$ \
    if $delta(italic("qry"), c) > delta(italic("qry"), f)$: #i \
    break #d \
    for $v in c.italic("adjs")$ in $italic("layer")$: #i \
    if $v in italic("vis")$: #i \
    continue #d \
    $italic("vis") <- italic("vis") union {v}$ \
    let $f$ be the furthest element to $italic("qry")$ in $italic("nns")$ \
    if $delta(italic("qry"), v) < delta(italic("qry"), f)$ or $|italic("nns")| < italic("num")$: #i \
    $italic("cands") <- italic("cands") union {v}$ \
    $italic("nns") <- italic("nns") union {v}$ \
    if $|italic("nns")| = italic("num")$: #i \
    $italic("nns") <- italic("nns") without {f}$ #d #d #d #d \
    return $italic("nns")$
  ]
]<algo:hnsw-layer-k_anns>

=== 搜索算法

#algorithm[搜索算法][
  #algo(
    title: $italic("searchAnns")$,
    parameters: ($italic("layers")$, $italic("qry")$, $italic("num")$, $italic("lim")$),
    keywords: algo-keywords,
  )[
    $italic("nns") <- emptyset$ \
    $italic("entries") <- italic("layers")_(|italic("layers")| - 1)$ \
    for $l$ from $|italic("layers")| - 1$ down to $1$: #i \
    $italic("nns") <- italic("searchLayerAnns")(italic("layers")_l, italic("entries"), italic("qry"), 1)$ \
    $italic("entries") <- italic("nns")$ #d \
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
  #algo(
    title: $italic("selectNeighborsNaive")$,
    parameters: ($italic("layer")$, $p_"new"$, $italic("cands")$, $italic("new_edge_num")$),
    keywords: algo-keywords,
  )[
    return the nearest $italic("new_edge_num")$ elements in $italic("cands")$ to $p_"new"$
  ]
]<algo:hnsw-select-neighbors-naive>

===== 启发式算法

额外的参数：
- $italic("extend_cands")$：是否扩展候选集，只适合再数据高度集中时设为真。
- $italic("keep_pruned_edges")$：是否保留被修剪的边。

#algorithm[选择新邻居的启发式算法][
  #algo(
    title: $italic("selectNeighborsHeuristic")$,
    parameters: (
      $italic("layer")$,
      $p_"new"$,
      $italic("cands")$,
      $italic("new_edge_num")$,
      $italic("extend_cands")$,
      $italic("keep_pruned_edges")$,
    ),
    keywords: algo-keywords,
  )[
    $italic("neighbors") <- emptyset$ \
    if $italic("extend_cands")$: #i \
    $italic("extra_cands") <- emptyset$ \
    for $italic("cand") in italic("cands")$: #i \
    for $italic("extra_cand") in italic("cand").italic("adjs")$: #i \
    $italic("extra_cands") <- italic("extra_cands") union {italic("extra_cand")}$ #d #d \
    $italic("cands") <- italic("cands") union italic("extra_cands")$ #d \
    $italic("discarded") <- emptyset$ \
    while $italic("cands") != emptyset$ and $|italic("neighbors")| < italic("new_edge_num")$: #i \
    let $italic("cand")$ be the nearest element to $p_"new"$ in $italic("cands")$ \
    $italic("cands") <- italic("cands") without {italic("cand")}$ \
    let $italic("neighbor")$ be the nearest element to $p_"new"$ in $italic("neighbors")$ \
    if $delta(p_"new", italic("cand")) < delta(p_"new", italic("neighbor"))$: #i \
    $italic("neighbors") <- italic("neighbors") union {italic("cand")}$ #d \
    else: #i \
    $italic("discarded") <- italic("discarded") union {italic("cand")}$ #d #d \
    if $italic("keep_pruned_edges")$: #i \
    while $italic("discarded") != emptyset$ and $|italic("neighbors") < italic("new_edge_num")$: #i \
    let $italic("cand")$ be the nearest element to $p_"new"$ in $italic("discarded")$ \
    $italic("discarded") <- italic("discarded") without {italic("cand")}$ \
    $italic("neighbors") <- italic("neighbors") union {italic("cand")}$ #d #d \
    return $italic("neighbors")$
  ]
]<algo:hnsw-select-neighbors-heuristic>

==== 插入算法

#algorithm[插入算法][
  #algo(
    title: $italic("insert")$,
    parameters: (
      $italic("layers")$,
      $p_"new"$,
      $p_"e"$,
      $italic("new_edge_num")$,
      $italic("deg_lim")$,
      $italic("num")$,
    ),
    keywords: algo-keywords,
  )[
    $italic("nns") <- emptyset$ \
    $italic("entries") <- italic("layers")_(|italic("layers")| - 1)$ \
    $u ~ U(0, 1)$ \
    $l_"m" <- floor((ln u) / (ln p_"e"))$ \
    for $l$ from $|italic("layers")| - 1$ down to $l_"m" + 1$: #i \
    $italic("nns") <- italic("searchLayerAnns")(italic("layers")_l, italic("entries"), p_"new", 1)$ \
    $italic("entries") <- italic("nns")$ #d \
    for $l$ from $min{l_"m", |italic("layers")| - 1}$ down to $0$: #i \
    $italic("nns") <- italic("searchLayerAnns")(italic("layers")_l, italic("entries"), p_"new", italic("num"))$ \
    $italic("neighbors") <- italic("selectNeighbors")(p_"new", italic("nns"), italic("new_edge_num"))$ \
    $V(italic("layers")_l) <- V(italic("layers")_l) union {p_"new"}$ \
    for $italic("neighbor") in italic("neighbors")$: #i \
    $E(italic("layers")_l) <- E(italic("layers")_l) union {(p_"new", italic("neighbor")), (italic("neighbor"), p_"new")}$ \
    if $deg italic("neighbor") > italic("deg_lim")$: #i \
    $italic("neighbor").italic("adjs") <- italic("selectNeighbors")(italic("layers")_l, italic("neighbor"), italic("neighbor").italic("adjs"), italic("deg_lim"))$ #d #d \
    $italic("entries") <- italic("nns")$ #d \
    for $l in NN inter [ |italic("layers")|, l_"m"]$: #i \
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

#pagebreak()

#bibliography(
  "references.bib",
  title: "参考文献",
  full: true,
)
