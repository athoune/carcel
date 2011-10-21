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
    ?assertEqual( ["erlang.net", stats], lists:nth(1, carcel:sort(Acls))).

compact_test() ->
    Acls = [
        ["erlang.net", article, 42, write],
        ["erlang.net", article],
        ["erlang.net", stats]
    ],
    ?assert(not(lists:member(["erlang.net", article, 42, write], carcel:compact(Acls)))).

dynamic_test() ->
    Acl = ["erlang.net", article, fun(Context) -> Context + 22 end, write],
    ?assert(carcel:can(Acl, ["erlang.net", article], 20)),
    ?assert(carcel:can(Acl, ["erlang.net", article, 42], 20)).
