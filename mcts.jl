include("tree_policy.jl")
include("default_policy.jl")
include("backup.jl")
include("utils.jl")

function mcts(;tree, n, algo_name="UCT")
    """
    モンテカルロ木探索
    Args:
        tree: 探索する木
        n: ロールアウト回数
        ans_path: 答えのパスを表すリスト
    :return:
        predictions: 各ステップでのもっともらしいルート (steps, rollout_num)リスト
    """
    predictions = []
    for i=1:n
        #新たにノードを展開 or 最もいい価値関数を進んだノード
        chosen = tree_policy(tree=tree, algo_name=algo_name)
        #選ばれたノードからランダムに葉まで行って報酬獲得
        reward = default_policy(tree=tree, node=chosen)
        #報酬をchosenからルートノードまで伝播
        #backup(tree=tree, node_num=chosen, reward=reward)
        negamax_backup(node=chosen, reward=reward)

        #現時点でのもっとらしいルートを記録(展開していないところはランダムで)
        push!(predictions, get_prediction(tree=tree, algo_name=algo_name))

    end
    #print("MCTS-END")

    return predictions #get_best_path(tree)
end

function get_prediction(;tree, algo_name)
    """
    学習後に価値関数最大を選んで最も良いと思われる葉を返す
    :param tree:
    :return:
    """
    node = tree.root
    depth = 0
    path = []
    while length(node.children) != 0
        #価値関数に従って最適な子ノードを返す。(同じ値のみならランダムで。)
        #node = best_child(node=node, algo_name=algo_name)
        numbers = [v.n for v in node.children]
        node = node.children[arg_max_rand(numbers)]
        push!(path, node)
    end

    return path
end
