"""
    abstract type IteratorAlgorithm

`IteratorAlgorithm` is an abstract type which specifies using depth-first traversal [`DFSIterator`](@ref) or breadth-first traversal [`BFSIterator`](@ref).
"""
abstract type IteratorAlgorithm end


"""
    struct DFSIterator <: IteratorAlgorithm

`DFS` is a struct which specifies using depth-first traversal to iterate through a graph. A source node must be supplied to construct this iterator as `DFS(g::AbstractGraph, source::Int)`.

`DFSIterator` is a struct which specifies using depth-first traversal to iterate through a graph. A source node must be supplied to construct this iterator as `DFSIterator(g::AbstractGraph, source::Int)`.

# Examples
```julia-repl
julia> g = smallgraph(:house)
{5, 6} undirected simple Int64 graph

julia> for node in DFSIterator(g, 1)
           display(node)
       end
1
2
4
3
5
```
"""
struct DFSIterator <: IteratorAlgorithm
    graph::AbstractGraph
    source::Int
end


"""
    struct BFSIterator <: IteratorAlgorithm

`BFS` is a struct which specifies using breadth-first traversal to iterate through a graph. A source node must be supplied to construct this iterator as `BFS(g::AbstractGraph, source::Int)`.

# Examples
```julia-repl
julia> g = smallgraph(:house)
{5, 6} undirected simple Int64 graph

julia> for node in BFSIterator(g, 1)
           display(node)
       end
1
2
3
4
5
```
"""
struct BFSIterator <: IteratorAlgorithm
    graph::AbstractGraph
    source::Int
end


"""
    mutable struct GraphIteratorState

`GraphIteratorState` is a struct to hold the current state of iteration which is need for Julia's Base.iterate() function.
"""
mutable struct GraphIteratorState
    visited::BitArray
    queue::Vector{Int}
end


"""
    Base.iterate(t::IteratorAlgorithm)

First iteration to visit each node.
"""
function Base.iterate(t::IteratorAlgorithm)
    visited = falses(nv(t.graph))
    visited[t.source] = true
    state = GraphIteratorState(visited, [t.source])
    return (t.source, state)
end


"""
    Base.iterate(t::DFSIterator, state::GraphIteratorState)

Iterator to visit each node in a depth-first manner.
"""
function Base.iterate(t::DFSIterator, state::GraphIteratorState)
    while !isempty(state.queue)
        for node in outneighbors(t.graph, state.queue[end])
            if !state.visited[node]
                push!(state.queue, node)
                state.visited[node] = true
                return (node, state)
            end
        end
        pop!(state.queue)
    end
    return nothing
end

"""
    Base.iterate(t::BFSIterator, state::GraphIteratorState)

Iterator to visit each node in a breadth-first manner.
"""
function Base.iterate(t::BFSIterator, state::GraphIteratorState)
    while !isempty(state.queue)
        for node in outneighbors(t.graph, state.queue[1])
            if !state.visited[node]
                push!(state.queue, node)
                state.visited[node] = true
                return (node, state)
            end
        end
        popfirst!(state.queue)
    end
    return nothing
end
