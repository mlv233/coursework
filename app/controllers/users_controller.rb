class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit]

  def index
    #@users = UsersQuery.main_sort(params)
    @users = User.all
    #@sort_by = params[:sort_by]
    @name = params[:name]
    @email = params[:email]
    @city = params[:city]
    @phone_number = params[:phone_number]
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.add_user(user_params[:name], user_params[:email], user_params[:city], user_params[:phone_number])
    if @user
      redirect_to @user
    else
      flash.now[:alert] = 'This user already exists!'
      @user = User.new
      render :new
    end
  end

  def edit; end

  def update
    user = User.update_user(user_params[:name], user_params[:email], user_params[:city], user_params[:phone_number], params[:id])
    if user
      redirect_to user
    else
      flash.now[:alert] = 'This user already exists!'
      set_user
      render :edit
    end
  end

  def destroy
    User.delete_user_id(params[:id])
    redirect_to users_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :address)
  end
end
