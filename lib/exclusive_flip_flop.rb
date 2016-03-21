class ExclusiveFlipFlop
  def initialize(state)
    @state = state
  end

  def event(event)
    @state == :left  and return event ? :true_right : :false_left
    @state == :right and return event ? :true_left  : :true_right
    raise unless event.nil?
    @state == :true_right and return :right
    :left
  end

  private

  def unexpected(case_value)
    raise "Wtf is `#{case_value.inspect}`?"
  end
end
