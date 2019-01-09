include("modules.jl")
using .MODULE
using Statistics

function main(;d=5, bf=2, data_size=1, rollout_num=500, draw=false, algo_name="UCT", sample_num=1, r=0.9)

    print("Build P-game Tree...")
    data_set = get_data_set(d=d, bf=bf, data_size=data_size, tree_name="kocsis", draw=draw)
    #minimax = minimax_algo_nx(tree=data_set[1])
    # println(get_opt_path(minimax=minimax))

    println("MCTS")
    predictions = []
    for i=1:data_size
        print("data$i-")
        push!(predictions, mcts(tree=data_set[i],
                                n=rollout_num,
                                algo_name=algo_name,
                                sample_num=sample_num,
                                r=r))
    end

    if draw
        for i=1:data_size
            println("q tree")
            print_tree(tree=data_set[i], data_name="q")
            # println("ID tree")
            # print_tree(tree=data_set[i], data_name="id")
        end
    end

    correct_rates = []
    for i=1:data_size
        push!(correct_rates,
                calc_correct_rate(predictions=predictions[i],
                                    tree=data_set[i],
                                    draw=draw,
                                    type_name="first"))
    end

    rates = hcat(correct_rates...)'

    means = [mean(rates[:, i]) for i=1:size(rates)[2]]

    return means

end

"""
@time means = main( d=7,
                    bf=2,
                    data_size=100,
                    rollout_num=1000,
                    algo_name="RS",
                    draw=false,
                    sample_num=1)

@time uctmeans = main( d=7,
                    bf=2,
                    data_size=100,
                    rollout_num=1000,
                    algo_name="UCT",
                    draw=false,
                    sample_num=1)

graph = hcat(means, uctmeans)
using Plots
plot(means)
plot(graph)
"""
