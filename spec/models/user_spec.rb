require 'spec_helper'

describe User do
	before do 
		@user = User.new(name: "Example", email: "user@example.com", 
			password: "abcdef", password_confirmation: "abcdef") 
	end

	subject { @user }

	it { should respond_to(:name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:remember_token) }
	it { should respond_to(:authenticate) }

	it { should be_valid }

	describe "when name is not present" do
		before do
		  @user.name = " "
		end
		it { should_not be_valid }
	end

	describe "when email is not present" do
		before do
		  @user.email = " "
		end
		it { should_not be_valid }
	end

	describe "when name is too long" do
		before do
		  @user.name = "z" * 41
		end
		it { should_not be_valid }
	end

	describe "when email format is invalid" do
		it "should be invalid" do
			addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      		addresses.each do |invalid_address|
        		@user.email = invalid_address
        		expect(@user).not_to be_valid
        	end
		end
	end

	describe "when email format is valid" do
		it "should be valid" do
			addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      		addresses.each do |valid_address|
      			@user.email = valid_address
      			expect(@user).to be_valid
      		end
		end
	end

	describe "when email is not unique" do
		before do
		  user_with_same_email = @user.dup
		  user_with_same_email.email = @user.email.upcase
		  user_with_same_email.save
		end

		it { should_not be_valid }
	end

	describe "when password is not present" do
		before do
		  @user.password = " "
		  @user.password_confirmation = " "
		end
	end

	describe "when password is different from confirmation" do
		before do
		  @user.password_confirmation = "random"
		  it { should_not be_valid }
		end
	end

	describe "return value of authenticate method" do
		before do
		  @user.save
		end
		let(:found_user) { User.find_by(email: @user.email) }

		describe "user has valid password" do
			it { should eq found_user.authenticate(@user.password) }
		end

		describe "user has invalid password" do
			let(:user_for_invalid) { found_user.authenticate("invalid_pw") }

			it { should_not eq user_for_invalid }
			specify { expect(user_for_invalid).to be_false }
		end

		describe "user has a password that's too short" do
			before do
			  @user.password = @user.password_confirmation = "12345"
			end
			it { should_not be_valid }
		end
	end

	describe "remember token" do
		before { @user.save }
		its(:remember_token) { should_not be_blank }
	end
end