onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_rgb_explorer/dut/clock
add wave -noupdate -divider Entradas
add wave -noupdate -color Magenta /tb_rgb_explorer/dut/btn_confirma
add wave -noupdate -color Magenta /tb_rgb_explorer/dut/btn_jogar
add wave -noupdate -color Magenta /tb_rgb_explorer/dut/btn_modo
add wave -noupdate -color Magenta /tb_rgb_explorer/dut/btn_reset
add wave -noupdate -color Orange /tb_rgb_explorer/dut/btns_plus_rgb
add wave -noupdate -color Orange /tb_rgb_explorer/dut/btns_minus_rgb
add wave -noupdate -divider UC
add wave -noupdate -color Thistle /tb_rgb_explorer/dut/conta_modo
add wave -noupdate -color Thistle /tb_rgb_explorer/dut/jogada_feita
add wave -noupdate -color Thistle /tb_rgb_explorer/dut/mudar_rgb
add wave -noupdate -color Thistle /tb_rgb_explorer/dut/pulso_modo
add wave -noupdate -color Thistle /tb_rgb_explorer/dut/registra_jogada
add wave -noupdate -color Thistle /tb_rgb_explorer/dut/zera_modo
add wave -noupdate -color Thistle /tb_rgb_explorer/dut/zera_nivel
add wave -noupdate -color Thistle /tb_rgb_explorer/dut/zera_pontuacao
add wave -noupdate -color Thistle /tb_rgb_explorer/dut/zera_rgb_alvo
add wave -noupdate -color Thistle /tb_rgb_explorer/dut/zera_rgb_jogada
add wave -noupdate -divider FD
add wave -noupdate -color Yellow -radix hexadecimal -childformat {{{/tb_rgb_explorer/dut/s_estado[7]} -radix hexadecimal} {{/tb_rgb_explorer/dut/s_estado[6]} -radix hexadecimal} {{/tb_rgb_explorer/dut/s_estado[5]} -radix hexadecimal} {{/tb_rgb_explorer/dut/s_estado[4]} -radix hexadecimal} {{/tb_rgb_explorer/dut/s_estado[3]} -radix hexadecimal} {{/tb_rgb_explorer/dut/s_estado[2]} -radix hexadecimal} {{/tb_rgb_explorer/dut/s_estado[1]} -radix hexadecimal} {{/tb_rgb_explorer/dut/s_estado[0]} -radix hexadecimal}} -subitemconfig {{/tb_rgb_explorer/dut/s_estado[7]} {-color Yellow -height 16 -radix hexadecimal} {/tb_rgb_explorer/dut/s_estado[6]} {-color Yellow -height 16 -radix hexadecimal} {/tb_rgb_explorer/dut/s_estado[5]} {-color Yellow -height 16 -radix hexadecimal} {/tb_rgb_explorer/dut/s_estado[4]} {-color Yellow -height 16 -radix hexadecimal} {/tb_rgb_explorer/dut/s_estado[3]} {-color Yellow -height 16 -radix hexadecimal} {/tb_rgb_explorer/dut/s_estado[2]} {-color Yellow -height 16 -radix hexadecimal} {/tb_rgb_explorer/dut/s_estado[1]} {-color Yellow -height 16 -radix hexadecimal} {/tb_rgb_explorer/dut/s_estado[0]} {-color Yellow -height 16 -radix hexadecimal}} /tb_rgb_explorer/dut/s_estado
add wave -noupdate -color Cyan -radix hexadecimal /tb_rgb_explorer/dut/s_modo
add wave -noupdate -color Orange /tb_rgb_explorer/dut/s_rgb_jogada
add wave -noupdate -color Orange /tb_rgb_explorer/dut/s_rgb_alvo
add wave -noupdate -divider Saidas
add wave -noupdate -color Orange /tb_rgb_explorer/dut/rgb_jogada
add wave -noupdate -color Orange /tb_rgb_explorer/dut/rgb_alvo
add wave -noupdate /tb_rgb_explorer/dut/hex7seg_modo
add wave -noupdate -divider Depuracao
add wave -noupdate -color {Light Steel Blue} /tb_rgb_explorer/dut/db_jogada_r
add wave -noupdate -color {Light Steel Blue} /tb_rgb_explorer/dut/db_jogada_g
add wave -noupdate -color {Light Steel Blue} /tb_rgb_explorer/dut/db_jogada_b
add wave -noupdate -color {Light Steel Blue} /tb_rgb_explorer/dut/db_estado_msb
add wave -noupdate -color {Light Steel Blue} /tb_rgb_explorer/dut/db_estado_lsb
add wave -noupdate -color {Light Steel Blue} /tb_rgb_explorer/dut/db_clock
add wave -noupdate -color {Light Steel Blue} /tb_rgb_explorer/dut/db_btns_plus_rgb
add wave -noupdate -color {Light Steel Blue} /tb_rgb_explorer/dut/db_btns_minus_rgb
add wave -noupdate -color {Light Steel Blue} /tb_rgb_explorer/dut/db_btn_modo
add wave -noupdate -divider Codificador
add wave -noupdate /tb_rgb_explorer/dut/cod_rgb_jogada/clk
add wave -noupdate /tb_rgb_explorer/dut/cod_rgb_jogada/jogada
add wave -noupdate /tb_rgb_explorer/dut/cod_rgb_jogada/display
add wave -noupdate -divider {edge detector rgb}
add wave -noupdate /tb_rgb_explorer/dut/fd/sinal_btn_modo
add wave -noupdate /tb_rgb_explorer/dut/fd/rst_detect_modo
add wave -noupdate /tb_rgb_explorer/dut/fd/sinal_btn_rgb
add wave -noupdate /tb_rgb_explorer/dut/fd/rst_detect_rgb
add wave -noupdate /tb_rgb_explorer/dut/fd/detect_btn_rgb/pulso
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {191470300868 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {201075 us}
