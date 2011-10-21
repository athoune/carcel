-module(carcel).

-export([can/2, can/3, check/2, check/3, sort/1, compact/1]).

% Can I do this action with this acl?
can(Acls, Actions) -> raw_can(Acls, Actions).
can(Acls, Actions, Context) ->
    raw_can(dynamics(Acls, Context), dynamics(Actions, Context)).

raw_can([Acl | Acls], [Action | Actions]) ->
    if
        (Acl == Action) or (Acl == '_') or (Action == '_') -> raw_can(Acls, Actions);
        true -> false
    end;
raw_can(_, []) -> true;
raw_can([], _) -> true.

dynamic(Value, Context) when is_function(Value) -> Value(Context);
dynamic(Value, _) -> Value.

dynamics(Values, Context) ->
    lists:map(fun(Value) -> dynamic(Value, Context) end, Values).

% Is there any acl wich match this action?
check(Acls, Action, Context) -> check(dynamics(Acls, Context), Action).

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
