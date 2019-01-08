function default_policy(;tree, node)
    """
    指定されたノードからランダムに行動して報酬を返す
    :param tree: 探索木
    :param node_num: 開始ノード
    :return: 最終的に得た報酬
    """
    current = node
    while length(current.children) != 0
        current = current.children[rand(1:length(current.children))]
    end

    return current.data["reward"]

end

function default_policy_fast(;tree, i::Int64, j::Int64)
    """
    指定されたノードからランダムに行動して報酬を返す
    :param tree: 探索木
    :param i: 深さjで番目か
    :param j: 深さ
    :return: 最終的に得た報酬
    """

    part_len = length(tree.leaf_list)/(2^j)
    part_len = trunc(Int, part_len)
    #print("$part_len,$i,$j")
    #nodeの子孫の葉
    leaves = tree.leaf_list[part_len*(i-1) + 1 : part_len*i]

    return leaves[rand(1:length(leaves))].data["reward"]

end
