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
require 'pry'

load 'lib/helper.rb'
load 'lib/builder.rb'

class Task
  include Helper
  attr_reader :path_file

  def initialize(path_file)
    @path_file ||= path_file
  end

  def call
    users = {}
    users[:data] ||= {}
    users[:report] ||= {}
    unique_browsers = {}
    session_count = 0

    File.foreach(path_file) do |line|
      cols = line.split(',')

      if cols[0] == 'user'
        users[:data][cols[1].to_sym]
        users[:data][cols[1].to_sym] = User.new(attributes: parse_user(cols))
        
      elsif cols[0] == 'session'
        session_count += 1
        users[:data][cols[1].to_sym].attributes[:sessions] << parse_session(cols)
        unique_browsers[cols[3].upcase] = true
      else
        next 
      end
    end
    
    users[:report] = {
      'totalUsers': users[:data].size,
      'uniqueBrowsersCount': unique_browsers.size,
      'totalSessions': session_count,
      'allBrowsers': unique_browsers.keys.sort.join(',')
    }

    # Статистика по пользователям
    users[:data].each do |user|
      users[:report][:usersStats] ||= {}
      users[:report][:usersStats]["#{user[1].attributes[:first_name]} #{user[1].attributes[:last_name]}"] = {
        # Собираем количество сессий по пользоfвателям
        'sessionsCount' => user[1].attributes[:sessions].size,
        # Собираем количество времени по пользователям
        'totalTime' => "#{user[1].time.sum} min.",
        # Выбираем самую длинную сессию пользователя
        'longestSession' => "#{user[1].time.max} min.",
        # Браузеры пользователя через запятую
        'browsers' => user[1].browser.join(', '),
        # Хоть раз использовал IE?
        'usedIE' => user[1].browser.any? { |b| b =~ /INTERNET EXPLORER/ },
        # Всегда использовал только Chrome?
        'alwaysUsedChrome' => user[1].browser.all? { |b| b =~ /CHROME/ },
        # Даты сессий через запятую в обратном порядке в формате iso8601
        'dates' => user[1].date.sort.reverse
      }
    end
    File.binwrite('result.json', users[:report].to_json + "\n")
  end
  #   Builder.new(users, session_count, unique_browsers).call
  # end
end