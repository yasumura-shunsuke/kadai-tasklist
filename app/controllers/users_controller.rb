class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show]
  def index
    @users = User.all.page(params[:page])
  end

  def show
    if logged_in?
      @user =  current_user
      @tasks = current_user.tasks.order('id DESC').page(params[:page])
      @task =  current_user.tasks.build
      counts(@user)
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'ユーザーは正常に登録されました'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザーは正常に登録されませんでした'
      render :new
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
