require 'minitest/autorun'
load 'task/user.rb'

class UserTest < Minitest::Test
  def test_User_with_attributes_returns_data
    attr = {"id"=>"0",
      "first_name"=>"Leida",
      "last_name"=>"Cira",
      "age"=>"0\n",
      "sessions"=>
       [{"user_id"=>"0", "session_id"=>"0", "browser"=>"SAFARI 29", "time"=>87, "date"=>"2016-10-23"},
        {"user_id"=>"0", "session_id"=>"1", "browser"=>"FIREFOX 12", "time"=>118, "date"=>"2017-02-27"},
        {"user_id"=>"0", "session_id"=>"2", "browser"=>"INTERNET EXPLORER 28", "time"=>31, "date"=>"2017-03-28"},
        {"user_id"=>"0",
         "session_id"=>"3",
         "browser"=>"INTERNET EXPLORER 28",
         "time"=>109,
         "date"=>"2016-09-15"},
        {"user_id"=>"0", "session_id"=>"4", "browser"=>"SAFARI 39", "time"=>104, "date"=>"2017-09-27"},
        {"user_id"=>"0", "session_id"=>"5", "browser"=>"INTERNET EXPLORER 35", "time"=>6, "date"=>"2016-09-01"}]}

    user = User.new(attributes:attr)
    assert user.sessions != nil    
    assert user.time == [87, 118, 31, 109, 104, 6]
    assert user.browser == ["FIREFOX 12",
      "INTERNET EXPLORER 28",
      "INTERNET EXPLORER 28",
      "INTERNET EXPLORER 35",
      "SAFARI 29",
      "SAFARI 39"]
    assert user.date == ["2016-10-23", "2017-02-27", "2017-03-28", "2016-09-15", "2017-09-27", "2016-09-01"]
  end
end
