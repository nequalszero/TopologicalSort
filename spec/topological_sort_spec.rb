require 'rspec'
require 'topological_sort.rb'

describe 'toplogical_sort' do
  it 'handles a simple example' do
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

    result = topological_sort(hash)

    expect(result.length).to eq(7)
    expect(result).to include(:a, :b, :c, :b1, :b2, :b2_1, :c1)
    expect(result.index(:a)).to eq(6)
    expect(result.index(:b)).to be > result.index(:b1)
    expect(result.index(:b)).to be > result.index(:b2)
    expect(result.index(:b2)).to be > result.index(:b2_1)
    expect(result.index(:c)).to be > result.index(:c1)
  end

  it 'handles a simple example with nil values' do
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
      c: [:c1],
      b1: nil,
      c1: nil,
      b2_1: nil
    }

    result = topological_sort(hash)

    expect(result.length).to eq(7)
    expect(result).to include(:a, :b, :c, :b1, :b2, :b2_1, :c1)
    expect(result.index(:a)).to eq(6)
    expect(result.index(:b)).to be > result.index(:b1)
    expect(result.index(:b)).to be > result.index(:b2)
    expect(result.index(:b2)).to be > result.index(:b2_1)
    expect(result.index(:c)).to be > result.index(:c1)
  end

  it 'handles a more complex example' do
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

    result = topological_sort(hash)

    expect(result.length).to eq(17)
    expect(result).to include(:a, :b, :c, :d, :f, :g, :j, :k, :l, :m, :n, :p, :s, :t, :w, :y, :z)

    index_map = {}
    result.each_with_index do |letter, idx|
      index_map[letter] = idx
    end

    # 1
    expect(index_map[:a]).to be > index_map[:t]

    # 2
    expect(index_map[:c]).to be > index_map[:k]
    expect(index_map[:c]).to be > index_map[:b]
    expect(index_map[:c]).to be > index_map[:l]

    # 3
    expect(index_map[:k]).to be > index_map[:t]

    # 4
    expect(index_map[:b]).to be > index_map[:t]
    expect(index_map[:b]).to be > index_map[:j]

    # 5
    expect(index_map[:l]).to be > index_map[:j]
    expect(index_map[:l]).to be > index_map[:p]

    # 6
    expect(index_map[:t]).to be > index_map[:g]
    expect(index_map[:t]).to be > index_map[:s]

    # 7
    expect(index_map[:j]).to be > index_map[:s]

    # 8
    expect(index_map[:p]).to be > index_map[:m]
    expect(index_map[:p]).to be > index_map[:n]

    # 9
    expect(index_map[:g]).to be > index_map[:f]
    expect(index_map[:g]).to be > index_map[:d]

    # 10
    expect(index_map[:s]).to be > index_map[:w]

    # 11
    expect(index_map[:m]).to be > index_map[:w]

    # 12
    expect(index_map[:n]).to be > index_map[:y]
    expect(index_map[:n]).to be > index_map[:z]

    # 13
    expect(index_map[:d]).to be > index_map[:y]

    # 14
    expect(index_map[:w]).to be > index_map[:y]
  end

  it 'throws an ArgumentError if a cycle is present in the input' do
    hash = {
      a: [:b],
      b: [:a]
    }

    expect { topological_sort(hash) }.to raise_error(ArgumentError, 'Cycle present in input hash')
  end
end
