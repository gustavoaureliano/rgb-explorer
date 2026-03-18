onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_rgb_explorer/clockPeriod
add wave -noupdate /tb_rgb_explorer/clock
add wave -noupdate /tb_rgb_explorer/btn_reset
add wave -noupdate /tb_rgb_explorer/btn_modo
add wave -noupdate /tb_rgb_explorer/btn_jogar
add wave -noupdate /tb_rgb_explorer/btn_confirma
add wave -noupdate /tb_rgb_explorer/btns_plus_rgb
add wave -noupdate /tb_rgb_explorer/btns_minus_rgb
add wave -noupdate /tb_rgb_explorer/rgb_alvo
add wave -noupdate /tb_rgb_explorer/rgb_jogada
add wave -noupdate /tb_rgb_explorer/leds_nivel
add wave -noupdate /tb_rgb_explorer/hex7seg_pontuacao
add wave -noupdate /tb_rgb_explorer/hex7seg_modo
add wave -noupdate /tb_rgb_explorer/buzzer
add wave -noupdate -divider UC
add wave -noupdate /tb_rgb_explorer/dut/uc/inicial
add wave -noupdate /tb_rgb_explorer/dut/uc/sel_modo
add wave -noupdate /tb_rgb_explorer/dut/uc/reg_modo
add wave -noupdate /tb_rgb_explorer/dut/uc/espera_btn
add wave -noupdate /tb_rgb_explorer/dut/uc/reg_rgb_btn
add wave -noupdate /tb_rgb_explorer/dut/uc/muda_rgb
add wave -noupdate /tb_rgb_explorer/dut/uc/rst_pontos
add wave -noupdate /tb_rgb_explorer/dut/uc/clock
add wave -noupdate /tb_rgb_explorer/dut/uc/btn_reset
add wave -noupdate /tb_rgb_explorer/dut/uc/btn_jogar
add wave -noupdate /tb_rgb_explorer/dut/uc/jogada
add wave -noupdate -radix hexadecimal /tb_rgb_explorer/dut/uc/s_modo
add wave -noupdate /tb_rgb_explorer/dut/uc/zera_rgb_jogada
add wave -noupdate /tb_rgb_explorer/dut/uc/zera_rgb_alvo
add wave -noupdate /tb_rgb_explorer/dut/uc/zera_pontuacao
add wave -noupdate /tb_rgb_explorer/dut/uc/zera_nivel
add wave -noupdate /tb_rgb_explorer/dut/uc/zera_modo
add wave -noupdate /tb_rgb_explorer/dut/uc/registra_jogada
add wave -noupdate /tb_rgb_explorer/dut/uc/registra_rgb_alvo
add wave -noupdate /tb_rgb_explorer/dut/uc/registra_pontuacao
add wave -noupdate /tb_rgb_explorer/dut/uc/mudar_rgb
add wave -noupdate /tb_rgb_explorer/dut/uc/conta_nivel
add wave -noupdate /tb_rgb_explorer/dut/uc/conta_modo
add wave -noupdate -radix hexadecimal /tb_rgb_explorer/dut/uc/Eatual
add wave -noupdate -radix hexadecimal /tb_rgb_explorer/dut/uc/Eprox
add wave -noupdate -divider FD
add wave -noupdate /tb_rgb_explorer/dut/fd/rgb_leds_modulus
add wave -noupdate /tb_rgb_explorer/dut/fd/rgb_num_bits
add wave -noupdate /tb_rgb_explorer/dut/fd/mode_modulus
add wave -noupdate /tb_rgb_explorer/dut/fd/mode_num_bits
add wave -noupdate /tb_rgb_explorer/dut/fd/rgb_reg_num_bits
add wave -noupdate /tb_rgb_explorer/dut/fd/clock
add wave -noupdate /tb_rgb_explorer/dut/fd/zera_rgb_jogada
add wave -noupdate /tb_rgb_explorer/dut/fd/zera_rgb_alvo
add wave -noupdate /tb_rgb_explorer/dut/fd/zera_pontuacao
add wave -noupdate /tb_rgb_explorer/dut/fd/zera_nivel
add wave -noupdate /tb_rgb_explorer/dut/fd/zera_modo
add wave -noupdate /tb_rgb_explorer/dut/fd/btns_plus_minus_rgb
add wave -noupdate /tb_rgb_explorer/dut/fd/registra_jogada
add wave -noupdate /tb_rgb_explorer/dut/fd/registra_rgb_alvo
add wave -noupdate /tb_rgb_explorer/dut/fd/registra_pontuacao
add wave -noupdate /tb_rgb_explorer/dut/fd/mudar_rgb
add wave -noupdate /tb_rgb_explorer/dut/fd/conta_nivel
add wave -noupdate /tb_rgb_explorer/dut/fd/conta_modo
add wave -noupdate /tb_rgb_explorer/dut/fd/jogada_feita
add wave -noupdate /tb_rgb_explorer/dut/fd/s_rgb_alvo
add wave -noupdate /tb_rgb_explorer/dut/fd/s_rgb_jogada
add wave -noupdate /tb_rgb_explorer/dut/fd/leds_nivel
add wave -noupdate /tb_rgb_explorer/dut/fd/s_modo
add wave -noupdate /tb_rgb_explorer/dut/fd/q_led_r
add wave -noupdate /tb_rgb_explorer/dut/fd/q_led_g
add wave -noupdate /tb_rgb_explorer/dut/fd/q_led_b
add wave -noupdate /tb_rgb_explorer/dut/fd/random
add wave -noupdate /tb_rgb_explorer/dut/fd/s_jogada
add wave -noupdate /tb_rgb_explorer/dut/fd/add_rgb_jogada
add wave -noupdate /tb_rgb_explorer/dut/fd/sub_rgb_jogada
add wave -noupdate -divider DUT
add wave -noupdate /tb_rgb_explorer/dut/fd/fim_timeout
add wave -noupdate /tb_rgb_explorer/dut/clock
add wave -noupdate /tb_rgb_explorer/dut/btn_reset
add wave -noupdate /tb_rgb_explorer/dut/btn_modo
add wave -noupdate /tb_rgb_explorer/dut/btn_jogar
add wave -noupdate /tb_rgb_explorer/dut/btn_confirma
add wave -noupdate /tb_rgb_explorer/dut/btns_plus_rgb
add wave -noupdate /tb_rgb_explorer/dut/btns_minus_rgb
add wave -noupdate /tb_rgb_explorer/dut/rgb_alvo
add wave -noupdate /tb_rgb_explorer/dut/rgb_jogada
add wave -noupdate /tb_rgb_explorer/dut/leds_nivel
add wave -noupdate /tb_rgb_explorer/dut/hex7seg_pontuacao
add wave -noupdate /tb_rgb_explorer/dut/hex7seg_modo
add wave -noupdate /tb_rgb_explorer/dut/buzzer
add wave -noupdate /tb_rgb_explorer/dut/zera_rgb_jogada
add wave -noupdate /tb_rgb_explorer/dut/registra_jogada
add wave -noupdate /tb_rgb_explorer/dut/zera_rgb_alvo
add wave -noupdate /tb_rgb_explorer/dut/registra_rgb_alvo
add wave -noupdate /tb_rgb_explorer/dut/zera_pontuacao
add wave -noupdate /tb_rgb_explorer/dut/registra_pontuacao
add wave -noupdate /tb_rgb_explorer/dut/zera_nivel
add wave -noupdate /tb_rgb_explorer/dut/conta_nivel
add wave -noupdate /tb_rgb_explorer/dut/zera_modo
add wave -noupdate /tb_rgb_explorer/dut/conta_modo
add wave -noupdate /tb_rgb_explorer/dut/jogada_feita
add wave -noupdate /tb_rgb_explorer/dut/mudar_rgb
add wave -noupdate /tb_rgb_explorer/dut/s_rgb_jogada
add wave -noupdate /tb_rgb_explorer/dut/s_rgb_alvo
add wave -noupdate /tb_rgb_explorer/dut/s_modo
add wave -noupdate -divider rgb_cod_jogada
add wave -noupdate /tb_rgb_explorer/dut/cod_rgb_jogada/clk
add wave -noupdate /tb_rgb_explorer/dut/cod_rgb_jogada/jogada
add wave -noupdate /tb_rgb_explorer/dut/cod_rgb_jogada/display
add wave -noupdate -divider rgb_pwm
add wave -noupdate /tb_rgb_explorer/dut/cod_rgb_jogada/led_pwm/clk
add wave -noupdate /tb_rgb_explorer/dut/cod_rgb_jogada/led_pwm/r
add wave -noupdate /tb_rgb_explorer/dut/cod_rgb_jogada/led_pwm/g
add wave -noupdate /tb_rgb_explorer/dut/cod_rgb_jogada/led_pwm/b
add wave -noupdate /tb_rgb_explorer/dut/cod_rgb_jogada/led_pwm/led_r
add wave -noupdate /tb_rgb_explorer/dut/cod_rgb_jogada/led_pwm/led_g
add wave -noupdate /tb_rgb_explorer/dut/cod_rgb_jogada/led_pwm/led_b
add wave -noupdate /tb_rgb_explorer/dut/cod_rgb_jogada/led_pwm/counter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {14818168139 ps} 0}
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
WaveRestoreZoom {87847581210 ps} {129308548720 ps}
