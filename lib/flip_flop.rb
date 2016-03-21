class FlipFlop
  def initialize(state, inclusive:)
    @state     = state
    @inclusive = inclusive
  end

  def event(event)
    @state == :left  and return !event     ? :false_left :
                                @inclusive ? :right :
                                             :true_right
    @state == :right and return event ? :true_left : :true_right
    raise unless event.nil?
    @state == :true_right and return :right
    :left
  end

  private

  def unexpected(case_value)
    raise "Wtf is `#{case_value.inspect}`?"
  end
end
