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
  ]
]

#outline(indent: auto, title: "目录")

#pagebreak()

= 基本概念

= OmniTQA @shahbazi2026textualcolumnsqueryplans

#pagebreak()

#bibliography(
  "references.bib",
  title: "参考文献",
  full: true,
)
