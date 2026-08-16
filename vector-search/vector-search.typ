#import "@preview/ctheorems:1.1.3": *
#show: thmrules
#import "@preview/algo:0.3.6": algo, code, comment, d, i

#let definition = thmbox("definition", "定义")
#let theorem = thmbox("theorem", "定理")
#let lemma = thmbox("lemma", "引理")
#let proof = thmproof("proof", "证明")
#let algorithm = thmbox("algorithm", "算法")

#let powset = math.op(math.scr("P"))
#let chev(..args) = $lr(chevron.l #args.pos().join($,$) chevron.r)$

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


#align(center)[
  #text(font: (en-font, cn-font-heading), size: 2em)[
    向量检索
  ],
]

#outline(indent: auto, title: "目录")

#pagebreak()

= 基于 NSW 图的 ANN 算法 @MALKOV201461

== 度量空间

#definition[度量空间][
  称 $(X, delta)$ 为一个#emph[度量空间（metric space）]，其中：
  - $X$ 是一个集合，其中的元素称为#emph[点]。
  - $delta: X^2 -> RR$ 称为 $X$ 的一个#emph[#underline[度量函数（metric function）/距离函数（distance function）]]。任取 $x,y,z in X$，它必须满足
    - 非负性：$delta(x, y) >= 0$。
    - 唯一性：$delta(x, y) = 0 <=> x = y$。
    - 对称性：$delta(x, y) = d(y, x)$。
    - 三角不等式：$delta(x, z) <= delta(x, y) + delta(y, z)$。
]<metric_space>

任何一个#emph[赋范向量空间（normed vector space）]都是度量空间。

== Voronoi 划分、Veronoi 图、Delaunay 图

#definition[Voronoi 划分][
  考虑度量空间 $(X, delta)$。设空间中有一个#strong[有限的]“生成点”集合（实际问题中的已知数据点）$P subset.eq X$。对于任意 $p in P$，其#emph[Veronoi 区域（Voronoi region）]定义为
  $
    V(p) = {x in X: (forall q in X, space q != p) space (delta(x, p) <= delta(x, q))}.
  $
]<voronoi_tessellation>

#definition[Delaunay 图][
  给定度量空间 $(X, delta)$ 和生成点集合 $P subset.eq X$，设 $V$ 表示 Voronoi 划分。$P$ 上的#emph[Delaunay 图（Delaunay Graph）]定义为无向图 $G = (P, E)$，其中
  $
    E = {{p, q} subset.eq P: p != q and V(p) inter V(q) != emptyset}.
  $
]<delaunay_graph>

Delaunay 图是 Voronoi 图的对偶图。

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
]<greedy_anns>

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
]<greedy_kanns>

== 数据插入算法

目标是建立一个估计的 Delaunay 图（在高维空间上，精确建图被证明是不可能的）。主要的目标是要最小化虚假的全局最小值点的概率，同时限制边数尽量小。一些办法是利用所使用的度量空间的拓扑性质。

作者的办法是对于每个新增元素，利用 @greedy_kanns 在已有的图上查找其 $f$-ANN 并分别与该点连边。这个方法是基于这么一种假设：新增点的精确 Voronoi 邻居和他的 $f$-ANN 的交集应该是比较大的。

建图时，逐个插入元素即可。这种建图办法的好处是，由一维数据上的经验显示，只要加点顺序是随机的，这样建立的图无需额外调整即满足 small world navigation 性质。

=== 参数选择

查询阶段的召回率超过 $0.99$ 后，继续增大召回率对搜索质量没有显著影响。推荐的是将其保持在 $0.95 ~ 0.99$。召回率的变化相对于数据集大小的增长是缓慢的（对数级）。

对于 $d in NN inter [1. 20]$ 维欧氏空间，最优的 $f approx 3 d$。

= 基于 HNSW 图的 ANN 算法

#bibliography(
  "references.bib",
  title: "参考文献",
  full: true,
)
