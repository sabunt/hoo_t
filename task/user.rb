class User
  attr_reader :attributes

  def initialize(attributes:)
    @attributes = attributes

  end

  def time
    @time ||= all_sessions.map {|s| s[:time].to_i}
  end

  def browser
    @browser ||= all_sessions.map {|s| s[:browser]}.sort
  end

  def date
    @date ||= all_sessions.map{|s| s[:date]}
  end

  def all_sessions
   @session ||= attributes[:sessions]
  end
end