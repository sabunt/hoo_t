# Тут находится программа, выполняющая обработку данных из файла.
# Тест показывает как программа должна работать.
# В этой программе нужно обработать файл данных data_large.txt.

# Ожидания от результата:

# Корректная обработатка файла data_large.txt;
# Проведена оптимизация кода и представлены ее результаты;
# Production-ready код;
# Применены лучшие практики;

require 'json'
require 'date'

class User
  attr_reader :attributes

  def initialize(attributes:)
    @attributes = attributes
  end

  def time
    @time ||= sessions.map {|s| s['time'].to_i}
  end

  def browser
    @browser ||= sessions.map {|s| s['browser']}
  end

  def date
    @date ||= sessions.map{|s| s['date']}
  end

  def sessions
   @session ||= attributes['sessions']
  end
end

def parse_user(fields)
  {
    'id' => fields[1],
    'first_name' => fields[2],
    'last_name' => fields[3],
    'age' => fields[4],
    'sessions'=>[]
  }
end

def parse_session(fields)
  {
    'user_id' => fields[1],
    'session_id' => fields[2],
    'browser' => fields[3].upcase,
    'time' => fields[4].to_i,
    'date' => fields[5].chomp,
  }
end

def work(data_file)
  file = File.foreach(data_file)

  users = {}
  unique_browsers = {}
  session_counter = 0

  file.each_entry do |line|
    
    cols = line.split(',')

    if cols[0] == 'user'
      users[cols[1]] = parse_user(cols)
    elsif cols[0] == 'session'
      session = parse_session(cols)
      session_counter += 1
      users[session['user_id']]['sessions'] ||= []
      users[session['user_id']]['sessions'] << session
      
      unique_browsers[session['browser']] = true
    else
      next 
    end
    
  end

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

  report = {}

  report['totalUsers'] = users.size

  # Подсчёт количества уникальных браузеров

  report['uniqueBrowsersCount'] = unique_browsers.size

  report['totalSessions'] = session_counter

  report['allBrowsers'] = unique_browsers.keys.sort.join(',')

  # Статистика по пользователям
  

  users.each do |user_data|
    user = User.new(attributes: user_data[1])
    report['usersStats'] ||= {}
    user_key = "#{user.attributes['first_name']} #{user.attributes['last_name']}"
    report['usersStats'][user_key] = {
      # Собираем количество сессий по пользователям
      'sessionsCount' => user.attributes['sessions'].size,
      # Собираем количество времени по пользователям
      
      'totalTime' => "#{user.time.sum} min.",
      # Выбираем самую длинную сессию пользователя
      'longestSession' => "#{user.time.max} min.",
      # Браузеры пользователя через запятую
      'browsers' => user.browser.sort.join(', '),
      # Хоть раз использовал IE?
      'usedIE' => user.browser.any? { |b| b =~ /INTERNET EXPLORER/ },
      # Всегда использовал только Chrome?
      'alwaysUsedChrome' => user.browser.all? { |b| b =~ /CHROME/ },
      # Даты сессий через запятую в обратном порядке в формате iso8601
      'dates' => user.date.sort.reverse
    }
  end

  File.write('result.json', "#{report.to_json}\n")
end