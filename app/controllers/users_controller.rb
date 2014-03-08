class UsersController < ApplicationController

  respond_to :html, :json

  def index
    if params[:project_id]
      @project = current_user.projects.find(params[:project_id])
      authorize! :manage, @project
      @users = @project.users
    else
      authorize! :manage, User
      @users = User.all
    end
    @user = User.new
    respond_with(@users)
  end

  def create
    @project = current_user.projects.find(params[:project_id])
    @users = @project.users
    @user = User.find_or_create_by_email(params[:user][:email]) do |u|
      # Set to true if the user was not found
      u.was_created = true
      u.name = params[:user][:name]
      u.initials = params[:user][:initials]
    end

    if @user.new_record? && !@user.save
      render 'index'
      return
    end

    if @project.users.include?(@user)
      flash[:alert] = "#{@user.email} is already a member of this project"
    else
      @project.users << @user
      if @user.was_created
        flash[:notice] = "#{@user.email} was sent an invite to join this project"
      else
        flash[:notice] = "#{@user.email} was added to this project"
      end
    end

    redirect_to project_users_url(@project)
  end

  def update
    authorize! :manage, User
    user = User.find params[:id]
    if params[:make_admin]
      user.roles = ["admin"]
      user.save
    elsif params[:remove_admin]
      old_roles = user.roles
      old_roles.delete("admin")
      user.roles = old_roles
      user.save
    end

    redirect_to users_path
  end

  def destroy
    @project = current_user.projects.find(params[:project_id])
    @user = @project.users.find(params[:id])
    @project.users.delete(@user)
    redirect_to project_users_url(@project)
  end

end
