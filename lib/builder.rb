load 'task/user.rb'

class Builder
  attr_reader :users, :session_count, :unique_browsers

  def initialize(users,session_count, unique_browsers)
    @users = users
    @session_count = session_count
    @unique_browsers = unique_browsers
  end

  def call
  # Отчёт в json
  #   - Сколько всего юзеров +
  #   - Сколько всего уникальных браузеров +
  #   - Сколько всего сессий +
  #   - Перечислить уникальные браузеры в алфавитном порядке через запятую и капсом +
  #
  #   - По каждому пользователю
  #     - сколько всего сессий +
  #     - сколько всего времени +
  #     - самая длинная сессия +
  #     - браузеры через запятую +
  #     - Хоть раз использовал IE? +
  #     - Всегда использовал только Хром? +
  #     - даты сессий в порядке убывания через запятую +

    report = {
      'totalUsers': users.size,
      'uniqueBrowsersCount': unique_browsers.size,
      'totalSessions': session_count,
      'allBrowsers': unique_browsers.keys.sort.join(',')
    }

    # Статистика по пользователям
  
    users.each do |user_data|
      user = User.new(attributes: user_data[1])
      report['usersStats'] ||= {}
      report['usersStats']["#{user.attributes['first_name']} #{user.attributes['last_name']}"] = {
        # Собираем количество сессий по пользоfвателям
        'sessionsCount' => user.attributes['sessions'].size,
        # Собираем количество времени по пользователям
        'totalTime' => "#{user.time.sum} min.",
        # Выбираем самую длинную сессию пользователя
        'longestSession' => "#{user.time.max} min.",
        # Браузеры пользователя через запятую
        'browsers' => user.browser.join(', '),
        # Хоть раз использовал IE?
        'usedIE' => user.browser.any? { |b| b =~ /INTERNET EXPLORER/ },
        # Всегда использовал только Chrome?
        'alwaysUsedChrome' => user.browser.all? { |b| b =~ /CHROME/ },
        # Даты сессий через запятую в обратном порядке в формате iso8601
        'dates' => user.date.sort.reverse
      }
    end
    File.binwrite 'result.json', report.to_json+"\n"
  end
end