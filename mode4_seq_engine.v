module mode4_seq_engine #(
    parameter integer MAX_SEQ_LEN = 4,
    parameter integer SHOW_CYCLES = 2000,
    parameter integer GAP_CYCLES = 500
) (
    input        clock,
    input  [5:0] rnd_step,
    input        registra_seq,
    input        zera_seq_len,
    input        conta_seq_len,
    input        zera_idx_show,
    input        conta_idx_show,
    input        zera_idx_input,
    input        conta_idx_input,
    input        zera_t_show,
    input        conta_t_show,
    input        zera_t_gap,
    input        conta_t_gap,
    output       fim_t_show,
    output       fim_t_gap,
    output       fim_show_seq,
    output       fim_input_seq,
    output       seq_no_max,
    output [5:0] seq_show_word,
    output [5:0] seq_input_word
);
    localparam integer IDX_BITS = (MAX_SEQ_LEN > 1) ? $clog2(MAX_SEQ_LEN) : 1;
    localparam integer LEN_BITS = (MAX_SEQ_LEN > 1) ? $clog2(MAX_SEQ_LEN+1) : 1;
    localparam integer SHOW_BITS = (SHOW_CYCLES > 1) ? $clog2(SHOW_CYCLES) : 1;
    localparam integer GAP_BITS = (GAP_CYCLES > 1) ? $clog2(GAP_CYCLES) : 1;

    reg [5:0] seq_mem [0:MAX_SEQ_LEN-1];
    reg [LEN_BITS-1:0] seq_len;
    reg [IDX_BITS-1:0] idx_show;
    reg [IDX_BITS-1:0] idx_input;
    reg [SHOW_BITS-1:0] q_show_timer;
    reg [GAP_BITS-1:0] q_gap_timer;

    assign seq_no_max = (seq_len == MAX_SEQ_LEN);
    assign fim_show_seq = (idx_show == seq_len-1);
    assign fim_input_seq = (idx_input == seq_len-1);
    assign fim_t_show = (q_show_timer == SHOW_CYCLES-1);
    assign fim_t_gap = (q_gap_timer == GAP_CYCLES-1);

    assign seq_show_word = seq_mem[idx_show];
    assign seq_input_word = seq_mem[idx_input];

    always @(posedge clock) begin
        if (zera_seq_len)
            seq_len <= 1;
        else if (conta_seq_len && !seq_no_max)
            seq_len <= seq_len + 1'b1;

        if (zera_idx_show)
            idx_show <= {IDX_BITS{1'b0}};
        else if (conta_idx_show && idx_show < MAX_SEQ_LEN-1)
            idx_show <= idx_show + 1'b1;

        if (zera_idx_input)
            idx_input <= {IDX_BITS{1'b0}};
        else if (conta_idx_input && idx_input < MAX_SEQ_LEN-1)
            idx_input <= idx_input + 1'b1;

        if (registra_seq)
            seq_mem[seq_len-1] <= rnd_step;

        if (zera_t_show)
            q_show_timer <= {SHOW_BITS{1'b0}};
        else if (conta_t_show && !fim_t_show)
            q_show_timer <= q_show_timer + 1'b1;

        if (zera_t_gap)
            q_gap_timer <= {GAP_BITS{1'b0}};
        else if (conta_t_gap && !fim_t_gap)
            q_gap_timer <= q_gap_timer + 1'b1;
    end
endmodule
