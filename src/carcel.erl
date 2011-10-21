-module(carcel).

-export([can/2, check/2, sort/1]).

% Can I do this action with this acl?
can([Acl | Acls], [Action | Actions]) ->
    if
        (Acl == Action) or (Acl == '_') or (Action == '_') -> can(Acls, Actions);
        true -> false
    end;
can(_, []) -> true;
can([], _) -> true.

% Is there any acl wich match this action?
check([Acl | Acls], Action) ->
    case can(Acl, Action) of
        false -> check(Acls, Action);
        T -> T
    end;
check([], _Action) ->
    false.

% Sort ACLs to try to catch something soon.
sort(Acls) ->
    lists:sort(fun(A, B) ->
        length(A) < length(B)
    end, Acls).
