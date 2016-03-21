require 'exclusive_flip_flop'

RSpec.configure do |config|
  config.fail_fast = true
end

RSpec.describe 'Exclusive Flip Flop (3 dots)' do
  def flip_flop_states
    states = []
    events = [false, true, false, true, false, :untouched]
    5.times do
      if (states << [:left, events.first]; events.shift) ... (states << [:right, events.first]; events.shift)
        states << [true,  nil]
      else
        states << [false, nil]
      end
    end
    raise if events != [:untouched]
    states.each_cons(2)
          .flat_map { |(initial, event), (final, _)|
            next [initial,                event] if Symbol === initial
            next [:"#{initial}_#{final}", nil]   if TrueClass === initial || FalseClass === initial
            raise "WTF: #{initial.inspect}"
          }
          .each_cons(3)
          .select.with_index { |s, i| i.even? }
          .each_with_object({}) { |(pre, event, post), map|
            (map[pre] ||= {})[event] = post
          }
  end

  def self.heading(heading)
    @heading = heading
    @format  = @heading.scan(/\w+\s*/).map(&:length).map(&:pred).map { |n| "%-#{n}s" }.join(" ")
    example(heading) {}
    example('-' * heading.length) {}
  end

  def self.assert_transition(initial, event, final)
    specify @format % [initial, event.inspect, final] do
      # validate that this is what the flip flop does
      actual = flip_flop_states.fetch(initial).fetch(event)
      expect(actual).to eq final

      # and now that this is what our state machine does
      actual = ExclusiveFlipFlop.new(initial).event(event)
      expect(actual).to eq final
    end
  end

  heading           'state       event  state'
  assert_transition :left,       true,  :true_right
  assert_transition :left,       false, :false_left
  assert_transition :right,      true,  :true_left
  assert_transition :right,      false, :true_right
  assert_transition :true_right, nil,   :right
  assert_transition :true_left,  nil,   :left
  assert_transition :false_left, nil,   :left
end
