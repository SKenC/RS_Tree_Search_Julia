function accuracy(;result, target, type_name="reward")
    """
    正解率として、二つのリストの一致割合を返す
    :return: 正解率
    """

    if type_name == "first"
        if result[1].id == target[1].id
            return 1.
        else
            return 0.
        end
    elseif type_name == "reward"
        return result[end].data["reward"]

    elseif type_name == "all"
        correct = 0
        for i=1:length(result)
            if result[i].id == target[i].id
                correct += 1
            end
        end
        return correct / length(result)
    end
end

function arg_max_rand(values::Vector)
    max = typemin(eltype(values))  #minimum value.
    max_indices = Vector{Int}()

    #get maximum values and those indices.
    for i=1:length(values)
        if values[i] > max
            max = values[i]
            empty!(max_indices)
            push!(max_indices, i)
        elseif values[i] == max
            push!(max_indices, i)
        end
    end

    max_num = length(max_indices)

    if max_num == 1
        #return maximum index
        return max_indices[1]
    else
        #retrun random index of maximum values
        return max_indices[rand(1:max_num)]
    end
end

function data_print(node, data_name)
    if data_name == "n"
        print("$(node.n)")
    elseif data_name == "id"
        print("$(node.id)")
    elseif data_name == "q"
        print("$(node.q)")
    elseif data_name == "ij"
        print("[$(node.i),$(node.j)]")
    else
        if haskey(node.data, data_name)
            print("$(node.data[data_name])")
        else
            print("-")
        end
    end
end

function print_tree(;tree, data_name="n")

    children = tree.root.children
    for _=1:tree.bf^(tree.d-1)+1
        print("  ")
    end
    data_print(tree.root, data_name)
    println("")

    for i=1:tree.d
        for _=1:tree.bf^(tree.d-i)
            print("  ")
        end
        for j=1:length(children)
            data_print(children[j], data_name)
            for _=1:tree.d-i+1
                print("  ")
            end
            if j%tree.bf == 0
                for _=1:tree.d-i
                    print("  ")
                end
            end
        end
        println("")
        new_children = []
        for j=1:length(children)
            new_children = vcat(new_children, children[j].children)
        end

        children = new_children
    end
end
