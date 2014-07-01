
FactoryGirl.define do 
  factory :user do
    sequence(:login) { |n| "login#{n}" }
    sequence(:mail) { |n| "user#{n}@example.com" }
    sequence(:firstname) { |n| "Person #{n}" }
    sequence(:lastname) { |n| "Lastname #{n}" }
    password "foobar"
    password_confirmation "foobar"
    language "en"
    status 1
  end

  factory :project do
    sequence(:name) { |n| "Project #{n}" }
    sequence(:identifier) { |n| "project-#{n}" }
    sequence(:homepage) { |n| "www.project-#{n}.com" }
    description "Lorem Ipsum"
    is_public true
  end

  factory :tracker do
    sequence(:name) { |n| "Tracker #{n}" }
  end 

  factory :version do
    sequence(:name) { |n| "Version #{n}" }
    project
    description "Lorem Ipsum"
    status "open"
    sharing "none"
  end

  factory :issue do 
    sequence(:subject) { |n| "Issue #{n}" }
    project
    association :author, factory: :user
    tracker
    start_date Time.now
    association :fixed_version, factory: :version
    is_private false
  end 
end 
