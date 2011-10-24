-module(carcel).

-export([can/2, can/3, check/2, check/3, sort/1, compact/1]).

% Can I do this action with this acl?
can(Acls, Actions) -> raw_can(Acls, Actions).
can(Acls, Actions, Context) ->
    raw_can(dynamics(Acls, Context), dynamics(Actions, Context)).

raw_can([Acl | Acls], [Action | Actions]) ->
    if
        length(Actions) < length(Acls) -> false;% Acl is more specific than the action
        (Acl == '_') or (Action == '_') -> raw_can(Acls, Actions);
        is_list(Action) or is_list(Acl) ->
            case list_compare(Acl, Action) of
                true -> raw_can(Acls, Actions);
                false -> false
            end;
        Acl == Action -> raw_can(Acls, Actions);
        true -> false
    end;
raw_can(_, []) -> true;
raw_can([], _) -> true.

dynamic(Value, Context) when is_function(Value) -> Value(Context);
dynamic(Value, _) -> Value.

dynamics(Values, Context) ->
    lists:map(fun(Value) -> dynamic(Value, Context) end, Values).

list_compare([Acl | Acls], Action) ->
    if
        Acl == Action -> true;
        true -> list_compare(Acls, Action)
    end;
list_compare([], _Action) -> false;
list_compare(Acl, [Action | Actions]) ->
    if
        Acl == Action -> true;
        true -> list_compare(Acl, Actions)
    end;
list_compare(_Acl, []) -> false.
% TODO list_compare([Acl | Acls], [Action | Actions]) ->

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

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

    list_compare_test() ->
        ?assert(list_compare([a, b, c, d], a)),
        ?assert(list_compare(b, [a, b, c, d])),
        ?assert(not(list_compare([a, b, c, d], e))),
        ?assert(not(list_compare(e, [a, b, c, d]))).

-endif.
