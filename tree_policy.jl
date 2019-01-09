include("utils.jl")
include("value_functions.jl")

function tree_policy(;tree, algo_name, sample_num::Int64, r=0.9)
    node_num = 0
    depth = 0
    node = tree.root
    while  length(node.children) != 0
        #全ての子が展開されていたら最も良い子を、そうでなけば未展開な子をランダムで
        children = get_nodes(tree, node, false)
        if length(children) == 0
            #print("non-expanded={}".format(children))
            if (depth%2) == 0
                node = best_child(node=node, algo_name=algo_name, negamax=false, r=r)
            else
                node = best_child(node=node, algo_name=algo_name, negamax=true, r=r)
            end
            #node_num = best_child_negamax(tree=tree, node_num=node_num, depth=depth)
        else
            if node.n > sample_num || node.id == 0
                return expand(children)
            else
                return node
            end
        end

        depth += 1
    end

    return node
end

function expand(untried)
    """
    まだ試していない行動をして新たなノードを展開(すでに木があるのでexpandedにtrueを)
    :return: 新たに展開した子ノード番号
    """

    new_node = untried[rand(1:length(untried))]
    new_node.expanded = true

    return new_node
end

function best_child(;node, algo_name::String, negamax=false, r=0.9)
    """
    最も高い価値関数をもつ子ノードの番号を返す
    """
    # 展開された子ノードリスト
    children = node.children #get_nodes(tree, node , tried=true)

    #展開された子ノードのucbを全て計算してリストに
    if algo_name == "UCT"
        values = [ucb(n_ij=c.n, n_i=c.parent.n, q=c.q) for c in children]
    elseif algo_name == "RS"
        values = [rs(n_ij=c.n, q=c.q, r=r) for c in children]
    else
        print("Algorithm name error.")
    end

    if negamax
        values = values * -1
    end

    for i=1:length(children)
        children[i].data[algo_name] = values[i]
    end

    # 最大値の添え字(複数なら最大値のうちランダムで)
    max_idx = arg_max_rand(values)

    return children[max_idx]
end

function get_nodes(tree, node, tried)
    """
    展開された or されていない 子ノードをリストで返す
    :param tree: 木
    :param node_num: 親ノード番号
    :tried: (true)展開されたもの、(false)されていないものを返す
    """
    if tried
        return [child for child in node.children if child.expanded]
    else
        return [child for child in node.children if child.expanded == false]
    end
end
