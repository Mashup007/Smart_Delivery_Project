
using JuMP, Clp
using Graphs, Combinatorics


function optimalRoute(graph, eweights1, resturant, customers, tips, deadline, option)
    #1.compute cost for each route
    #collect all possible routes
    possible_routes = collect( permutations(customers) )
    #initialize the cost for each route
    cost_routes = zeros(length(possible_routes))

    for k = 1 : length(possible_routes)

        routes = possible_routes[k]

        resturant_shortest_path = dijkstra_shortest_paths(graph, eweights1, resturant[1])

        #dist to deliver from resturant to first customer
        resturant_to_first = resturant_shortest_path.dists[routes[1]]
        accu_dist = resturant_to_first
        tip = 0

        if option == "deadline_require"
            for i = 1 : length(routes)
                if i < length(routes)
                    #compute arrive time
                    at = accu_dist*1; #assume speed is 1
                    if at > deadline[routes[i]]
                        tip = tip + 9999;

                        #compute the dist for the current to the next customer
                        cur_customer = routes[i]
                        next_customer = routes[i+1]

                        shortest_path = dijkstra_shortest_paths(graph, eweights1, cur_customer)
                        accu_dist = accu_dist + shortest_path.dists[next_customer]
                        cost_routes[k] = accu_dist + tip;
                    end
                end
            end
        elseif option == "deadline_not_require"
            for i = 1 : length(routes)
                if i < length(routes)
                    # tips from current customer
                    tip = tip + tips[routes[i]];
                    #compute the dist for the current to the next customer
                    cur_customer = routes[i]
                    next_customer = routes[i+1]

                    shortest_path = dijkstra_shortest_paths(graph, eweights1, cur_customer)
                    accu_dist = accu_dist + shortest_path.dists[next_customer]
                    cost_routes[k] = accu_dist + tip;
                end
            end
        else
            println("invalid option. Should not happen")
            return
        end

        #dist to deliver from last customer back to resturant
        last_to_resturant = resturant_shortest_path.dists[routes[end]]
        # collect tip from the last costumer
        tip = accu_dist*0.3*0 + tip;
        accu_dist = accu_dist + last_to_resturant
        cost_routes[k] = accu_dist + tip

    end

    #2. find the optimal route(s) with minimum cost
    optimal_routes = find( a->a == minimum(cost_routes), cost_routes)
    optimal_order = Array[];
    for i  = 1 : length(optimal_routes)
        order = [1 ; possible_routes[optimal_routes[i]]; 1];
        push!(optimal_order,order)
    end

    optimal_routes_detail = Array[]
    for i  = 1 : length(optimal_routes)
        optimal_routes_detail_cur = []
        optimal_order_cur = optimal_order[i];
        for j = 1 : length(optimal_order_cur)
            if j < length(optimal_order_cur)
                cur_node = optimal_order_cur[j]
                next_node = optimal_order_cur[j+1]
                # obtain the specific traverse order in the shortest path recorded in Dijkstra's Algorithm
                shortest_path = dijkstra_shortest_paths(graph, eweights1,cur_node)
                paths = enumerate_paths(vertices(graph), shortest_path.parent_indices)

                if (length(optimal_routes_detail_cur) == 0)
                    optimal_routes_detail_cur = paths[next_node]
                else
                    optimal_routes_detail_cur = [optimal_routes_detail_cur ; paths[next_node][2:end]]
                end
            end
        end
        push!(optimal_routes_detail, optimal_routes_detail_cur)
    end
    return (optimal_order, optimal_routes_detail, cost_routes)

end


# graph g1 has 5 vertices
g1 = simple_inclist(5,is_directed=false)

# edge and weight of g1. (vertex1,vertex2,weight)
g1_wedges = [
    (1,2,6),
    (1,4,1),
    (2,3,5),
    (2,4,2),
    (2,5,2),
    (3,5,5),
    (4,5,1)
    ]

ne = length(g1_wedges)
eweights1 = zeros(ne)

# add edge and weight to graph
for i = 1 : ne
    we = g1_wedges[i]
    add_edge!(g1, we[1], we[2])
    eweights1[i] = we[3]
end

resturant = [1]
customers = [3,5,2]
tips = Dict(zip(customers,[0,0,0]))
deadline = Dict(zip(customers,[5,10,15]))
option = "deadline_not_require"

(optimal_order, optimal_routes_detail, cost_routes) = optimalRoute(g1, eweights1, resturant, customers, tips, deadline, option)

println("cost:")
for i = 1 : length(cost_routes)
    println("route ",i,": ",cost_routes[i])
end

println("optimal order:")
for i = 1 : length(optimal_order)
    println("route ",i,": ",optimal_order[i])
end

println("optimal routes:")
for i = 1 : length(optimal_routes_detail)
    println("route ",i,": ",optimal_routes_detail[i])
end

#zip

#a[1]

#customers = [3,5,2]
#tips = []

#deadline = Dict(zip(customers,[5,10,15]))

#deadline[5]
