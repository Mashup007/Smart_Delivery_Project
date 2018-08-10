using JuMP, Gurobi, NamedArrays, Combinatorics

m = Model(solver = GurobiSolver(OutputFlag=0))
Cost_Per_Mile = 2
Vehicle_Max_Capacity = 15 # max capacity of each Truck

Routines = Array[]
Routines_tp = Array[]
Actual_Routines = Array[]
Cost_Array = Int64[]

Customers = [0,1,2,3,4,5]
Customers_Request = Dict(zip(Customers, [0 2 4 6 8 10]))
f = 0 # Counter --- useless
x = 0 # Counter --- useless

Distances_D_M = NamedArray([0 8 4 6 2 9
                            8 0 8 3 6 8
                            4 8 0 2 2 2
                            6 3 2 0 2 1
                            2 6 2 2 0 2
                            9 8 2 1 2 0],(Customers,Customers),("Customers","Customers"))

######### Gather All of the Routines and put them into an Array ###############
ppl = length(Customers)-1 # the first element is restaurant
for i in 2:length(Customers)
    Routines_tp = collect(permutations(Customers[2:end],ppl))
    push!(Routines,Routines_tp)
    ppl = ppl - 1
end

########## Get the Actual Routines that are possible to implement #############

for i in 1:length(Routines) # largest Array
    for k in 1:length(Routines[i]) # Array for 5 perms, 4 perms...
        sum = 0
        f += 1 # permutation counter --- useless
        exceed_capacity = 0
            for a in 1:length(Routines[i][k]) # lowest Array
                sum += Customers_Request[Routines[i][k][a]]
                #println([Routines[i][k][a]])
                if sum >= Vehicle_Max_Capacity
                    sum -= Customers_Request[Routines[i][k][a]]
                    exceed_capacity = 1 #indicate that this set exceeded max capacity
                    break
                end
            end
        if exceed_capacity != 1
            push!(Actual_Routines,Routines[i][k]) # Add the valid routine to Actual_Routines
            x += 1 # Counter ---- useless
        end
    end
end
println("Total elements should be in Actual_Routines: ", x )
println("Actual_Routines_length: ",length(Actual_Routines))
println("Actual_Routines: ",Actual_Routines)
# println(length(Actual_Routines[end]))

for i in 1:length(Actual_Routines)
    cost = 0
    switch = 0 # indicate whether is the first element of an array
    for j in 1:length(Actual_Routines[i])
        if j < length(Actual_Routines[i]) && length(Actual_Routines[i])>1
            if switch == 0
                cost += Cost_Per_Mile*Distances_D_M[0,Actual_Routines[i][j]]
                switch = 1
            end
            if switch == 1
                cost += Cost_Per_Mile*Distances_D_M[Actual_Routines[i][j],Actual_Routines[i][j+1]]
            end
        elseif length(Actual_Routines[i]) == 1
            cost += Cost_Per_Mile*Distances_D_M[0,Actual_Routines[i][j]]
        end
    end
    push!(Cost_Array,cost) # push the cost of this routine
end
println(Cost_Array)
println("Cost_Arry length: ", length(Cost_Array))

#println(Actual_Routines[4][2])
for k in 2:length(Customers)
    for i in 1:length(Actual_Routines)
        for j in 1:length(Actual_Routines[i])
            if Actual_routines[i][j] == Customers[k]
                push!()
            elseif 


        end
    end
end
