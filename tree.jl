mutable struct Node
  #move::Move                    # move from parent to this node OR "root" move
  id::Int64
  parent
  children::Vector
  expanded::Bool

  n::Int64
  q::Float64
  data::Dict{String,Float64}
  function Node(id::Int64, parent)
      new(id,
          parent,
          [],
          false,
          1,
          0.,
          Dict{String,Float64}())
  end
end

mutable struct Tree
  root::Node
  d::Int64
  bf::Int64
  node_num::Int64
  leaf_list::Vector
end

function add_node(; id::Int64, parent::Node)
  node = Node(id, parent)
  #push!(parent.untried_moves, node)
  push!(parent.children, node)
  return node
end

function build_tree(d::Int64, bf::Int64)

  node_id = 0
  root = Node(0, [])
  parents = [root]
  for i=1:d
    new_parents = []
    for j=1:length(parents)
      for _=1:bf
        node_id += 1
        p = add_node(id=node_id, parent=parents[j])
        push!(new_parents, p)
      end
    end
    parents = new_parents
  end

  return root, node_id+1, parents

end

function print_tree_simple(tree::Tree)
  parents = [tree.root]
  #children = node.children
  for depth=1:tree.d
    for i=1:(tree.d-depth)
      print(" ")
    end

    new_parents = []
    for i=1:length(parents)
      for c in parents[i].children
        print("$(c.id)")
        push!(new_parents, c)
        for i=1:(tree.d-depth+1)
          print("  ")
        end
      end
    end
    parents = new_parents
    println("")
  end
  #print("children=$(root.children)")
end
