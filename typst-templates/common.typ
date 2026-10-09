#import "@preview/ctheorems:1.1.3": *
#import "@preview/algo:0.3.6" as algo

#let thmbox = thmbox.with(breakable: true)

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
#let indent = 2em

#let ext_link(dest, ..args) = {
  let pos-args = args.pos()
  let content = if pos-args.len() > 0 { pos-args.at(0) } else { dest }
  link(dest, text(fill: rgb("#1a73e8"), content))
}

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

#let common-template(body) = {
  show: thmrules
  set page(margin: 2cm, numbering: "1")
  set par(first-line-indent: (amount: indent, all: true))
  set heading(numbering: "1.")
  set underline(offset: 2pt)
  show link: underline
  set math.mat(delim: "[")
  body
}
