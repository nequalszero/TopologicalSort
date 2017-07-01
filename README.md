# Topological Sorting Implementation
## Setup
Run `bundle install`.

## Testing
Run `bundle exec rspec` to run `spec/topological_sort_spec.rb` on the `topological_sort` function found in `lib/topological_sort`.

## Description
This is a `ruby` implementation of a topological sorting algorithm.

The `topological_sort` function accepts a hash of form:
```ruby
  {
    id_1: [:dependency_id_1, :dependency_id_2, ...],
    id_2: [:dependency_id_3, :dependency_id_4, ...],
    ...
  }
```
where the keys are some of identifiers and the values are either nil or an array of identifiers.  Essentially a hash representing the outgoing edges for each node.

The function creates a `GraphNode` out of each identifier in the input hash, each having a `value`, `children`, and `dependencies` attribute.  The `children` and `dependencies` attributes are sets.  The main logic of the function involves initially populating a `parents` array of GraphNodes that have no dependencies.  Until `parents` is empty, a `GraphNode` is shifted from the array and its `value` appended to a `load_order` array.  The `GraphNode` is then "removed" from the graph by iterating over its `children`, and removing itself from its children's `dependencies`. Its `children` are added to the `parents` array if their `dependencies` sets are empty.

If the `load_order` array length does not equal the number of `nodes`, a cycle is present, and an `ArgumentError` is raised.

The algorithm's space and time complexity are `O(n*m)`, where n is the number of nodes and m is the number of edges.

## Examples (also found in spec file)
Example 1: Simple case:
```ruby
  #            a
  #          /   \
  #        b      c
  #      /  \      \
  #    b1   b2      c1
  #        /
  #     b2_1

  hash = {
    a: [:b, :c],
    b: [:b1, :b2],
    b2: [:b2_1],
    c: [:c1]
  }

  result = topological_sort(hash) # returns [:b1, :b2_1, :c1, :b2, :c, :b, :a]
```

Example 2: More complex case:
```ruby
  #   a          c
  #    \      / |  \
  #     \   k  b    l
  #      \ | /  \ /  \
  #        t     j    p
  #      /  \  /    /  \
  #     g    s     m    n
  #   /  \    \   /    / \
  #  f    d     w     /   z
  #        \_____\   /
  #               \ /
  #                y

  hash = {
    a: [:t],
    c: [:k, :b, :l],
    k: [:t],
    b: [:t, :j],
    l: [:j, :p],
    t: [:g, :s],
    j: [:s],
    s: [:w],
    p: [:m, :n],
    m: [:w],
    n: [:y, :z],
    g: [:d, :f],
    d: [:y],
    w: [:y]
  }

  # returns [:y, :z, :f, :d, :w, :n, :g, :s, :m, :t, :j, :p, :a, :k, :b, :l, :c]
  result = topological_sort(hash)
```

Example 3: When a cycle exists:
```ruby
  #     ____
  #   /     \
  #  a      b
  #   \____/

  hash = {
    a: [:b],
    b: [:a]
  }

  result = topological_sort(hash) # throws an ArgumentError 'Cycle present in input hash'
```
