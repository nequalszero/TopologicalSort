require 'set'
require 'byebug'

# input: nodes, which should be a hash where the keys are identifiers and their
#        values are an array of dependencies or nil if it has no dependencies
def topological_sort(hash)
  nodes = {}
  installed = Set.new
  parents = []
  load_order = []

  # O(n * m) time where n is number of nodes and m is number of edges.
  hash.each do |key, dependencies|
    key_node = get_or_make_node(key, nodes)

    if dependencies.nil?
      next
    end

    dependencies.each do |dep|
      dep_node = get_or_make_node(dep, nodes)

      dep_node.children << key_node
      key_node.dependencies << dep_node
    end
  end

  # O(n) time.
  parents = nodes.values.select { |node| node.dependencies.empty? }

  # O(n*m) time
  until parents.empty?
    node = parents.shift
    load_order << node.value

    node.children.each do |child_node|
      child_node.dependencies.delete(node)
      parents << child_node if child_node.dependencies.empty?
    end
  end

  raise ArgumentError, 'Cycle present in input hash' unless load_order.length == nodes.length

  load_order
end

# Helper function for constructing the graph.  Creates and returns a new GraphNode if
#   one does not already exist for the given key.  Else returns the existing node.
def get_or_make_node(key, nodes)
  unless nodes.has_key?(key)
    nodes[key] = GraphNode.new(key)
  end

  nodes[key]
end

class GraphNode
  attr_accessor :value, :dependencies, :children

  def initialize(value)
    @value = value
    @dependencies = Set.new
    @children = Set.new
  end
end


def test
  hash = {
    a: [:b, :c],
    b: [:b1, :b2],
    b2: [:b2_1, :b2_2, :b2_3],
    c: [:c1]
  }

  p topological_sort(hash)
end

# test
