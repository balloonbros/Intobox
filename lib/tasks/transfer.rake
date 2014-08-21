require 'growthforecast'

namespace :growth do
  desc 'post transfered files count to growthforecast'
  task transfer: :environment do
    post_to_growthforecast('transfer', 'all', TransferHistory.count)
  end
end
