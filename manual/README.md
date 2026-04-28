# Manual de usuário

Este diretório contém materiais em **Typst** para gerar os PDFs finais do projeto:

- `manual_feira_rgb_explorer.typ` -> versão principal do manual (A5 horizontal, frente/verso)
- `manual_feira_rgb_explorer_livreto.typ` -> mini-livreto colorido (A5 vertical, 4 páginas)
- `feira_pitch_3min.typ` -> pitch da feira em slides

## Requisitos (Arch Linux)

```bash
sudo pacman -S --needed typst
```

## Gerar todos os PDFs

No diretório raiz do projeto (`rgb-explorer`):

```bash
typst compile --root . manual/manual_feira_rgb_explorer.typ manual/manual_feira_rgb_explorer.pdf
typst compile --root . manual/manual_feira_rgb_explorer_livreto.typ manual/manual_feira_rgb_explorer_livreto.pdf
typst compile --root . manual/feira_pitch_3min.typ manual/feira_pitch_3min.pdf
```

## Dicas de impressão

- `manual_feira_rgb_explorer.pdf`: tamanho de página **A5 horizontal**; usar frente/verso.
- `manual_feira_rgb_explorer_livreto.pdf`: tamanho de página **A5 vertical**.
- Papel recomendado: 120 g/m2 a 180 g/m2.
- Se quiser acabamento tipo folheto, dobrar no meio e grampear.

Para o mini-livreto (`manual_feira_rgb_explorer_livreto.pdf`):

- Opção 1: imprimir A5 frente/verso e grampear.
- Opção 2: imprimir em A4 com modo booklet (2 páginas por folha), dobrar e grampear.
