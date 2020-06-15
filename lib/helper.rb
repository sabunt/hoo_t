module Helper
  def parse_user(fields)
  {
    :id => fields[1],
    :first_name => fields[2],
    :last_name => fields[3],
    :age => fields[4],
    :sessions=>[]
  }
  end

  def parse_session(fields)
    {
      :user_id => fields[1],
      :session_id => fields[2],
      :browser => fields[3].upcase,
      :time => fields[4].to_i,
      :date => fields[5],
    }
  end

  def time(user)
    @time ||= all_sessions(user).map {|s| s[:time].to_i}
  end

  def browser(user)
    @browser ||= all_sessions(user).map {|s| s[:browser].upcase}.sort
  end

  def date(user)
    @date ||= all_sessions(user).map{|s| s[:date]}
  end

  def all_sessions(user)
   @all_sessions ||= user[:sessions]
  end
end