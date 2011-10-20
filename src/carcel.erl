-module(carcel).

-export([can/2]).

-ifdef(TEST).
-compile(export_all).
-include_lib("eunit/include/eunit.hrl").
-endif.

can([Acl | Acls], [Action | Actions]) ->
    if
        (Acl == Action) or (Acl == '_') or (Action == '_') -> can(Acls, Actions);
        true -> false
    end;
can(_, []) -> true;
can([], _) -> true.

