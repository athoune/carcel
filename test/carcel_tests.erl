-module(carcel_tests).
-include_lib("eunit/include/eunit.hrl").

carcel_test() ->
    Writer = ["erlang.net", article, 42, write],
    Editor = ["erlang.net", article],
    ?assert(not(carcel:can(Writer, ["erlang.net", article]))),
    ?assert(carcel:can(Editor, ["erlang.net", article])),
    ?assert(not(carcel:can(Editor, ["erlang.net", blog]))),
    ?assert(carcel:can(Editor, ['_', article])),
    ?assert(carcel:can(Writer, ['_', article, '_', write])).

carcel_check_test() ->
    Acls = [
        ["erlang.net", article, 42, write],
        ["erlang.net", article, 43, write]
    ],
    ?assert(not(carcel:check(Acls, ["erlang.net", article, 44, write]))),
    ?assert(carcel:check(Acls, ["erlang.net", article, 42, write])).

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
    ?assert(carcel:can(Acl, ["erlang.net", article, 42, write], 20)),
    ?assert(not(carcel:can(Acl, ["erlang.net", article, 42, write], 19))).
