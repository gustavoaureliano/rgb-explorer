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
  inset: 10pt,
  fill: rgb("#E3F2FD"),
  stroke: (paint: azul, thickness: 1.2pt),
  [
    #align(center)[#image("../imagens/rgb-explorer-logo-light.svg", width: 88%)]
    #v(5pt)
    #align(center)[#text(size: 16pt, weight: "bold", fill: azul)[Manual do Usuario]]
    #align(center)[#text(size: 11pt, style: "italic")[Versao mini-livreto]]
    #v(4pt)
    #align(center)[
      #chip("Leitura rapida", fill: rgb("#BBDEFB")) #h(4pt)
      #chip("Publico final", fill: rgb("#C8E6C9")) #h(4pt)
      #chip("Nao tecnico", fill: rgb("#FFE0B2"))
    ]
  ],
)

#v(8pt)

#secao([Comece em 5 passos], ciano, [
  1. Escolha o modo com o botao *Modo*.
  2. Pressione *Jogar* para iniciar.
  3. Ajuste R, G e B com os botoes + e -.
  4. Pressione *Confirmar* para validar.
  5. Pressione *Jogar* para proxima rodada ou reinicio.
])

#v(7pt)

#secao([Controles e sinais visuais], azul, [
  - *Modo* troca entre 1, 2, 3 e 4.
  - *Jogar* inicia, avanca ou reinicia.
  - *Confirmar* envia sua resposta.
  - LED RGB alvo e LED RGB jogada mostram referencia e tentativa.
  - Display de pontuacao mostra de *0 ate F*.
])

#pagebreak()

// PAGINA 2 - MODOS 1 E 2

= Modos de jogo (parte 1)

#secao([Modo 1 - Exploracao livre], azul, [
  Neste modo voce explora as cores sem pressao.
  Ajuste livremente os canais R, G e B para aprender as combinacoes.

  #v(4pt)
  #chip("Treino ideal", fill: rgb("#E1F5FE")) #h(4pt)
  #chip("Sem alvo obrigatorio", fill: rgb("#B3E5FC"))
])

#v(8pt)

#secao([Modo 2 - Reproduzir cor], verde, [
  O sistema mostra uma cor alvo e voce tenta reproduzir a mesma cor.

  Fluxo rapido:
  - observar o alvo,
  - ajustar a jogada,
  - confirmar e ver o feedback.

  A partida termina quando:
  - a pontuacao chega a 15, ou
  - o fim da partida for indicado pelo sistema.
])

#v(8pt)

#dica([
  Comece pelo Modo 1 para se familiarizar com os controles.
  Depois tente uma rodada no Modo 2 para praticar alvo e confirmacao.
])

#pagebreak()

// PAGINA 3 - MODOS 3 E 4 + PONTUACAO

= Modos de jogo (parte 2)

#secao([Modo 3 - Memoria de cor], laranja, [
  A cor alvo aparece por tempo limitado e depois some.
  Voce precisa reproduzir a cor de memoria.

  A partida tambem encerra em:
  - 15 pontos, ou
  - fechamento do ciclo de niveis.
])

#v(8pt)

#secao([Modo 4 - Desafio rapido], roxo, [
  Reproduza uma sequencia de cores na ordem certa.

  - Se errar forte, a rodada falha.
  - Se acertar, avanca para a proxima rodada.
  - Sequencia maxima: *3 passos*.

  #v(4pt)
  #chip("Dinamicidade", fill: rgb("#E1BEE7")) #h(4pt)
  #chip("Memoria + atencao", fill: rgb("#CE93D8"))
])

#v(8pt)

#secao([Pontuacao simples], ciano, [
  - Erro = 0 -> *+2 pontos*
  - Erro < 3 -> *+1 ponto*
  - Erro >= 3 -> *+0 ponto*

  O placar vai de *0 ate F*.
  Ao chegar em *F (15)*, o valor fica limitado (sem estouro).
])

#pagebreak()

// PAGINA 4 - FAQ + CHECKLIST DE USO

= FAQ e checklist de uso

#secao([FAQ rapido], azul, [
  *"Apertei e nao mudou"*
  -> Pressione firme e solte.

  *"Pontuacao travou em F"*
  -> Comportamento esperado: F e o limite maximo (15).

  *"Nao estou vendo alvo"*
  -> No Modo 3 o alvo some apos o tempo de exibicao.
])

#v(8pt)

#secao([Checklist rapido], verde, [
  1. Escolha o modo com *Modo*.
  2. Inicie com *Jogar*.
  3. Ajuste as cores com os botoes + e -.
  4. Confirme a jogada em *Confirmar*.
  5. Continue ou reinicie com *Jogar*.
])

#v(8pt)

#dica([
  Deixe este livreto junto ao sistema e use a versao pocket para consulta rapida.
])

#v(8pt)

#align(center)[
  #text(size: 8.5pt, fill: rgb("#546E7A"))[
    PCS3635 - RGB Explorer | Material para usuarios finais
  ]
]
