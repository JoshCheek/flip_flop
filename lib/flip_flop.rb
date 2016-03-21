class FlipFlop
  def initialize(state, inclusive:)
    @state     = state
    @inclusive = inclusive
  end

  def event(event)
    case @state
    when :left  then left  event
    when :right then right event
    else @state == :true_right ? :right : :left
    end
  end

  private

  def left(event)
    return :false_left unless event
    @inclusive ? :right : :true_right
  end

  def right(event)
    event ? :true_left : :true_right
  end
end
