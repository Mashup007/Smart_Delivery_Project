using JuMP, Gurobi, NamedArrays

m = Model(solver = GurobiSolver(OutputFlag=0))

Routine = [:1 :2 :3 :4 :5 :6 ]
# We have k vehicles
Vehicle_Max_Capacity = 30 # max capacity of each Truck
#---------------------------------------------------------------
# COST/PROFIT Informtaion
Cost_Per_Mile = 2 # cost of gas per mile for Vehicles

#Profit/unit = 20 for everything. SO --> Min Cost == Max Profit
Customers = [1,2,3,4] # 1 is resturant. Total Customers == 5.
Customers_Request = Dict(zip(Customers, [0 11 9 8 12 14]))
Pure_Profit = Dict(zip(Customers,[0 220 180 160 240 280]))

# Distances_D_M = NamedArray([0 18 14 16 12 19
#                             18 0 18 30 26 28
#                             14 18 0 20 22 21
#                             16 30 20 0 22 21
#                             12 26 22 22 0 22
#                             19 28 21 21 22 0],(Customers,Customers),("Customers","Customers"))
println("[1,1] is restaurant")
println(Distances_D_M)
println("***Rows and Columns represent the distance between Customers [reminder: 1,1 is restaurant]")

@variable(m, actual_profit[Customers])
@variable(m, cost[Customers]>=0)
# Total cost: (Cost_Per_Mile*Distances_D_M[i,:] for i in Customers)
# Pure profit: (Pure_Profit[i])
# Acutal profit = Pure profit - Total cost
#-------------------------------------------------------
#SOLVE ROUTINE PROBLEM
@variable(m, z[Routine], Bin) # 1 if the customer is been visited, otherwise 0

# Set up routine: (Some routines are not available due to the Vehicle_Max_Capacity)
# z[1] = 1-2-3-4
# z[2] = 1-2-4
# z[3] = 1-2-5
# z[4] = 1-2-6   0 - 1 -5
# z[5] = 1-3-4-5 0 - 2-3-4
# z[6] = 1-3-4
# z[7] = 1-4-5
# z[8] = 1-4-6
# z[9] = 1-5-6

@constraint(m, z[1]+z[2]+z[4]+z[5] >= 1) # 2 is covered
@constraint(m, z[1]+z[3]+z[4]+z[6] >= 1) # 3 is covered
@constraint(m, z[2]+z[3]+z[5]+z[6] >= 1) # 4 is covered


@objective(m, Min, sum(z[j] for j in Routine))

solve(m)
println(getvalue(z))
# thoughts: constraint -> let z[i]*(their associate actual profit) >= (the biggest profit)
# so, we can get the max profit while ensuring Customers are covered
