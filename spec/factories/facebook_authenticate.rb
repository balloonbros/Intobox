FactoryGirl.define do
  factory :facebook_authenticate do
    association :user
    facebook_id '100000000000000'
    access_token ((0..9).to_a + ("a".."z").to_a + ("A".."Z").to_a + [ '-', '_' ]).sample(64).join
    facebook_name 'Sebastian'
    facebook_email 'sebastian@intobox.in'
    deleted false
  end
end
