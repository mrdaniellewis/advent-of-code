# frozen_string_literal: true

Sig = Data.define(:from, :to, :value)

class Mod
  attr_accessor :name
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
    outputs.each do |n|
      @@modules[n] ||= Output.new(name: n)
    end
  end

  def outputs
    @outputs.map do |n|
      yield @@modules[n]
    end
  end
end

class Button < Mod
  def call(*)
    outputs { Sig.new(self, _1, false) }
  end

  def inspect
    "#<#{name}>"
  end
end

class Output < Mod
  def call(*)
    []
  end

  def inspect
    "#<#{name}>"
  end
end

class Broadcast < Mod
  def call(value, _)
    outputs { Sig.new(self, _1, value) }
  end

  def inspect
    "#<#{name}>"
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
    "#<%#{name} #{@on}>"
  end
end

class Conjunction < Mod
  attr_accessor :state

  def initialize(...)
    super
    @state = {}
  end

  def connect(mod)
    @state[mod] = false
  end

  def call(value, mod)
    @state[mod] = value
    outputs { Sig.new(self, _1, !@state.values.all?) }
  end

  def inspect
    "#<&#{name}>"
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
    next unless out.is_a?(Conjunction)

    out.connect mod
  end
end

pushes = 0
signal_count = Hash.new { 0 }

def debug(sig)
  "#{sig.from.name} -#{sig.value ? 'high' : 'low'}-> #{sig.to.name}"
end

until pushes == 1000
  pushes += 1
  signals = [Sig.new(nil, Mod["button"], nil)]
  until signals.empty?
    signals.shift => { from:, to:, value: }
    new_signals = to.call(value, from)

    new_signals.each do |s|
      # puts debug(s)
      signal_count[s.value] += 1
    end
    signals.push(*new_signals)
  end
end

pp signal_count.values.reduce(:*)
