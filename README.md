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
