require 'benchmark'
require "memory_profiler"

load 'task/task.rb'
# load 'benchmark/task_less_objects.rb'

def run_benchmark
  Benchmark.bm do |x|
    # x.report("check task with small data") { memory_bm {Task.new('data/data_light.txt').call} }
    x.report("check task with classes and objects") { memory_bm {Task.new('data/data_large.txt').call} }
  end
end

def memory_bm
  memory_before = %x[ps -o rss= -p "#{Process.pid}"].to_i
  yield
  memory_after = %x[ps -o rss= -p "#{Process.pid}"].to_i
  puts ". Memory usage: #{((memory_after - memory_before) / 1024.0).round(2)} MB"
end