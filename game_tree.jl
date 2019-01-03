include("tree.jl")

function get_data_set(;d::Int64, bf=Int64, data_size::Int64, tree_name="kocsis")
    tree_list = Vector{}()

    if tree_name == "kocsis"
        for i=1:data_size
            push!(tree_list, build_kocsis_tree(d=d, bf=bf))
        end
    elseif tree_name == "oyo"
        for i=1:data_size
            push!(tree_list, build_oyo_tree(d=d, bf=bf))
        end
    end

    return tree_list
end

function build_oyo_tree(;d::Int64, bf::Int64, probability=[0.8, 0.6])
    """ 大用さんの論文にある抽象木を作成
    :param d: 深さ
    :param bf: 子ノードの数
    :return: 深さd,子ノードbfの平衡木
    """
    #平衡木を作成
    root, node_num, leaf_list = build_tree(d, bf)
    tree = Tree(root, d, bf, node_num, leaf_list)
    node_num = tree.node_num

    #@show leaf_list
    #葉のvalue属性に乱数を設定
    #leaf_st = node_num - bf^d  #葉ノードのスタート
    for i=1:length(leaf_list)
        for j=1:bf
            if rand() < probability[j]
                value = rand(0:127)
            else
                value = rand(128:255)
            end

            tree.leaf_list[i].data["value"] = value

            if value >= 200
                tree.leaf_list[i].data["reward"] = 1
            else
                tree.leaf_list[i].data["reward"] = 0
            end
        end

    end

    #print(tree.nodes(data=True))

    return tree
end

#tree = build_oyo_tree(d=2, bf=2)
#print_tree(tree)
function build_kocsis_tree(;d::Int64, bf::Int64)
    """ Kocsisの論文にある抽象木を作成
    :param d: 深さ
    :param bf: 子ノードの数
    :return: 深さd,子ノードbfの平衡木
    """
    root, node_num, leaf_list = build_tree(d, bf)
    tree = Tree(root, d, bf, node_num, leaf_list)
    node_num = tree.node_num

    children = []
    depth = 0
    parents = [root]
    tree.root.data["value"] = 0

    r = rand(0:127, node_num)
    for depth=0:d
        #print("$depth-->")
        for p in parents
            for c in p.children
                if (depth%2) == 0
                    #r = rand(0:127)
                    c.data["value"] = p.data["value"] + r[c.id]#+ rand(0:127) #初手はMAXが
                else
                    #r = rand(-127:0)
                    c.data["value"] = p.data["value"] - r[c.id]#+ rand(-127:0)
                end
                #children = vcat(children, p.children)
                push!(children, c)
            end
        end

        parents = children
        children = []

        #depth += 1
    end

    for leaf in leaf_list
        if leaf.data["value"] > 0
            leaf.data["reward"] = 1
        else
            leaf.data["reward"] = 0
        end
    end

    #print(tree.nodes(data=True))

    return tree
end

# @time tree = build_kocsis_tree(d=8, bf=2)
# include("utils.jl")
# print_tree(tree=tree, data_name="value")

# def build_gaussian_tree(self, d, bf):
#     """ 正規分布に従った報酬設定
#     :param d: 深さ
#     :param bf: 子ノードの数
#     :return: 深さd,子ノードbfの平衡木
#     """
#     tree = nx.balanced_tree(r=bf, h=d, create_using=nx.DiGraph())
#     node_num = nx.number_of_nodes(tree)
#
#     #葉のvalue属性に乱数を設定
#     leaf_st = node_num - bf**d  #葉ノードのスタート
#     for i in range(bf**d):
#         #value = np.random.randn()
#         value = np.random.normal(0., 1.)
#
#         tree.nodes[leaf_st + i]["value"] = value
#
#         if value >= 0.:
#             tree.nodes[leaf_st + i]["reward"] = 1
#         else:
#             tree.nodes[leaf_st + i]["reward"] = 0
#
#     self.add_flags(tree, leaf_st)
#
#     #print(tree.nodes(data=True))
#
#     return tree
