require 'minitest/autorun'
require 'json'

load 'lib/builder.rb'

class TestBuilder < Minitest::Test
  def setup
    File.write('result.json', '')
  end

  def test_User_with_attributes_returns_data
    users_data = 
      {"0"=>
        {"id"=>"0",
        "first_name"=>"Leida",
        "last_name"=>"Cira",
        "age"=>"0\n",
        "sessions"=>
          [
            {"user_id"=>"0", "session_id"=>"0", "browser"=>"SAFARI 29", "time"=>87, "date"=>"2016-10-23"},
            {"user_id"=>"0", "session_id"=>"1", "browser"=>"FIREFOX 12", "time"=>118, "date"=>"2017-02-27"},
            {"user_id"=>"0",
              "session_id"=>"2",
              "browser"=>"INTERNET EXPLORER 28",
              "time"=>31,
              "date"=>"2017-03-28"},
            {"user_id"=>"0",
              "session_id"=>"3",
              "browser"=>"INTERNET EXPLORER 28",
              "time"=>109,
              "date"=>"2016-09-15"},
            {"user_id"=>"0", "session_id"=>"4", "browser"=>"SAFARI 39", "time"=>104, "date"=>"2017-09-27"},
            {"user_id"=>"0",
              "session_id"=>"5",
              "browser"=>"INTERNET EXPLORER 35",
              "time"=>6,
              "date"=>"2016-09-01"}
          ]
        }
      }

    uniq_browsers = {"SAFARI 39":true, "FIREFOX 12":true, "INTERNET EXPLORER 28":true, "INTERNET EXPLORER 35":true}
   
    Builder.new(users_data, 6, uniq_browsers).call
    
    expected_result = '{"totalUsers":1,"uniqueBrowsersCount":4,"totalSessions":6,"allBrowsers":"FIREFOX 12,INTERNET EXPLORER 28,INTERNET EXPLORER 35,SAFARI 39","usersStats":{"Leida Cira":{"sessionsCount":6,"totalTime":"455 min.","longestSession":"118 min.","browsers":"FIREFOX 12, INTERNET EXPLORER 28, INTERNET EXPLORER 28, INTERNET EXPLORER 35, SAFARI 29, SAFARI 39","usedIE":true,"alwaysUsedChrome":false,"dates":["2017-09-27","2017-03-28","2017-02-27","2016-10-23","2016-09-15","2016-09-01"]}}}'  + "\n"

    assert_equal expected_result, File.read('result.json')
  end
end

