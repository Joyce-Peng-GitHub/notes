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
#let sch = $op("sch")$
#let powset = $scr(P)$
#let chev(..args) = $lr(chevron.l #args.pos().join($,$) chevron.r)$
#let prob = $PP$
#let expect = $EE$

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
    Text-to-SQL
  ]
]

#outline(indent: auto, title: "目录")

#pagebreak()

= 基本概念

== 关系代数

#definition[关系代数][
  + 值、属性与域：

    设
    - $cal(A)$ 是所有属性名的集合。
    - $cal(V)$ 是所有可能的值的集合。
    - 对每个属性 $A in cal(A)$，给定其#emph[值域] $italic("Dom")(A) subset.eq cal(V)$。

  + 关系模式：

    $(R, U)$ 称为一个#emph[关系模式]，其中 $U subset.eq cal(A)$ 是一个有限的属性集，#emph[模式名] $R$ 是为了允许不同的关系模式使用相同的属性集而为关系模式赋予的唯一的名字。

  + 元组：

    称一个函数 $t: U -> cal(V)$ 是一个 #emph[$U$-元组]，如果他满足
    $
      (forall A in U) space (t(A) in italic("Dom")(A)).
    $

    记所有合法的 $U$-元组构成的集合为
    $
      italic("Tuple")(U) = {t in cal(V)^U: (forall A in U) space (t(A) in italic("Dom")(A))}.
    $
  
  + 关系实例：

    关系模式 $(R, U)$ 上的一个有限集合 $r subset.eq italic("Tuple")(U)$ 称为关系模式 $R$ 的一个#emph[关系实例]，其模式记为 $sch(r) = U$。
  
  + 数据库模式与实例：

    设 $cal(R)$ 为有限个关系名的集合。称一个 $cal(S): cal(R) -> powset_"fin" (cal(A)))$ 是一个#emph[数据库模式]，其中 $powset_"fin": S |-> {P subset.eq powset(S): |P| in NN}$，于是 $cal(S)(R) space (R in cal(R))$ 就表示 $R$ 的属性集。为了表达完整性约束，可以定义为 $bold(S) = (cal(S), Gamma)$，其中 $Gamma$ 是一组约束。数据库模式 $bold(S) = (cal(S), Gamma)$ 上的#emph[数据库实例]的集合定义为
    $
      italic("Inst")(bold(S)) = {I: (I: R |-> italic("Tuple")(cal(S)(R)) space (R in cal(R))) and I tack.rr Gamma}.
    $
  
  + 基本算子：

    设 $(R, U)$ 是一个关系模式。
    
    设谓词 $phi$ 的自由属性包含于 $U$，定义#emph[投影]算子
    $
      sigma_phi: r |-> {t in r: t tack.rr phi} space (r subset.eq italic("Tuple")(U)).
    $

    设 $V subset.eq U$，定义#emph[投影]算子
    $
      pi_V: r |-> {t harpoon.tr V: t in r} space (r subset.eq italic("Tuple")(U)).
    $

    取新的有限属性集 $V subset.eq cal(A)$，设 $rho.alt: U -> V$ 是保持值域的双射（即 $(forall A in U) space (italic("Dom")(A) = italic("Dom")(rho.alt(A)))$)，定义#emph[重命名]算子
    $
      rho_rho.alt: r |-> {t compose rho.alt^(-1): t in r} space (r subset.eq italic("Tuple")(U)).
    $

    设关系模式 $(S, V)$ 满足 $U inter V = nothing$。定义#emph[笛卡尔积]算子
    $
      times: (r, s) |-> {t in italic("Tuple")(U union V): t harpoon.tr U in r and t harpoon.tr V in s} space (r in italic("Tuple")(U) and s in italic("Tuple")(V)).
    $
]<def:relational-algebra>

= OmniTQA @shahbazi2026textualcolumnsqueryplans

#pagebreak()

#bibliography(
  "references.bib",
  title: "参考文献",
  full: true,
)
