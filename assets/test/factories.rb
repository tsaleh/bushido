Factory.sequence(:email) {|n| "none#{n}@example.com" }
Factory.sequence(:url)   {|n| "http://www.google#{n}.com/" }

Factory.define :user do |f|
  f.name "Bob"
  f.email { Factory.next(:email) }
  f.password "changeme"
  f.password_confirmation {|user| user.password }

  # Necessary to keep authlogic from 
  # logging in each user as we create them.
  f.skip_session_maintenance true
end

