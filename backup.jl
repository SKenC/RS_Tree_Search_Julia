
function negamax_backup(;node, reward)
    """
    対局ゲーム用のバックアップ。交互に報酬がマイナスになる。
    指定されたノードからルートの子ノードまでの各ノードの情報を報酬を使って更新
    :param tree: 探索木
    :param node_num: 開始ノード
    :reward: 獲得した報酬
    """
    r = reward
    current = node
    while current.parent != []
        current.n += 1
        current.q += r
        r = -1 * r

        current = current.parent
    end
    #ルートのnも更新して、子ノードのucb計算に使う。
    current.n += 1
end
