require 'growthforecast'

namespace :user do
  task rebuild_all_friend_list: :environment do
    User.all.each do |friend|
      begin
        friend.rebuild_friend_list
      rescue => e
        Rails.logger.error e
      end
    end
  end
end

namespace :growth do
  namespace :user do
    desc 'post registered users count to growthforecast'
    task register: :environment do
      post_to_growthforecast('users', 'register', User.count)
    end

    desc 'post withdrawal users count to growthforecast'
    task withdrawal: :environment do
      post_to_growthforecast('users', 'withdrawal', User.invalid.count)
    end
  end
end
