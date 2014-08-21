FactoryGirl.define do
  factory :facebook_friend do
    association :user
    association :friend_user, factory: :user
    sequence(:facebook_id)
    facebook_name 'Sebastian'
  end
end
