using JuMP, Gurobi, NamedArrays, Combinatorics

m = Model(solver = GurobiSolver(OutputFlag=0))

#Routine = [:1 :2 :3 :4 :5 :6 :7 :8 :9]

Routines = Array[]
Routines_1 =
println(Routines)

# We have k vehicles
Vehicle_Max_Capacity = 30 # max capacity of each Truck
#---------------------------------------------------------------
# COST/PROFIT Informtaion
Cost_Per_Mile = 2 # cost of gas per mile for Vehicles

#Profit/unit = 20 for everything. SO --> Min Cost == Max Profit
Customers = [1,2,3,4,5,6] # 1 is resturant. Total Customers == 5.
Customers_Request = Dict(zip(Customers, [0 11 9 8 12 14]))
Pure_Profit = Dict(zip(Customers,[0 220 180 160 240 280]))
###########
Routines = Dict()

for i in Customers
    for j in Routine
Routines[] = Customers_Request[i] for i in Customers <= Vehicle_Max_Capacity
end
#################################
Distances_D_M = NamedArray([0 18 14 16 12 19
                            18 0 18 30 26 28
                            14 18 0 20 22 21
                            16 30 20 0 22 21
                            12 26 22 22 0 22
                            19 28 21 21 22 0],(Customers,Customers),("Customers","Customers"))
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
@variable(m, z[Customers], Bin) # 1 if the customer is been visited, otherwise 0
@variable(m, y[Routine]>=0)
@variable(m, x[])

# Set up routine: (Some routines are not available due to the Vehicle_Max_Capacity)
# x[1] = 1-2-3-4
# x[2] = 1-2-4
# x[3] = 1-2-5
# x[4] = 1-2-6
# x[5] = 1-3-4-5
# x[6] = 1-3-4
# x[7] = 1-4-5
# x[8] = 1-4-6
# x[9] = 1-5-6
#################################

################################
for y in Routine
    @constraint(m, x[Routine], )
end
@constraint(m, sum(x[Routine])>=1 )


# @constraint(m, y[1]+y[2]+y[3]+y[4] >= 1) # 2 is covered
# @constraint(m, y[1]+y[5]+y[6] >= 1) # 3 is covered
# @constraint(m, y[2]+y[5]+z[6]+z[7]+z[8] >= 1) # 4 is covered
# @constraint(m, z[3]+z[5]+z[7]+z[9] >= 1) # 5 is covered
# @constraint(m, z[4]+z[8]+z[9] >= 1) # 6 is covered

@objective(m, Min, sum(z[j] for j in Routine))

solve(m)
println(getvalue(z))
# thoughts: constraint -> let z[i]*(their associate actual profit) >= (the biggest profit)
# so, we can get the max profit while ensuring Customers are covered
