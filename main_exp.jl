include("main.jl")

d = 16
rollout_num = 5000
sample_num = 1

means = []
names = []
for r in [1., 0.9, 0.8]
    println("EXPERIMENT r=$r")
    @time mean = main( d=d,
                        bf=2,
                        data_size=100,
                        rollout_num=rollout_num,
                        algo_name="RS",
                        draw=false,
                        sample_num=sample_num,
                        r=r);
    push!(names, "R$r")
    push!(means, mean)
    
end

means = hcat(means...)

using CSV
using DataFrames
include("data_save.jl")

save_csv(data=means, file_name="./exp_data/RS_16d_10000-1ALL.csv", labels=names, gap=1)

#df = DataFrame(means, names)
#df |> CSV.write("./exp_data/RS_3d_10000-1ALL.csv",delim=',')