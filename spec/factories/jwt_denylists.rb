FactoryBot.define do
  factory :jwt_denylist do
    jti { Secure.random(16) }
    exp { 10.minutes.since }
  end
end
