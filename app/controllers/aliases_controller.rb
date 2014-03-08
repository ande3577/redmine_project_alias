class AliasesController < ApplicationController
  unloadable

  before_filter :find_project
  before_filter :authorize_user

  def new
    @project_alias = ProjectAlias.new(:project => @project)
  end

  def create
    @project_alias = ProjectAlias.new(:project => @project, :alias => params[:project_alias][:alias])
    if @project_alias.save
      return redirect_to :controller => :projects, :action => :settings, :id => @project.identifier
    end
    render :new
  end

  private
  def find_project
    @project = Project.find(params[:project_id])
    render_404 if not @project
  end

  def authorize_user
    deny_access unless User.current.allowed_to?(:edit_project, @project)
  end
end
