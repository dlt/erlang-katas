-module(misc).

-export([is_lat/1]).
-export([demo1/0]).
-export([qsort/1]).
-export([create_person/2]).
-export([filter/2]).
-export([subst/4]).

-record(person, {name = "person name", age = 0}).

is_lat(L) ->
  lists:all(fun(El) -> is_atom(El) end, L).

qsort([]) -> [];
qsort([Pivot|T]) ->
  qsort([X || X <- T, X < Pivot])
  ++ [Pivot] ++
  qsort([X || X <- T, X >= Pivot]).


create_person(Name, Age) ->
  #person{name = Name, age = Age}.


filter(P, [H|T]) ->
  case P(H) of
    true -> [H|filter(P, T)];
    false -> filter(P, T)
  end;
filter(_, []) ->
  [].

generate_exception(1) -> a;
generate_exception(2) -> throw(a);
generate_exception(3) -> exit(a);
generate_exception(4) -> { 'EXIT', a};
generate_exception(5) -> erlang:error(a).


demo1() ->
  [catcher(I) || I <- [1, 2, 3, 4, 5]].

catcher(N) ->
  try generate_exception(N) of
    Val -> {N, normal, Val}
  catch
    throw:X -> {N, caught, thrown, X};
    exit:X -> {N, caught, exited, X};
    error:X -> {N, caught, error, X}
  end.



subst(_, _, _, []) ->
  [];
subst(New, A1, A2, Lat) ->
case hd(Lat) of
  A1 ->
    [New|tl(Lat)];
  A2 ->
    [New|tl(Lat)];
  _ ->
    [hd(Lat)|subst(New, A1, A2, tl(Lat))]
end.

