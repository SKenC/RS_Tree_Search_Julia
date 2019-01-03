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
