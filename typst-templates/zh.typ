#import "common.typ": *

#let definition = thmbox("definition", "定义")
#let theorem = thmbox("theorem", "定理")
#let lemma = thmbox("lemma", "引理")
#let proof = thmproof("proof", "证明")
#let algorithm = thmbox("algorithm", "算法")

#let cn-font-body = "Noto Serif SC"
#let cn-font-emph = "KaiTi"
#let cn-font-title = "Noto Sans SC"

#let template(body) = {
  show: common-template
  set outline(title: "目录")
  set text(font: (en-font, cn-font-body))
  show emph: set text(font: (en-font, cn-font-emph), style: "normal")
  show figure.where(kind: image): set figure(supplement: "图")
  show figure.where(kind: table): set figure(supplement: "表")
  set bibliography(title: "参考文献")  
  body
}
