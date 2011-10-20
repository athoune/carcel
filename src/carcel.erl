-module(carcel).

-export([can/2]).

-ifdef(TEST).
-compile(export_all).
-endif.

can([Acl | Acls], [Action, Actions]) ->
    case Acl of
        Action -> can(Acls, Actions);
             _ -> false
    end;

can(Acl, [Action, _Actions]) ->
    case Acl of
        Action -> true;
             _ -> false
    end;

can([Acl | _Acls], Action) ->
    case Acl of
        Action -> true;
             _ -> false
    end;

can(Acl, Action) ->
    case Acl of
        Action -> true;
             _ -> false
    end.

