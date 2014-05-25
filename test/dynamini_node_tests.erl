-module(dynamini_node_tests).

-include_lib("eunit/include/eunit.hrl").

dynamini_node_test_() ->
    {foreach,
        fun() ->
            {ok, Node} = start_dynamini_node(),
            Node
        end,
        fun(_) -> ok end,
        [
            fun(Node) ->
                {
                    "Standard get/put operations",
                    [
                        ?_assertEqual(undefined, dynamini_node:get(Node, foo)),
                        ?_assertEqual(ok, dynamini_node:put(Node, foo, bar)),
                        ?_assertEqual(bar, dynamini_node:get(Node, foo))
                    ]
                }
            end,
            fun(Node) ->
                {
                    "Second (fresh node) set of tests, should be new data",
                    [
                        ?_assertEqual(undefined, dynamini_node:get(Node, foo)),
                        ?_assertEqual(ok, dynamini_node:put(Node, foo, bar)),
                        ?_assertEqual(bar, dynamini_node:get(Node, foo))
                    ]
                }
            end
        ]
    }.

start_dynamini_node() ->
    dynamini_node:start().
