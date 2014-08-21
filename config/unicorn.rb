env = ENV['RAILS_ENV'] || ENV['RACK_ENV']
case env
when 'production'
  worker_processes 8
else
  worker_processes 2
end

if env == 'production' || env == 'staging'
  pid (ENV['UNICORN_PID'] || "/home/intobox/#{env}/shared/pids/unicorn.pid")
end

# ログ
stderr_path File.expand_path('log/unicorn.log', ENV['RAILS_ROOT'])
stdout_path File.expand_path('log/unicorn.log', ENV['RAILS_ROOT'])

# ダウンタイムなくす
preload_app true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!

  # 古いマスタープロセスをKILL
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill(:QUIT, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
