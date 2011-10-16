%%%-----------------------------------------------------------------
%%% The sd2 module used in tests down here is just a copy of
%%% ssl_debug.erl from OTP compiled with 'export_all'.
%%% The sd2b module used in tests down here is a copy of
%%% ssl_debug.erl with asciify/1 replaced with a stub.
%%%
%%% You can use, reuse and abuse this code.
%%%-----------------------------------------------------------------

-module(cmp_hex).
-compile(export_all).

% Time:
%
% for sd2 (hex_asc/0 calls both hexify/1 and asciify/1):
% cmp_hex:batch(100000) -> {100000,3.018612,6.330802}
%
% for sd2b (hex_asc/0 calls only hexify/1):
% cmp_hex:batch(100000) -> {100000,2.998139,5.421503}

batch() ->
    batch(10).

batch(N) ->
    crypto:start(),
    F = fun(_, {A1, A2}) ->
        {T1, T2} = step(),
        {A1 + T1, A2 + T2}
    end,
    {Res1, Res2} = lists:foldl(F, {0.0, 0.0}, lists:duplicate(N, true)),
    error_logger:info_report({N, Res1 / 1.0e6, Res2 / 1.0e6}),
    {Res1, Res2}.

gen_bin() ->
    Len = crypto:rand_uniform(1, 256),
    crypto:rand_bytes(Len).

step() ->
    Bin = gen_bin(),
    step(Bin).

step(Bin) ->
    {T1, _} = t1(Bin),
    {T2, _} = t2(Bin),
    {T1, T2}.

t1(Bin) ->
    timer:tc(bin_md, to_bin_text, [Bin]).

t2(Bin) ->
    timer:tc(sd2, hex, [Bin]).
