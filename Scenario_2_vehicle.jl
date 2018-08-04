using JuMP, Gurobi

m = Model(solver = GurobiSolver(OutputFlag=0))

Cost_Per_Mile = 2 # cost of gas per mile for Vehicles

Vehicles = [:A :B :C]
Customers = [:1 :2 :3 :4 :5]
Distances_D = Dict(zip(Customers,[3 5 2 1 4]))
Pure_Profit = Dict(zip(Customers,[20 10 15 25 30 ]))

@variable(m, c[Vehicles]>=0) # cost for sending each vehicles
@variable(m, z[Customers], Bin) # 1 if the customer hasn't been visted, otherwise 0
#@variable(m, Total_Cost[Customers]>=0)

#ensure positive profit
@constraint(m, Routine[i in Vehicles],sum(2*Distances_D[j]*z[j] for j in Customers)<= sum(Pure_Profit[j]*z[j] for j in Customers))

@constraint(m, z[1]>=1)
@constraint(m, z[2]>=1)
@constraint(m, z[3]>=1)
@constraint(m, z[4]>=1)
@constraint(m, z[5]>=1)

@objective(m, Min, sum(z[i] for i in Customers))
#Profit : sum(Pure_Profit[i] for i in Customers)
#Total Cost : sum(2*Distances_D[j]*z[j] for j in Customers)
solve(m)
println(getvalue(z[5]))
println("Coverage Scale(5 for full coverage): ", getobjectivevalue(m))
println("Total Cost: ", getvalue(sum(2*Distances_D[j]*z[j] for j in Customers)))
println("Total Cost in detail: ", (sum(2*Distances_D[j]*z[j] for j in Customers)))
println("Pure Profit: ", sum(Pure_Profit[i] for i in Customers))
println("Acutal Profit: ", sum(Pure_Profit[i] for i in Customers)-getvalue(sum(2*Distances_D[j]*z[j] for j in Customers)))
