using JuMP, Gurobi, NamedArrays

Routine = [:1 :2 :3 :4 :5 :6 :7 :8 :9]
# We have k vehicles
Vehicle_Max_Capacity = 30 # max capacity of each Truck
#---------------------------------------------------------------
# CALCULATE THE COST
Cost_Per_Mile = 2 # cost of gas per mile for Vehicles

#Profit/unit = 20 for everything. SO --> Min Cost == Max Profit
Customers = [1,2,3,4,5,6] # 1 is resturant. Total Customers == 5.
Customers_Request = Dict(zip(Customers, [0 11 9 8 12 14]))
Pure_Profit = Dict(zip(Customers,[0 220 180 160 240 280]))

Distances_D_M = NamedArray([0 18 14 16 12 19
                            18 0 18 30 26 28
                            14 18 0 20 22 21
                            16 30 20 0 22 21
                            12 26 22 22 0 22
                            19 28 21 21 22 0],(Customers,Customers),("Customers","Customers"))
println("[1,1] is restaurant")
println(Distances_D_M)

@variable(m, actual_profit[Customers])
@variable(m, cost[Customers]>=0)
# Total cost: (Cost_Per_Mile*Distances_D_M[i,:] for i in Customers)
# Pure profit: (Pure_Profit[i])
# Acutal profit = Pure profit - Total cost
#-------------------------------------------------------
#SOLVE ROUTINE PROBLEM
m = Model(solver = GurobiSolver(OutputFlag=0))

@variable(m, z[Routine], Bin) # 1 if the customer is been visited, otherwise 0
@variable(m, routine[Routine])

# Set up routine: (Some routines are not available due to the Vehicle_Max_Capacity)
# z[1] = 1-2-3-4
# z[2] = 1-2-4
# z[3] = 1-2-5
# z[4] = 1-2-6
# z[5] = 1-3-4-5
# z[6] = 1-3-4
# z[7] = 1-4-5
# z[8] = 1-4-6
# z[9] = 1-5-6

@constraint(m, z[1]+z[2]+z[3]+z[4] >= 1) # 2 is covered
@constraint(m, z[1]+z[5]+z[6] >= 1) # 3 is covered
@constraint(m, z[2]+z[5]+z[6]+z[7]+z[8] >= 1) # 4 is covered
@constraint(m, z[3]+z[5]+z[7]+z[9] >= 1) # 5 is covered
@constraint(m, z[4]+z[8]+z[9] >= 1) # 6 is covered

@objective(m, Min, sum(z[j] for j in Routine))

solve(m)
println(getvalue(z))
# thoughts: constraint -> let z[i]*(their associate actual profit) >= (the biggest profit)
# so, we can get the max profit while ensuring Customers are covered

#println(actual_profit[i]for i in Customers)
