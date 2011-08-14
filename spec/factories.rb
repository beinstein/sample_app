Factory.define :user do |user|
  user.name                   "Ben Einstein"
  user.email                  "beinstein@me.com"
  user.password               "foobar"
  user.password_confirmation  "foobar"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end