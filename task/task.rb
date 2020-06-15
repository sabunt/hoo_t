# Тут находится программа, выполняющая обработку данных из файла.
# Тест показывает как программа должна работать.
# В этой программе нужно обработать файл данных data_large.txt.

# Ожидания от результата:

# Корректная обработатка файла data_large.txt;
# Проведена оптимизация кода и представлены ее результаты;
# Production-ready код;
# Применены лучшие практики;

require 'Oj'
require 'date'
require 'pry'

load 'lib/helper.rb'

Oj.default_options = {:mode => :compat }

class Task
  include Helper
  attr_reader :path_file

  def initialize(path_file)
    @path_file ||= path_file
  end

  def call
    users = {}
    report ||= {}
    browsers ||= {}
    session_counter =0

    IO.foreach(path_file).each_entry do |line|
      cols = line.chomp.split(',')

      if cols[0] == 'user'
        users[cols[1].to_sym]
        users[cols[1].to_sym] = parse_user(cols)
      else
        session_counter +=1
        users[cols[1].to_sym][:sessions] << parse_session(cols)
        browsers[cols[3].upcase] = true
      end
    end

    report = {
      'totalUsers': users.size,
      'uniqueBrowsersCount': browsers.size,
      'totalSessions': session_counter,
      'allBrowsers': browsers.map{|k,v| k}.sort.join(',')
    }

    # Статистика по пользователям
    users.each do |user|
      report[:usersStats] ||= {}      
      report[:usersStats]["#{user[1][:first_name]} #{user[1][:last_name]}"] = {
        # Собираем количество сессий по пользоfвателям
        'sessionsCount' => user[1][:sessions].size,
        # Собираем количество времени по пользователям
        'totalTime' => "#{user[1][:sessions].map{|s| s[:time].to_i}.sum} min.",
        # Выбираем самую длинную сессию пользователя
        'longestSession' => "#{user[1][:sessions].map{|s| s[:time].to_i}.max} min.",
        # Браузеры пользователя через запятую
        'browsers' => user[1][:sessions].map{|s| s[:browser].upcase}.sort.join(', '),
        # Хоть раз использовал IE?
        'usedIE' => user[1][:sessions].map{|s| s[:browser].upcase}.any? { |b| b =~ /INTERNET EXPLORER/ },
        # Всегда использовал только Chrome?
        'alwaysUsedChrome' => user[1][:sessions].map{|s| s[:browser].upcase}.all? { |b| b =~ /CHROME/ },
        # Даты сессий через запятую в обратном порядке в формате iso8601
        'dates' => user[1][:sessions].map{|s| s[:date]}.sort.reverse
      }
    end
    IO.binwrite('result.json', Oj.dump(report, symbol_keys: false)+ "\n")
  end
end