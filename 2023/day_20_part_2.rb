# frozen_string_literal: true

require "prime"

Sig = Data.define(:from, :to, :value)

module Enumerable
  # Find the start and length of a cycle using floyd
  def find_cycle_floyd
    hare_enum = to_enum
    tortoise_enum = to_enum
    hare = nil
    return nil unless loop do
      tortoise = tortoise_enum.next
      hare_enum.next
      hare = hare_enum.next
      break true if hare == tortoise
    end

    i = 0
    tortoise_enum = to_enum
    tortoise = nil
    until tortoise == hare
      hare = hare_enum.next
      tortoise = tortoise_enum.next
      i += 1
    end

    len = 1
    hare = tortoise_enum.next
    until tortoise == hare
      hare = tortoise_enum.next
      len += 1
    end

    [i - 1, len]
  rescue StopIteration
    nil
  end
end

class Mod
  attr_accessor :name, :connections
  attr_writer :outputs

  @@modules = {}

  def self.modules
    @@modules
  end

  def self.[](name)
    @@modules[name]
  end

  def initialize(name:, outputs: [])
    @name = name
    @outputs = outputs
    @connections = []
    outputs.each do |n|
      @@modules[n] ||= Output.new(name: n)
    end
  end

  def connect(mod)
    @connections << mod
  end

  def outputs
    @outputs.map do |n|
      if block_given?
        yield @@modules[n]
      else
        @@modules[n]
      end
    end
  end

  def reset!; end
end

class Button < Mod
  def call(*)
    outputs { Sig.new(self, _1, false) }
  end

  def inspect
    "#<#{name} #{@connections.map(&:name).join(':')}>"
  end
end

class Output < Mod
  def call(*)
    []
  end

  def inspect
    "#<#{name} #{@connections.map(&:name).join(':')}>"
  end
end

class Broadcast < Mod
  def call(value, _)
    outputs { Sig.new(self, _1, value) }
  end

  def inspect
    "#<#{name} #{@connections.map(&:name).join(':')}>"
  end
end

class FlipFlop < Mod
  attr_accessor :on

  def initialize(...)
    super
    @on = false
  end

  def call(value, _)
    return [] if value

    @on = !@on
    outputs { Sig.new(self, _1, @on) }
  end

  def inspect
    "#<%#{name} #{@on} #{@connections.map(&:name).join(':')}>"
  end

  def reset
    @on = false
  end
end

class Conjunction < Mod
  attr_accessor :state

  def initialize(...)
    super
    @state = {}
  end

  def connect(mod)
    super
    @state[mod] = false
  end

  def call(value, mod)
    @state[mod] = value
    outputs { Sig.new(self, _1, !@state.values.all?) }
  end

  def inspect
    "#<&#{name} #{@state.map { "#{_1.name}=#{_2}" }} #{@connections.map(&:name).join(':')}>"
  end

  def reset
    @state.transform_values { false }
  end
end

ARGF.each_line.map(&:chomp).map do |line|
  type, name, outputs = /^([%&])?(\w+) -> (.*)$/.match(line).captures

  Mod.modules[name] = case type
                      when "%"
                        FlipFlop.new(name:, outputs: outputs.split(", "))
                      when "&"
                        Conjunction.new(name:, outputs: outputs.split(", "))
                      else
                        Broadcast.new(name:, outputs: outputs.split(", "))
                      end
end

Mod.modules["output"] = Output.new(name: "output")
Mod.modules["button"] = Button.new(name: "button", outputs: %w[broadcaster])

Mod.modules.each_value do |mod|
  mod.outputs do |out|
    out.connect mod
  end
end

def to_graphviz
  Mod.modules.values.map do |m|
    m.outputs.flat_map do |o|
      shape = m.is_a?(Conjunction) ? "box" : "oval"
      [
        "#{m.name} [shape=#{shape}]",
        "#{m.name} -> #{o.name}"
      ]
    end
  end.join("\n")
end

def debug(sig)
  "#{sig.from.name} -#{sig.value ? 'high' : 'low'}-> #{sig.to.name}"
end

def press
  signals = [Sig.new(nil, Mod["button"], nil)]
  until signals.empty?
    signals.shift => { from:, to:, value: }
    new_signals = to.call(value, from)
    new_signals.each do |s|
      yield s if block_given?
    end
    return true if signals.find { _1.to == Mod["rx"] && _1.value == false }

    signals.push(*new_signals)
  end
  false
end

# From the visualisation, we need these four nodes to be positive
# And by good chance they are positive on a regular sequence of primes
%w[lg gr bn st].map do |n|
  mod = Mod[n]
  Mod.modules.each_value(&:reset!)
  pushes = 0
  found = []

  until pushes == 10_000
    seen = false
    pushes += 1
    press do |s|
      if !seen && s.from == mod && !s.value
        seen = true
        found << pushes
      end
    end
  end

  found.each_cons(2).map { _2 - _1 }.first
  # Multiple the primes - Chinese remainder theorem??
end.reduce(:*).then { puts _1 }
