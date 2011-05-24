require 'spec_helper'

describe PagesController do
  render_views

  describe "GET 'home'" do
    describe "when not signed in" do
      before(:each) do
        get :home
      end

      it "should be successful" do
        response.should be_success
      end

      it "should have the right title" do
        response.should have_selector("title", :content => "Ruby Twitter | Home")
      end
    end  

    describe "with signed-on user" do
      before(:each) do
        @user = test_sign_in(Factory(:user))
        Factory(:micropost, user: @user, content: "foo")
        Factory(:micropost, user: @user, content: "bar")
        other_user = Factory(:user, email: Factory.next(:email))
        other_user.follow!(@user)

        get :home
      end

      it "should have the correct micropost count" do
        response.should have_selector("span.microposts", content: "2 microposts")
      end

      it "should have the right follower/following counts" do
        response.should have_selector("a", href: following_user_path(@user),
                                           content: "0 following")
        response.should have_selector("a", href: followers_user_path(@user),
                                           content: "1 follower")
      end
    end
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end

    it "should have the right title" do
      get 'contact'
      response.should have_selector("title", :content => "Ruby Twitter | Contact")
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end

    it "should have the right title" do
      get 'about'
      response.should have_selector("title", content: "Ruby Twitter | About")
    end
  end

  describe "GET 'help'" do
    it "should be successful" do
      get 'help'
      response.should be_success
    end

    it "should have the right title" do
      get 'help'
      response.should have_selector("title", content: "Ruby Twitter | Help")
    end
  end

end
