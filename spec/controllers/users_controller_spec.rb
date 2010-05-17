require 'spec_helper'

describe UsersController do
  integrate_views
  #Delete these examples and add some real ones
  it "should use UsersController" do
    controller.should be_an_instance_of(UsersController)
  end


  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
    it "should have a title" do
      get 'new'
      response.should have_tag('title', /sign up/i)
    end
  end
  
  describe "GET 'show'" do
    before(:each) do
      @user=Factory(:user)
      User.stub!(:find, @user.id).and_return(@user)
    end
  
    it "should be successful" do
      get :show, :id => @user #could also be written @user.id - just an idiom
      response.should be_success
    end
    it "should have the right title" do
      get :show, id=> @user
      response.should have_tag("title", /#{@user.name}/)
    end
    it "should include the user's name" do
      get :show, id => @user
      response.should have_tag("h2", /#{@user.name}/)
    end
    it "should have a profile image" do
      get :show, id => @user
      response.should have_tag("h2>img", :class=>"gravatar")
    end
  end
  
  describe "POST 'create'" do
    describe "failure" do
      before(:each) do
        @attr= { :name => "" , :email => "", :password => "" ,  
                :password_confirmation => "" }
        @user = Factory.build(:user, @attr) #build simulates new user creation
        User.stub!(:new).and_return(@user)
        @user.should_receive(:save).and_return(false) 
              #message expectation simulates model by forcing "false"
      end
           
      it "should have the right title do" do
        post :create, :user => @attr
        response.should have_tag("title", /sign up/i)
      end
      
      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end
    describe "succcess" do
      before(:each) do
        @attr= { :name => "Michael hartl" , :email => "mhartl@example.com", :password => "password1" , :password_confirmation => "password1" }
        @user=Factory(:user, @attr) #simulates a saved user
        User.stub!(:new).and_return(@user)
        @user.should_receive(:save).and_return(true)
      end
      
      it "should redirect to the user/show page" do
        post :create, :user =>@attr
        response.should redirect_to(user_path(@user))
      end
      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to the sample app/i
      end
    end
  end
  describe "GET :new" do
    it "should render the 'new' page" do
      get :new
      response.should be_success
    end
    it "should have a name field" do
      get :new
      response.should have_tag("input#user_name")
    end
    it "should have an email field" do
      get :new
      response.should have_tag("input#user_email")
    end
    it "should have a password field" do
      get :new
      response.should have_tag("input#user_password")
    end
    it "should have a password confirmation field" do
      get :new
      response.should have_tag("input#user_password_confirmation")
    end
    it "should have a submit button" do
      get :new
      response.should have_tag("input#user_submit")
    end
  end  
end