class ProjectsController < ApplicationController

  # GET /projects
  # GET /projects.xml
  def index
    if current_user.is? :admin
      @projects = Project.all
    else
      @projects = current_user.projects
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    if current_user.is? :admin
      @project = Project.find(params[:id])
    else
      @project = current_user.projects.find(params[:id])
    end
    @story = @project.stories.build

    respond_to do |format|
      format.html # show.html.erb
      format.js   { render :json => @project }
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = current_user.projects.find(params[:id])
    authorize! :manage, @project
    @project.users.build
  end

  # POST /projects
  # POST /projects.xml
  def create
    authorize! :manage, Project
    @project = current_user.projects.build(allowed_params)
    @project.users << current_user

    respond_to do |format|
      if @project.save
        format.html { redirect_to(@project, :notice => t('projects.project was successfully created')) }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project = current_user.projects.find(params[:id])
    @project = Project.find(params[:id]) if (can? :manage, User) && @project.nil?
    if params[:user_id]
      if params[:make_admin]
        @project.admins << User.find(params[:user_id])
      elsif params[:remove_admin]
        @project.admins.delete(User.find(params[:user_id]))
      end
      redirect_to project_users_url(@project)
    else
      if params[:project] && params[:project][:new_api_token]
        params.delete(:project)
        params[:project] = {:api_token => SecureRandom.hex}
      end
      respond_to do |format|
        if @project.update_attributes(allowed_params)
          format.html { redirect_to(@project, :notice => t('projects.project was successfully updated')) }
          format.xml  { head :ok }
          format.json { render :json => @project }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project = current_user.projects.find(params[:id])
    authorize! :manage, @project
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end

  protected

  def allowed_params
    params.fetch(:project,{}).permit(:name, :point_scale, :default_velocity, :start_date, :iteration_start_day, :iteration_length, :api_token)
  end

end
