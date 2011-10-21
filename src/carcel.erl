-module(carcel).

-export([can/2, check/2, sort/1, compact/1]).

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

% Remove ACL wrapped by a stronger one
compact(Acls) ->
    {_, Compacted} = lists:foldl(
        fun(Elem, {nil, []}) -> {Elem, []};
        (Elem, {P, Acc}) ->
            case can(Elem, P) of
                true  ->
                    io:format("~w > ~w~n", [P, Elem]),
                    Acc2 = case lists:last(Acc)  of
                        P -> Acc;
                        _ -> Acc ++ [P]
                    end,
                    {P, Acc2};
                false -> {Elem, Acc ++ [P]}
            end
        end,
    {nil, []},sort(Acls)),
    Compacted.
