set :output, 'log/cron.log'

every :hour do
  rake 'growth:user:register'
  rake 'growth:user:withdrawal'
  rake 'growth:transfer'
end
