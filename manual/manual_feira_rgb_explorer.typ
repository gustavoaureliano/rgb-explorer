#set page(
  width: 210mm,
  height: 148mm,
  margin: (x: 10mm, y: 8mm),
)

#set text(font: "DejaVu Sans", size: 9.5pt)
#set par(justify: false, leading: 1.08em)

#let azul = rgb("#1E88E5")
#let verde = rgb("#2E7D32")
#let laranja = rgb("#EF6C00")
#let roxo = rgb("#6A1B9A")
#let cinza = rgb("#ECEFF1")
#let preto = rgb("#263238")

#let tag(txt, fill: cinza) = box(
  inset: (x: 6pt, y: 3pt),
  radius: 6pt,
  fill: fill,
  stroke: none,
  text(size: 8pt, weight: "bold", txt),
)

#let card(title, color, body) = rect(
  width: 100%,
  radius: 8pt,
  inset: 8pt,
  fill: white,
  stroke: (paint: color, thickness: 1.2pt),
  [
    #text(size: 10pt, weight: "bold", fill: color)[#title]
    #v(4pt)
    #body
  ],
)

#let dica(txt) = rect(
  width: 100%,
  radius: 8pt,
  inset: 7pt,
  fill: rgb("#FFF8E1"),
  stroke: (paint: rgb("#FFB300"), thickness: 0.8pt),
  [
    #text(size: 8.8pt, weight: "bold", fill: rgb("#E65100"))[Dica]
    #v(2pt)
    #text(size: 8.8pt)[#txt]
  ],
)

= RGB Explorer
#text(size: 11pt, style: "italic", fill: preto)[Manual do usuário]

#v(4pt)

#grid(
  columns: (1fr, 1.7fr),
  gutter: 10pt,
)[
  #align(center + horizon)[
    #image("../imagens/rgb-explorer-logo-light.svg", width: 98%)
  ]
][
  #rect(
    width: 100%,
    radius: 10pt,
    inset: 10pt,
    fill: rgb("#E3F2FD"),
    stroke: (paint: azul, thickness: 1pt),
    [
      #text(size: 10pt, weight: "bold", fill: azul)[Bem-vindo!]
      #v(3pt)
      O _RGB Explorer_ é um jogo interativo para aprender cores, testar memória visual
      e se divertir. Este guia foi feito para leitura rápida e uso no dia a dia.

      #v(6pt)
      #tag("Público: usuários finais", fill: rgb("#BBDEFB")) #h(4pt)
      #tag("Não técnico", fill: rgb("#C8E6C9")) #h(4pt)
      #tag("Leitura: 2 min", fill: rgb("#FFE0B2"))
    ],
  )
]

#v(6pt)

#grid(columns: (1fr, 1fr), gutter: 8pt)[
  #card([1) Controles], azul, [
    - *Modo:* troca entre os modos 1 a 4.
    - *Jogar:* inicia, avança rodada ou reinicia.
    - *Confirmar:* valida sua tentativa.
    - *+R/-R, +G/-G, +B/-B:* ajustam a cor da jogada.
    - *Reset:* reinício geral do sistema.
  ])
][
  #card([2) O que você vê], verde, [
    - LED RGB alvo (quando o modo usa referência).
    - LED RGB jogada (sua cor atual).
    - Display de modo (1, 2, 3 ou 4).
    - Display de pontuação (0 até F).
    - LEDs de erro e LEDs de nível.
    - Barras de intensidade R/G/B.
  ])
]

#v(6pt)
#dica([Comece no Modo 1 para se acostumar com os botões. Depois vá para os modos 2, 3 e 4.])

#pagebreak()

= Como jogar

#grid(columns: (1fr, 1fr), gutter: 8pt)[
  #card([Modo 1 - Exploração livre], azul, [
    Ajuste as cores livremente.
    Não há alvo obrigatório nem objetivo de acerto.

    #v(4pt)
    #tag("Treino rápido", fill: rgb("#E1F5FE"))
  ])
][
  #card([Modo 2 - Reproduzir cor], verde, [
    O sistema mostra uma cor alvo.
    Você monta sua cor e confirma.

    Encerramento da partida:
    - ao atingir 15 pontos, ou
    - ao fim da partida mostrado pelo sistema.
  ])
]

#v(6pt)

#grid(columns: (1fr, 1fr), gutter: 8pt)[
  #card([Modo 3 - Memória de cor], laranja, [
    A cor alvo aparece por tempo limitado e some.
    Você reproduz de memória e confirma.

    Encerramento igual ao Modo 2.
  ])
][
  #card([Modo 4 - Desafio rápido], roxo, [
    Reproduza a sequência de cores na ordem correta.
    Se errar forte, a rodada falha.
    Se acertar, a sequência cresce.

    Sequência máxima: *3 passos*.
  ])
]

#v(7pt)

#rect(
  width: 100%,
  radius: 8pt,
  inset: 8pt,
  fill: rgb("#F3E5F5"),
  stroke: (paint: roxo, thickness: 0.9pt),
  [
    #text(weight: "bold", fill: roxo)[Pontuação (simples)]
    #v(3pt)
    #grid(columns: (1.2fr, 1fr, 1.2fr), gutter: 6pt)[
      #tag("Erro = 0", fill: rgb("#E8F5E9"))
    ][
      #align(center)[#text(weight: "bold")[+2 pontos]]
    ][
      Acerto exato
    ]
    #grid(columns: (1.2fr, 1fr, 1.2fr), gutter: 6pt)[
      #tag("Erro < 3", fill: rgb("#FFFDE7"))
    ][
      #align(center)[#text(weight: "bold")[+1 ponto]]
    ][
      Acerto próximo
    ]
    #grid(columns: (1.2fr, 1fr, 1.2fr), gutter: 6pt)[
      #tag("Erro >= 3", fill: rgb("#FFEBEE"))
    ][
      #align(center)[#text(weight: "bold")[+0 ponto]]
    ][
      Acerto distante
    ]

    #v(4pt)
    Display de pontuação: *0 até F*.
    O sistema limita em *15 (F)* para não estourar.
  ],
)

#v(6pt)

#grid(columns: (1fr, 1fr), gutter: 8pt)[
  #card([FAQ rápido], azul, [
    - *"Apertei e não mudou"* -> pressione firme e solte.
    - *"A pontuação travou em F"* -> comportamento esperado (máximo 15).
    - *"Não vejo o alvo"* -> no Modo 3 ele some após o tempo de exibição.
  ])
][
  #card([Cola final], verde, [
    1. Escolha modo com *Modo*.
    2. Inicie com *Jogar*.
    3. Ajuste RGB com + e -.
    4. Valide com *Confirmar*.
    5. Use *Jogar* para próxima rodada/reinício.
  ])
]

#v(4pt)
#text(size: 8pt, fill: rgb("#546E7A"))[RGB Explorer]
