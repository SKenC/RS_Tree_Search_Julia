include("tree.jl")
include("utils.jl")

#networkxを使ってminimaxtreeを作る
function minimax_algo_nx(;tree)
    root, _, leaf_list = build_tree(tree.d, tree.bf)
    minimax = Tree(root, tree.d, tree.bf, tree.node_num, leaf_list)

    for i=1:length(leaf_list)
        leaf_list[i].data["value"] = tree.leaf_list[i].data["value"]
    end

    #minimax_treeを作る
    rev = 1.
    layer = leaf_list
    while length(layer) > 1
        new_layer = []
        for i=1:tree.bf:length(layer)
            values = [layer[i+j].data["value"] for j=0:tree.bf-1]
            layer[i].parent.data["value"] = values[arg_max_rand(values * rev)]
            push!(new_layer, layer[i].parent)
        end
        layer = new_layer
        rev *= -1.
    end

    #values = [c.data["value"] for c in root.children]
    #root.data["value"] = values[arg_max_rand(values * rev)]

    return minimax
end

function get_opt_path(;minimax)
    node = minimax.root
    best_val = node.data["value"]
    path = []
    while length(node.children) != 0
        values = [c.data["value"] for c in node.children]
        indices = findall(x->(x==best_val), values)
        node = node.children[indices[1]]
        push!(path, node)
    end

    return path
end

function calc_correct_rate(;predictions, tree, draw=false)
    """各treeから最適なpathを求め、stepごとの正解率を返す
    Args:
        predictions: 各stepでの予測したpath (steps, depth)のVector
        tree: 実験データの木
    Returns:
        correct_rate: 各ステップでの正解率
    """
    minimax = minimax_algo_nx(tree=tree)
    opt_path = get_opt_path(minimax=minimax)
    if draw
        print_tree(tree=minimax, data_name="value")
        opts = [opt_path[i].id for i=1:length(opt_path)]
        predicts = [predictions[end][i].id for i=1:length(predictions[end])]
        println("opt=$opts,prediction=$predicts")
    end

    correct_rate = []
    for i=1:length(predictions)
        push!(correct_rate, accuracy(result=predictions[i], target=opt_path))
    end

    return correct_rate
end
