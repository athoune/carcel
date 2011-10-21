-module(carcel_tests).
-include_lib("eunit/include/eunit.hrl").

carcel_test() ->
    Acl = ["erlang.net", article, 42, write],
    ?assert(carcel:can(Acl, ["erlang.net", article])),
    ?assert(not(carcel:can(Acl, ["erlang.net", blog]))),
    ?assert(carcel:can(Acl, ['_', article])),
    ?assert(carcel:can(Acl, ['_', article, '_', write])).

carcel_check_test() ->
    Acls = [
        ["erlang.net", article, 42, write],
        ["erlang.net", article, 43, write]
    ],
    ?assert(not(carcel:check(Acls, ["erlang.net", article, 44]))),
    ?assert(carcel:check(Acls, ["erlang.net", article, 42])).

sort_test() ->
    Acls = [
        ["erlang.net", article, 42, write],
        ["erlang.net", comment, '_', moderate],
        ["erlang.net", stats]
    ],
    ?debugFmt("~w~n", [carcel:sort(Acls)]).
 
