#set page(
  width: 148mm,
  height: 210mm,
  margin: (x: 12mm, y: 12mm),
)

#set text(font: "DejaVu Sans", size: 10pt)
#set par(justify: false, leading: 1.1em)

#let azul = rgb("#1E88E5")
#let verde = rgb("#2E7D32")
#let laranja = rgb("#EF6C00")
#let roxo = rgb("#6A1B9A")
#let ciano = rgb("#00ACC1")
#let cinza = rgb("#ECEFF1")

#let chip(txt, fill: cinza) = box(
  inset: (x: 6pt, y: 3pt),
  radius: 6pt,
  fill: fill,
  stroke: none,
  text(size: 8.3pt, weight: "bold", txt),
)

#let secao(titulo, cor, body) = rect(
  width: 100%,
  radius: 9pt,
  inset: 9pt,
  fill: white,
  stroke: (paint: cor, thickness: 1.2pt),
  [
    #text(size: 11pt, weight: "bold", fill: cor)[#titulo]
    #v(4pt)
    #body
  ],
)

#let dica(txt) = rect(
  width: 100%,
  radius: 8pt,
  inset: 8pt,
  fill: rgb("#FFF8E1"),
  stroke: (paint: rgb("#FFB300"), thickness: 0.9pt),
  [
    #text(weight: "bold", fill: rgb("#E65100"))[Dica]
    #v(2pt)
    #txt
  ],
)

// PAGINA 1 - CAPA + INICIO RAPIDO

#rect(
  width: 100%,
  radius: 10pt,
  inset: 8pt,
  fill: rgb("#E3F2FD"),
  stroke: (paint: azul, thickness: 1.2pt),
  [
    #align(center)[#image("../imagens/rgb-explorer-logo-light.svg", height: 38mm)]
    #v(2pt)
    #align(center)[#text(size: 16pt, weight: "bold", fill: azul)[Manual do Usuário]]
    #align(center)[#text(size: 11pt, style: "italic")[Versão mini-livreto]]
    #v(2pt)
    #align(center)[
      #chip("Leitura rápida", fill: rgb("#BBDEFB")) #h(4pt)
      #chip("Público final", fill: rgb("#C8E6C9")) #h(4pt)
      #chip("Não técnico", fill: rgb("#FFE0B2"))
    ]
  ],
)

#v(5pt)

#secao([Comece em 5 passos], ciano, [
  1. Escolha o modo com o botão *Modo*.
  2. Pressione *Jogar* para iniciar.
  3. Ajuste R, G e B com os botões + e -.
  4. Pressione *Confirmar* para validar.
  5. Pressione *Jogar* para próxima rodada ou reinício.
])

#v(5pt)

#secao([Controles e sinais visuais], azul, [
  - *Modo* troca entre 1, 2, 3 e 4.
  - *Jogar* inicia, avança ou reinicia.
  - *Confirmar* envia sua resposta.
  - LED RGB alvo e LED RGB jogada mostram referência e tentativa.
  - Display de pontuação mostra de *0 até F*.
])

#pagebreak()

// PAGINA 2 - MODOS 1 E 2

= Modos de jogo (parte 1)

#secao([Modo 1 - Exploração livre], azul, [
  Neste modo você explora as cores sem pressão.
  Ajuste livremente os canais R, G e B para aprender as combinações.

  #v(4pt)
  #chip("Treino ideal", fill: rgb("#E1F5FE")) #h(4pt)
  #chip("Sem alvo obrigatório", fill: rgb("#B3E5FC"))
])

#v(8pt)

#secao([Modo 2 - Reproduzir cor], verde, [
  O sistema mostra uma cor alvo e você tenta reproduzir a mesma cor.

  Fluxo rápido:
  - observar o alvo,
  - ajustar a jogada,
  - confirmar e ver o feedback.

  A partida termina quando:
  - a pontuação chega a 15, ou
  - o fim da partida for indicado pelo sistema.
])

#v(8pt)

#dica([
  Comece pelo Modo 1 para se familiarizar com os controles.
  Depois tente uma rodada no Modo 2 para praticar alvo e confirmação.
])

#pagebreak()

// PAGINA 3 - MODOS 3 E 4 + PONTUACAO

= Modos de jogo (parte 2)

#secao([Modo 3 - Memória de cor], laranja, [
  A cor alvo aparece por tempo limitado e depois some.
  Você precisa reproduzir a cor de memória.

  A partida também encerra em:
  - 15 pontos, ou
  - fechamento do ciclo de níveis.
])

#v(8pt)

#secao([Modo 4 - Desafio rápido], roxo, [
  Reproduza uma sequência de cores na ordem certa.

  - Se errar forte, a rodada falha.
  - Se acertar, avança para a próxima rodada.
  - Sequência máxima: *3 passos*.

  #v(4pt)
  #chip("Dinamicidade", fill: rgb("#E1BEE7")) #h(4pt)
  #chip("Memória + atenção", fill: rgb("#CE93D8"))
])

#v(8pt)

#secao([Pontuação simples], ciano, [
  - Erro = 0 -> *+2 pontos*
  - Erro < 3 -> *+1 ponto*
  - Erro >= 3 -> *+0 ponto*

  O placar vai de *0 até F*.
  Ao chegar em *F (15)*, o valor fica limitado (sem estouro).
])

#pagebreak()

// PAGINA 4 - FAQ + CHECKLIST DE USO

= FAQ e checklist de uso

#secao([FAQ rápido], azul, [
  *"Apertei e não mudou"*
  -> Pressione firme e solte.

  *"Pontuação travou em F"*
  -> Comportamento esperado: F é o limite máximo (15).

  *"Não estou vendo alvo"*
  -> No Modo 3 o alvo some após o tempo de exibição.
])

#v(8pt)

#secao([Checklist rápido], verde, [
  1. Escolha o modo com *Modo*.
  2. Inicie com *Jogar*.
  3. Ajuste as cores com os botões + e -.
  4. Confirme a jogada em *Confirmar*.
  5. Continue ou reinicie com *Jogar*.
])

#v(8pt)

#align(center)[
  #text(size: 8.5pt, fill: rgb("#546E7A"))[
    PCS3635 - RGB Explorer | Material para usuários finais
  ]
]
