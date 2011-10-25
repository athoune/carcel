-module(carcel).

-export([can/2, can/3, check/2, check/3, sort/1, compact/1]).

% Can I do this action with this acl?
can(Acls, Actions) -> raw_can(Acls, Actions).
can(Acls, Actions, Context) ->
    raw_can(dynamics(Acls, Context), dynamics(Actions, Context)).

raw_can(Acls, Actions) when length(Actions) < length(Acls) -> false;% Acl is more specific than the action
raw_can(['_' | Acls], [_Action | Actions]) -> raw_can(Acls, Actions);
raw_can([_Acl| Acls], ['_' | Actions]) -> raw_can(Acls, Actions);
raw_can([Acl | Acls], [Action | Actions]) when  is_list(Action) or is_list(Acl) ->
    case list_compare(Acl, Action) of
        true -> raw_can(Acls, Actions);
        false -> false
    end;
raw_can([A | Acls], [A | Actions]) -> raw_can(Acls, Actions);
raw_can(_, []) -> true;
raw_can([], _) -> true;
raw_can(_, _) -> false.

dynamic(Value, Context) when is_function(Value) -> Value(Context);
dynamic(Value, _) -> Value.

dynamics(Values, Context) ->
    lists:map(fun(Value) -> dynamic(Value, Context) end, Values).

list_compare([A | _Acls], A) -> true;
list_compare([_Acl | Acls], Action) -> list_compare(Acls, Action);
list_compare([], _Action) -> false;
list_compare(A, [A | _Actions]) -> true;
list_compare(Acl, [_Action | Actions]) -> list_compare(Acl, Actions);
list_compare(_Acl, []) -> false.
% TODO list_compare([Acl | Acls], [Action | Actions]) ->

% Is there any acl wich match this action?
check(Acls, Action, Context) -> check(dynamics(Acls, Context), Action).

check([Acl | Acls], Action) ->
    case can(Acl, Action) of
        false -> check(Acls, Action);
        T -> T
    end;
check([], _Action) -> false.

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
