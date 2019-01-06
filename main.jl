include("modules.jl")
using .MODULE
using Statistics

function main(;d=5, bf=2, data_size=1, rollout_num=500, draw=false, algo_name="UCT", playout_num=0)

    print("Build P-game Tree...")
    data_set = get_data_set(d=d, bf=bf, data_size=data_size, tree_name="kocsis")
    #minimax = minimax_algo_nx(tree=data_set[1])
    # println(get_opt_path(minimax=minimax))

    predictions = []
    @progress for i=1:data_size
        push!(predictions, mcts(tree=data_set[i],
                                n=rollout_num,
                                algo_name=algo_name,
                                playout_num=playout_num))
    end

    if draw
        for i=1:data_size
            print_tree(tree=data_set[i], data_name=algo_name)
        end
    end

    correct_rates = []
    for i=1:data_size
        push!(correct_rates,
                calc_correct_rate(predictions=predictions[i],
                                    tree=data_set[i],
                                    draw=draw))
    end

    rates = hcat(correct_rates...)'

    means = [mean(rates[:, i]) for i=1:size(rates)[2]]

    return means

end

@time means = main( d=4,
                    bf=2,
                    data_size=1,
                    rollout_num=1000,
                    algo_name="UCT",
                    draw=true,
                    playout_num=1)

using Plots
plot(means)
