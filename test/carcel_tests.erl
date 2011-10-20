-module(carcel_tests).
-include_lib("eunit/include/eunit.hrl").

carcel_test() ->
    Acl = ["erlang.net", article, 42, write],
    ?assert(carcel:can(Acl, ["erlang.net", article])),
    ?assert(not(carcel:can(Acl, ["erlang.net", blog]))).
