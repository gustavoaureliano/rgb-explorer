from pathlib import Path
import subprocess


ROOT = Path(__file__).resolve().parents[1]
OUT_SVG = ROOT / "imagens" / "pinout_fpga_sistema.svg"
OUT_PNG = ROOT / "imagens" / "pinout_fpga_sistema.png"


GPIO0_PINS = {
    0: "N16", 2: "M16", 4: "D17", 6: "K21", 8: "M20", 10: "N21", 12: "R21",
    14: "N20", 16: "M22", 18: "L22", 20: "P16", 22: "L18", 24: "L19", 26: "K19",
    28: "R15", 30: "R16", 32: "T19", 34: "T17", 1: "B16", 3: "C16", 5: "K20",
    7: "K22", 9: "M21", 11: "R22", 13: "T22", 15: "N19", 17: "P19", 19: "P17",
    21: "M18", 23: "L17", 25: "K17", 27: "P18", 29: "R17", 31: "T20", 33: "T18",
    35: "T15",
}

GPIO1_PINS = {
    0: "H16", 2: "H15", 4: "A13", 6: "C13", 8: "G18", 10: "H18", 12: "J19",
    14: "H10", 16: "H14", 18: "J13", 20: "A14", 22: "C15", 24: "E15", 26: "F14",
    28: "F13", 30: "G16", 32: "G13", 34: "J17", 1: "A12", 3: "B12", 5: "B13",
    7: "D13", 9: "G17", 11: "J18", 13: "G11", 15: "J11", 17: "A15", 19: "L8",
    21: "B15", 23: "E14", 25: "E16", 27: "F15", 29: "F12", 31: "G15", 33: "G12",
    35: "K16",
}

GPIO0_SIG = {
    0: "btn_modo",
    2: "btns_plus_rgb[0]",
    4: "btns_plus_rgb[1]",
    5: "btn_jogar",
    6: "btns_plus_rgb[2]",
    7: "btn_confirma",
    9: "btns_minus_rgb[0]",
    11: "btns_minus_rgb[1]",
    13: "btns_minus_rgb[2]",
    15: "intensidade_r[0]",
    17: "intensidade_r[1]",
    19: "intensidade_r[2]",
    21: "intensidade_r[3]",
    23: "intensidade_g[0]",
    25: "intensidade_g[1]",
    27: "intensidade_g[2]",
    29: "intensidade_g[3]",
    31: "intensidade_b[0]",
    33: "intensidade_b[1]",
    34: "intensidade_b[3]",
    35: "intensidade_b[2]",
}

GPIO1_SIG = {
    0: "hex7seg_pontuacao[0]",
    1: "hex7seg_modo[0]",
    2: "hex7seg_pontuacao[1]",
    3: "hex7seg_modo[1]",
    4: "hex7seg_pontuacao[2]",
    5: "hex7seg_modo[2]",
    6: "hex7seg_pontuacao[3]",
    7: "hex7seg_modo[3]",
    8: "hex7seg_pontuacao[4]",
    9: "hex7seg_modo[4]",
    10: "hex7seg_pontuacao[5]",
    11: "hex7seg_modo[5]",
    12: "hex7seg_pontuacao[6]",
    13: "hex7seg_modo[6]",
    15: "rgb_jogada[0]",
    17: "rgb_jogada[1]",
    19: "rgb_jogada[2]",
    21: "rgb_alvo[0]",
    23: "rgb_alvo[1]",
    25: "rgb_alvo[2]",
    27: "leds_erro[0]",
    29: "leds_erro[1]",
    31: "leds_erro[2]",
    33: "leds_nivel[0]",
    34: "leds_nivel[2]",
    35: "leds_nivel[1]",
}

LEFT_ROWS = [0, 2, 4, 6, 8, "VCC5", 10, 12, 14, 16, 18, 20, 22, 24, "VCC3P3", 26, 28, 30, 32, 34]
RIGHT_ROWS = [1, 3, 5, 7, 9, "GND", 11, 13, 15, 17, 19, 21, 23, 25, "GND", 27, 29, 31, 33, 35]

W = 3500
H = 1120
JP1_X = 760
JP2_X = 2640
HEADER_W = 120
HEADER_H = 860
ROW_START = 170
ROW_STEP = 41
ROWS = 20

