module MODULE
    include("game_tree.jl")
    include("mcts.jl")
    include("utils.jl")
    include("minimax.jl")
    export
        get_data_set,
        mcts,
        calc_correct_rate,
        calc_correct_rate2,
        print_tree

end
