module SpecHelpers
  def build_state_transitions(events, states)
    raise events.inspect if events != [:untouched]
    states.each_cons(2)
          .flat_map { |(state, event), (next_state, _)|
            next [state,                     event] if Symbol === state
            next [:"#{state}_#{next_state}", nil]   if TrueClass === state || FalseClass === state
            raise "WTF: #{state.inspect}"
          }
          .each_cons(3)
          .select.with_index { |s, i| i.even? }
          .each_with_object({}) { |(pre, event, post), map|
            (map[pre] ||= {})[event] = post
          }
  end
end

module SpecGroupHelpers
  def heading(heading)
    @heading = heading
    @format  = @heading.scan(/\w+\s*/).map(&:length).map(&:pred).map { |n| "%-#{n}s" }.join(" ")
    example(heading) {}
    example('-' * heading.length) {}
  end
end

RSpec.configure do |config|
  config.fail_fast = true
  config.include SpecHelpers
  config.extend  SpecGroupHelpers
end
