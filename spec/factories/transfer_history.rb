FactoryGirl.define do
  factory :transfer_history do
    send_user_id { FactoryGirl.create(:user) }
    receive_user_id { FactoryGirl.create(:user) }
    state Settings.database.transfer_histories.sending
    filename 'test.txt'
    api_response ''
    file_size 5000
    deleted false

    trait :success do
      state Settings.database.transfer_histories.success
    end

    trait :error do
      state Settings.database.transfer_histories.error
    end
  end
end
