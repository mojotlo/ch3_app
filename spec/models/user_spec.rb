# == Schema Information
# Schema version: 20100515114814
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  remember_token     :string(255)
#

require 'spec_helper'

describe User do
  before(:each) do
    @attr = {:name => "Example User", :email => "example@example.com" ,      
      :password => "Valid002" , :password_confirmation => "Valid002" }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end
  
  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name =>""))
    no_name_user.should_not be_valid
  end
  it "should require an email" do
    no_name_user = User.new(@attr.merge(:email =>""))
    no_name_user.should_not be_valid
  end  
  
  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end
  it "should accept valid email addresses" do
    addresses = %w[users@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email=> address))
      valid_email_user.should be_valid
    end
  end
  
  it "should reject invalid email addresses" do
    addresses= %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email=>address))
      invalid_email_user.should_not be_valid
    end
  end
  it "should reject duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicate_email=User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  it "should reject emails duplicate up to case" do
    upcased_email=@attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email=User.new(@attr.merge(:email => upcased_email))
  end

  describe "password validations" do
    it "should require a password" do
      User.new(@attr.merge(:password=>"",
                          :password_confirmation=>"")).
                          should_not be_valid
    end 
    it "should require a matching password validation" do
      User.new(@attr.merge(:password_confirmation=>"something")).
      should_not be_valid
    end
    
    it "should reject passwords that are too short" do
      short_password="a"*6
      short_password_user=User.new(@attr.merge(:password=>short_password))
      short_password_user.should_not be_valid
    end
    it "should reject passwords that are too long" do
      long_password="a"*20
      long_password_user=User.new(@attr.merge(:password=>long_password))
      long_password_user.should_not be_valid
    end
  end
  describe "password encryption" do
    before(:each) do
      @user=User.create!(@attr)
    end
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end
    describe "has a password method" do
      it "should be true if passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end
      
      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end
    end
    describe "authenticate method" do
      it "should return nil on email/password mismatch" do
        wrong_password_user=User.authenticate(@attr[:email], "wrong password")
        wrong_password_user.should be_nil
      end
      it "should return nil for an email address with no user" do
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent_user.should be_nil      
      end
      it "should return the user on email/password match" do
        matching_user=User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end
    end
  end  
  describe "remember me" do
    before(:each) do
      @user = User.create!(@attr)
    end
    it "should have a remember me method" do
      @user.should respond_to(:remember_me!)
    end
    
    it "should set the remember token" do  
      @user.should respond_to(:remember_token)
    end
    
    it "should set the remember token" do
      @user.remember_me!
      @user.remember_token.should_not be_nil
    end
  end  
end
