# RGB Explorer

## Visão Geral

O RGB Explorer é um sistema digital implementado em FPGA para exploração, reprodução e comparação de cores no modelo RGB. O projeto utiliza botões físicos, LEDs RGB, displays de 7 segmentos e indicadores auxiliares para oferecer quatro modos de operação com feedback visual imediato.

Ao longo do desenvolvimento, o sistema evoluiu de um modo de exploração livre para modos com reprodução de cor, memória visual, progressão de dificuldade e desafio em sequência.

## Contexto

Este repositório reúne os arquivos do projeto desenvolvido na disciplina **PCS3635 - Laboratório de Projeto de Sistemas Digitais I**. A proposta combina eletrônica digital e interação estruturada em uma atividade voltada à percepção visual e à experimentação com cores, com foco extensionista em contextos educacionais e exploratórios.

O projeto foi concebido como uma ferramenta complementar, e não como substituto de práticas pedagógicas ou terapêuticas especializadas.

## Plataforma Utilizada

O sistema foi implementado para a FPGA:

- **Cyclone V 5CEBA4F23C7**

Os arquivos principais do projeto Quartus são:

- `rgb_explorer.qpf`
- `rgb_explorer.qsf`

## Organização do Repositório

A estrutura do repositório está organizada da seguinte forma:

- arquivos RTL e de simulação na raiz do projeto
- `manual/`: materiais finais em Typst e PDF, incluindo manuais e pitch
- `imagens/`: logos, diagramas, pinout e imagens auxiliares
- `PCS3635-T6BA1-Documento-Final.md`: relatório final do projeto

## Arquivos Principais

Os arquivos mais importantes do projeto são:

- `rgb_explorer.v`: módulo de topo do sistema
- `unidade_controle.v`: máquina de estados principal
- `fluxo_dados.v`: datapath do sistema
- `mode4_seq_engine.v`: lógica da sequência do Modo 4
- `level_system.v`: lógica de progressão de níveis
- `score_calc.v`: cálculo de pontuação
- `rgb_level_counter.v`, `rgb_level_limit.v`, `rgb_level_scale.v`: lógica de níveis e escalonamento
- `rgb_intensity_bar.v`: controle das barras de intensidade
- `timeout_counter.v`: temporização de estados e modos
- `manual/README.md`: instruções para gerar os PDFs finais
- `imagens/gen_pinout_fpga_sistema.py`: script gerador do pinout final do sistema

## Como Utilizar o Projeto

### Compilação e Programação da FPGA

O projeto pode ser aberto e compilado diretamente pela interface gráfica do Quartus, utilizando os arquivos:

- `rgb_explorer.qpf`
- `rgb_explorer.qsf`

A programação da FPGA também pode ser realizada pela própria interface do Quartus, a partir do arquivo gerado após a compilação.

### Simulações

Os arquivos de testbench do projeto estão disponíveis na raiz do repositório, incluindo testes para modos específicos e para módulos auxiliares. Entre os principais arquivos de simulação estão:

- `rgb_explorer_tb.v`
- `rgb_explorer_tb_modo2.v`
- `rgb_explorer_tb_modo3.v`
- `rgb_explorer_tb_modo4.v`
- `rgb_explorer_tb_level.v`
- `tb_debounce.v`

Também estão disponíveis arquivos `.do` de apoio para inspeção de formas de onda no ModelSim/Questa:

- `wave.do`
- `wave-modo2.do`
- `wave-modo3.do`
- `wave-modo4.do`

## Materiais Finais

Os principais materiais finais do projeto estão em:

- `manual/manual_feira_rgb_explorer.pdf`
- `manual/manual_feira_rgb_explorer_livreto.pdf`
- `manual/feira_pitch_3min.pdf`
- `imagens/pinout_fpga_sistema.png`
- `PCS3635-T6BA1-Documento-Final.md`

As instruções para gerar os PDFs finais estão em:

- `manual/README.md`

## Pinagem e Materiais Visuais

A documentação visual final da pinagem do sistema está em:

- `imagens/pinout_fpga_sistema.svg`
- `imagens/pinout_fpga_sistema.png`

O arquivo foi gerado a partir de:

- `imagens/gen_pinout_fpga_sistema.py`

Esse material foi produzido para facilitar a montagem final do sistema, reunindo em uma única referência os sinais conectados aos headers utilizados na placa FPGA.

## Observações

- Os botões externos do sistema são **ativos em nível baixo**.
- Em várias simulações, especialmente dos modos com temporização, é utilizado o perfil `SIM_FAST`.
- O arquivo `full_counter_tb.v` é antigo e não reflete a versão atual do módulo `full_counter`.
