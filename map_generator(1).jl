seed = srand(124534)


# Parameters
latitude = 5
longtitude = 5
density = 0.2
time_length = 250
max_tip = 10
# ------------

vertical = 1
horizontal = 2

c = zeros(latitude, longtitude)  #whether a node is a costomer node
time = zeros(latitude, longtitude)
cost = 2*time_length*ones(latitude, longtitude, 2)
#cost[i][j][vertical] --> the cost from (i, j) to (i+1, j)
#cost[i][j][horizontal] --> the cost from (i, j) to (i, j+1)

tips = zeros(latitude, longtitude)

for i in 1:latitude
    for j in 1:longtitude
        if rand() < density  #generate a customer;
            c[i, j] = 1;
            time[i, j] = rand() * time_length;
            tips[i, j] = rand() * max_tip;#/asdfasdf;lkasjd;lfkj
        end

        if i != latitude #generate the cost of each legal route
            cost[i, j, vertical] = ceil(Int64, rand() * time_length/(latitude*longtitude)*((1-density).^2))
        end
        if j != longtitude
            cost[i, j, horizontal] = ceil(Int64, rand() * time_length/(latitude*longtitude)*((1-density).^2))
        end
    end
end

c[ceil(Int64, rand() * latitude), ceil(Int64, rand() * longtitude)] = 2


@printf("cost graph of the map:")

for i in 1:latitude
    if i != 1
        for j in 1:longtitude
            @printf("%2.d      ", cost[i-1, j, vertical])
        end
    end
    @printf("\n")
    for j in 1:longtitude
        if c[i, j] == 1
            @printf(" C  ")
        end
        if c[i, j] == 2
            @printf(" R  ")
        end
        if c[i, j] == 0
            @printf(" 0  ")
        end
        if j != longtitude
            @printf("%2.d  ", cost[i, j, horizontal]);
        end
    end
    @printf("\n")
end
