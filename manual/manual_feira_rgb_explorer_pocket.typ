#set page(
  width: 210mm,
  height: 148mm,
  margin: (x: 10mm, y: 9mm),
)

#set text(font: "DejaVu Sans", size: 9.5pt)
#set par(justify: false)

#let azul = rgb("#1976D2")
#let verde = rgb("#2E7D32")
#let roxo = rgb("#6A1B9A")

#let bloco(titulo, fill, body) = rect(
  width: 100%,
  radius: 8pt,
  inset: 7pt,
  fill: fill,
  stroke: none,
  [
    #text(weight: "bold", size: 9.7pt)[#titulo]
    #v(2pt)
    #body
  ],
)

= RGB Explorer - Pocket
#text(size: 10pt, style: "italic")[Guia rapido - 1 pagina]

#v(3pt)

#grid(columns: (1fr, 1.4fr), gutter: 8pt)[
  #align(center + horizon)[#image("../imagens/rgb-explorer-icon.svg", width: 34mm)]
][
  #bloco([Comece em 5 passos], rgb("#E3F2FD"), [
    1. Escolha o modo com *Modo*.
    2. Pressione *Jogar* para iniciar.
    3. Ajuste as cores com +R/-R, +G/-G, +B/-B.
    4. Pressione *Confirmar*.
    5. Use *Jogar* para continuar/reiniciar.
  ])
]

#v(5pt)

#grid(columns: (1fr, 1fr), gutter: 7pt)[
  #bloco([Modo 1], rgb("#E1F5FE"), [Exploracao livre de cores.])
][
  #bloco([Modo 2], rgb("#E8F5E9"), [Reproduzir cor alvo.])
]

#grid(columns: (1fr, 1fr), gutter: 7pt)[
  #bloco([Modo 3], rgb("#FFF3E0"), [Memoria de cor (alvo some).])
][
  #bloco([Modo 4], rgb("#F3E5F5"), [Desafio de sequencia.
  Maximo: *3 passos*.])
]

#v(5pt)

#bloco([Pontuacao], rgb("#ECEFF1"), [
  - Erro = 0 -> *+2*
  - Erro < 3 -> *+1*
  - Erro >= 3 -> *+0*

  Display: *0 ate F* (limite maximo 15).
])

#v(4pt)

#grid(columns: (1fr, 1fr), gutter: 8pt)[
  #bloco([FAQ], rgb("#E3F2FD"), [
    - "Pontuacao em F" -> normal, e o teto.
    - "Nao vejo alvo" -> no Modo 3 ele some.
    - "Nao respondeu" -> pressionar firme e soltar.
  ])
][
  #bloco([Dica rapida], rgb("#E8F5E9"), [
    Comece no Modo 1 para se adaptar aos botoes.
    Em seguida, avance para os modos 2, 3 e 4.
  ])
]

#v(2pt)
#text(size: 8pt, fill: azul)[PCS3635 - RGB Explorer]
