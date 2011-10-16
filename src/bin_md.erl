%%%-----------------------------------------------------------------
%%% converts binary to hex representation.
%%% Example:
%%% bin_md:to_bin_text(<<1,18,35,52,69>>) -> <<"0112233445">>
%%%
%%% The sd2 module used in tests down here is just a copy of
%%% ssl_debug.erl from OTP compiled with 'export_all'.
%%%
%%% You can use, reuse and abuse this code.
%%%-----------------------------------------------------------------
-module(bin_md).
-compile(export_all).
%-export([md/1, to_bin_text/1]).

-ifdef(PROPER).
-include_lib("proper/include/proper.hrl").
-endif.

md(Bin) ->
    D = crypto:sha(Bin),
    to_bin_text(D).

%-------------------------------------------------------------------
to_bin_text(<<>>) ->
    <<>>;
to_bin_text(Data) ->
    to_bin_text(Data, <<>>).

%-------------------------------------------------------------------
to_bin_text(<<>>, Acc) ->
    Acc;
to_bin_text(<<H:1/binary, T/binary>>, Acc) ->
    {High, Low} = conv_byte(H),
    to_bin_text(T, <<Acc/binary, High/binary, Low/binary>>).

%-------------------------------------------------------------------
conv_byte(<<H:4, L:4>>) ->
    {conv_nibble(H), conv_nibble(L)}.

%-------------------------------------------------------------------
conv_nibble(0) -> <<"0">>;
conv_nibble(1) -> <<"1">>;
conv_nibble(2) -> <<"2">>;
conv_nibble(3) -> <<"3">>;
conv_nibble(4) -> <<"4">>;
conv_nibble(5) -> <<"5">>;
conv_nibble(6) -> <<"6">>;
conv_nibble(7) -> <<"7">>;
conv_nibble(8) -> <<"8">>;
conv_nibble(9) -> <<"9">>;
conv_nibble(10) -> <<"A">>;
conv_nibble(11) -> <<"B">>;
conv_nibble(12) -> <<"C">>;
conv_nibble(13) -> <<"D">>;
conv_nibble(14) -> <<"E">>;
conv_nibble(15) -> <<"F">>.

%-------------------------------------------------------------------
-ifdef(PROPER).
prop_to_bin_text() ->
    crypto:start(),
    ?FORALL(N,
        range(1, 256),
        ?FORALL(D,
            binary(N),
            begin
                Res1 = to_bin_text(D),
                Res2s = lists:flatten(sd2:hexify(binary_to_list(D))),
                Res2l = [X || X <- Res2s, X =/= 32],
                Res2 = list_to_binary(Res2l),
                Res1 =:= Res2
            end
        )
    ).

prop_conv_byte() ->
    crypto:start(),
    ?FORALL({D},
        {binary(1)},
        begin
            {Res1a, Res1b} = conv_byte(D),
            Res1 = <<Res1a/binary, Res1b/binary>>,
            Res2l = [sd2:hex_byte(B) || B <- binary_to_list(D)],
            Res2 = list_to_binary(Res2l),
            Res1 =:= Res2
        end
    ).
-endif.
%%-----------------------------------------------------------------------------
