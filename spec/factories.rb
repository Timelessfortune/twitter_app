FactoryGirl.define do
	factory :user do
		name "Andrew Huang"
		email "test@example.com"
		password "123456"
		password_confirmation "123456"
	end
end