#set page(
  width: 20in,
  height: 11.25in,
  margin: (x: 0.78in, y: 0.58in),
  fill: rgb("#F4F8FC"),
)

#set text(font: "DejaVu Sans", fill: rgb("#17324A"))
#set par(justify: false)

#let azul = rgb("#1E88E5")
#let azul-claro = rgb("#E8F3FE")
#let verde = rgb("#2E7D32")
#let verde-claro = rgb("#EAF6EA")
#let laranja = rgb("#EF6C00")
#let laranja-claro = rgb("#FFF1E2")
#let roxo = rgb("#6A1B9A")
#let roxo-claro = rgb("#F4E8FB")
#let preto = rgb("#17324A")
#let cinza = rgb("#5A7487")

#let slide_header(title, subtitle: none, accent: azul, show-brand: false) = [
  #align(left)[
    #image("../imagens/rgb-explorer-logo-light.svg", width: 1.1in)
  ]
  #v(6pt)
  #if show-brand [
    #text(size: 12pt, weight: "bold", fill: accent)[PCS3635 | Projeto extensionista]
    #v(2pt)
    #text(size: 24pt, weight: "bold", fill: preto)[RGB Explorer]
    #v(4pt)
  ]
  #text(size: 24pt, weight: "bold", fill: preto)[#title]
  #if subtitle != none [
    #v(3pt)
    #text(size: 13pt, fill: cinza)[#subtitle]
  ]
  #v(12pt)
]

#let card(title, color, fill, body) = rect(
  width: 8.75in,
  radius: 16pt,
  inset: 10pt,
  fill: fill,
  stroke: (paint: color, thickness: 1.4pt),
  [
    #text(size: 17pt, weight: "bold", fill: color)[#title]
    #v(4pt)
    #text(size: 13.5pt, fill: preto)[#body]
  ],
)

#let flow_card(body) = rect(
  width: 18.0in,
  radius: 18pt,
  inset: 14pt,
  fill: white,
  stroke: (paint: rgb("#CFE0EC"), thickness: 1.5pt),
  align(center)[
    #text(size: 17pt, weight: "bold", fill: rgb("#355264"))[#body]
  ],
)

#let row_cards(left, right) = align(center)[
  #left
  #h(0.5in)
  #right
]

// Slide 1
#slide_header(
  [Tecnologia interativa para aprendizagem visual e apoio a pessoas com TEA],
  subtitle: [Uma experiência acessível, previsível e baseada em cores RGB.],
  show-brand: true,
)

#row_cards(
  card([Problema], azul, azul-claro, [
    Há poucas ferramentas acessíveis para atividades estruturadas
    de estimulação visual e cognitiva.
  ]),
  card([Contexto TEA], verde, verde-claro, [
    Pessoas com TEA frequentemente se beneficiam de regras claras,
    previsibilidade e estímulos visuais controlados.
  ]),
)

#v(12pt)

#align(center)[
  #block(width: 18in)[
    #card([Proposta], roxo, roxo-claro, [
      O RGB Explorer transforma a exploração e a reprodução de cores em uma atividade
      lúdica, estruturada e complementar para contextos educacionais, terapêuticos e domésticos.
    ])
  ]
]

// Slide 2
#pagebreak()
#slide_header(
  [Quem pode se beneficiar?],
  subtitle: [Público-alvo definido a partir de faixa etária, mediação e nível de suporte.],
  accent: verde,
)

#row_cards(
  card([Usuários diretos], azul, azul-claro, [
    Pessoas com Transtorno do Espectro Autista (TEA).
  ]),
  card([Usuários de apoio], verde, verde-claro, [
    Familiares, educadores e terapeutas que podem mediar a atividade.
  ]),
)

#v(10pt)

#row_cards(
  card([Faixa etária], laranja, laranja-claro, [
    Público principal entre 7 e 14 anos.
    Uso simplificado possível a partir de 5 anos com mediação.
  ]),
  card([Níveis de suporte], roxo, roxo-claro, [
    Foco principal em usuários com TEA nível 1 e 2.
    Para nível 3, o uso é mais adequado em contexto mediado e exploratório.
  ]),
)

// Slide 3
#pagebreak()
#slide_header(
  [Como o sistema funciona],
  subtitle: [Interação física simples com feedback visual imediato.],
  accent: laranja,
)

#align(center)[
  #block(width: 18in)[
    #flow_card([
      Cor-alvo em LED RGB -> Ajuste de R, G e B -> Confirmar -> Receber feedback
    ])
  ]
]

#v(12pt)

#row_cards(
  card([Interação], azul, azul-claro, [
    O usuário ajusta os canais vermelho, verde e azul por botões físicos
    para tentar reproduzir a cor mostrada pelo sistema.
  ]),
  card([Resposta], verde, verde-claro, [
    Após a confirmação, o sistema compara a cor gerada com a cor-alvo
    e fornece feedback visual imediato.
  ]),
)

#v(10pt)

#row_cards(
  card([Modos], laranja, laranja-claro, [
    Exploração livre, reproduzir a cor, memória de cor e desafio rápido.
  ]),
  card([Progressão], roxo, roxo-claro, [
    Os modos organizam níveis de exploração, memória visual
    e aumento gradual de dificuldade.
  ]),
)

// Slide 4
#pagebreak()
#slide_header(
  [O que o projeto estimula],
  subtitle: [Uma ferramenta complementar que une acessibilidade, hardware e aprendizagem visual.],
  accent: roxo,
)

#row_cards(
  card([Habilidades], azul, azul-claro, [
    Percepção e discriminação de cores, atenção, memória visual,
    coordenação motora simples e compreensão de causa e efeito.
  ]),
  card([Experiência de uso], verde, verde-claro, [
    Interface simples, visualmente clara e previsível,
    pensada para reduzir sobrecarga e favorecer engajamento.
  ]),
)

#v(10pt)

#row_cards(
  card([Diferencial técnico], laranja, laranja-claro, [
    Implementação em FPGA com múltiplos modos de uso,
    feedback visual imediato e proposta acessível.
  ]),
  card([Síntese], roxo, roxo-claro, [
    O RGB Explorer une eletrônica digital, acessibilidade e interação estruturada
    em uma ferramenta complementar de apoio ao desenvolvimento cognitivo e sensorial.
  ]),
)