COORDS1 = (185, JP1_X - HEADER_W // 2, 20, 190, 285, JP1_X + HEADER_W // 2, 1280, 1295, 1240, 1100)
COORDS2 = (1880, JP2_X - HEADER_W // 2, 1650, 1890, 1970, JP2_X + HEADER_W // 2, 3220, 3240, 3180, 3000)


def draw_header(lines, cx, title, jp):
    lines.append(f'<text x="{cx-40}" y="110" class="hdr">{title}</text>')
    lines.append(f'<text x="{cx-20}" y="134" class="hdr">{jp}</text>')
    lines.append(
        f'<rect x="{cx-HEADER_W//2}" y="140" width="{HEADER_W}" height="{HEADER_H}" '
        'rx="10" fill="#111827" stroke="#374151" stroke-width="3"/>'
    )
    for i in range(ROWS):
        y = ROW_START + i * ROW_STEP
        lines.append(f'<circle cx="{cx-22}" cy="{y}" r="12" fill="#3f3f46" stroke="#d4a72c" stroke-width="2"/>')
        lines.append(f'<circle cx="{cx+22}" cy="{y}" r="12" fill="#3f3f46" stroke="#d4a72c" stroke-width="2"/>')
        lines.append(f'<text x="{cx-28}" y="{y+6}" class="n">{2*i+1}</text>')
        lines.append(f'<text x="{cx+16}" y="{y+6}" class="n">{2*i+2}</text>')


def draw_block(lines, prefix, pin_map, sig_map, coords):
    lstart, lend, lsys, lpin, lgpio, rstart, rend, rsys, rpin, rgpio = coords
    for i in range(ROWS):
        y = ROW_START + i * ROW_STEP
        left_slot, right_slot = LEFT_ROWS[i], RIGHT_ROWS[i]
        lines.append(f'<line x1="{lstart}" y1="{y}" x2="{lend}" y2="{y}" stroke="#ef4444" stroke-width="3"/>')
        if isinstance(left_slot, int):
            lines.append(f'<text x="{lgpio}" y="{y+5}" class="small">{prefix}{left_slot}</text>')
            lines.append(f'<text x="{lpin}" y="{y+5}" class="pin">{pin_map.get(left_slot, "-")}</text>')
            sig = sig_map.get(left_slot)
            if sig:
                lines.append(f'<text x="{lsys}" y="{y+5}" class="sys">{sig}</text>')
        else:
            lines.append(f'<text x="{lsys}" y="{y+5}" class="power">{left_slot}</text>')
        lines.append(f'<line x1="{rstart}" y1="{y}" x2="{rend}" y2="{y}" stroke="#ef4444" stroke-width="3"/>')
        if isinstance(right_slot, int):
            lines.append(f'<text x="{rgpio}" y="{y+5}" class="small">{prefix}{right_slot}</text>')
            lines.append(f'<text x="{rpin}" y="{y+5}" class="pin">{pin_map.get(right_slot, "-")}</text>')
            sig = sig_map.get(right_slot)
            if sig:
                lines.append(f'<text x="{rsys}" y="{y+5}" class="sys">{sig}</text>')
        else:
            lines.append(f'<text x="{rsys}" y="{y+5}" class="ground">{right_slot}</text>')


def main():
    lines = [
        '<?xml version="1.0" encoding="UTF-8"?>',
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}">',
        '<style>',
        '.title{font:700 34px DejaVu Sans,Arial,sans-serif;fill:#111827}',
        '.sub{font:500 18px DejaVu Sans,Arial,sans-serif;fill:#334155}',
        '.hdr{font:700 26px DejaVu Sans,Arial,sans-serif;fill:#1f2937}',
        '.small{font:600 16px DejaVu Sans Mono,monospace;fill:#111827}',
        '.pin{font:700 16px DejaVu Sans,Arial,sans-serif;fill:#1d4ed8}',
        '.sys{font:700 17px DejaVu Sans,Arial,sans-serif;fill:#0f766e}',
        '.power{font:700 17px DejaVu Sans,Arial,sans-serif;fill:#b91c1c}',
        '.ground{font:700 17px DejaVu Sans,Arial,sans-serif;fill:#374151}',
        '.n{font:700 18px DejaVu Sans,Arial,sans-serif;fill:#facc15}',
        '</style>',
        f'<rect x="0" y="0" width="{W}" height="{H}" fill="#f3f4f6"/>',
        '<text x="40" y="55" class="title">Pinout FPGA + sinais do sistema</text>',
    ]

    draw_header(lines, JP1_X, '(GPIO 0)', 'JP1')
    draw_header(lines, JP2_X, '(GPIO 1)', 'JP2')
    draw_block(lines, 'GPIO_0_D', GPIO0_PINS, GPIO0_SIG, COORDS1)
    draw_block(lines, 'GPIO_1_D', GPIO1_PINS, GPIO1_SIG, COORDS2)

    lines.append('</svg>')
    OUT_SVG.write_text('\n'.join(lines), encoding='utf-8')

    subprocess.run([
        'rsvg-convert', '-w', str(W), '-h', str(H), str(OUT_SVG), '-o', str(OUT_PNG)
    ], check=True)


if __name__ == '__main__':
    main()
