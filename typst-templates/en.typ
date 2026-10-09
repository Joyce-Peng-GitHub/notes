#import "common.typ": *

#let definition = thmbox("definition", "Definition")
#let theorem = thmbox("theorem", "Theorem")
#let lemma = thmbox("lemma", "Lemma")
#let proof = thmproof("proof", "Proof")
#let algorithm = thmbox("algorithm", "Algorithm")

#let template(body) = {
  show: common-template
  set text(font: en-font, lang: "en")
  show figure.where(kind: image): set figure(supplement: "Figure")
  show figure.where(kind: table): set figure(supplement: "Table")
  body
}
