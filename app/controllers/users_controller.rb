class UsersController < ApplicationController
  before_filter :authenticate, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user,   only: :destroy
  before_filter :only_anonymous, only: [:new, :create]

  def index
    @title = "All users"
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    @title = @user.name
  end

  def new
    @user = User.new
    @title = "Sign up"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Ruby Twitter!"
      redirect_to @user
    else
      @title = "Sign up"
      @user.password = ""
      @user.password_confirmation = ""
      render 'new'
    end
  end

  def edit
    @title = "Edit user"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def destroy
    delete_user = User.find(params[:id])
    if current_user?(delete_user)
      flash[:error] = "You cannot destroy yourself."
    else
      delete_user.destroy
      flash[:success] = "User destroyed."
    end
    redirect_to users_path
  end
  
  private

  def authenticate
    deny_access unless signed_in?
  end
  
  def only_anonymous
    redirect_to(root_path) if signed_in?
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end
