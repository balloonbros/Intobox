FactoryGirl.define do
  factory :user do
    ip '127.0.0.1'
    state Settings.database.users.state.valid
    deleted 0
  end
end
