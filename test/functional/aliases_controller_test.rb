require File.expand_path('../../test_helper', __FILE__)

class AliasesControllerTest < ActionController::TestCase
  fixtures :projects
  fixtures :users
  fixtures :roles
  fixtures :members
  fixtures :member_roles

  def test_new
    grant_permission
    get :new, :project_id => @project.identifier

    assert_response :success
    assert_template 'new'
    assert_equal @project, assigns(:project)
    assert assigns(:project_alias)
    assert_equal @project, assigns(:project_alias).project
  end

  def test_requires_project_id
    grant_permission
    get :new, :project_id => '0'
    assert_response :missing
  end

  def test_requires_edit_project_permission
    remove_permission
    get :new, :project_id => @project.identifier
    assert_response 403
  end

  def test_create
    grant_permission
    assert_difference('ProjectAlias.count') do
      post :create, :project_id => @project.identifier, :project_alias => { :alias => 'project_alias' }
    end
    assert_redirected_to :controller => :projects, :action => :settings, :id => @project.identifier
    assert_equal 'project_alias', ProjectAlias.last.alias
    assert_equal @project, ProjectAlias.last.project
  end

  def test_create_invalid
    grant_permission
    assert_difference('ProjectAlias.count', 0) do
      post :create, :project_id => @project.identifier, :project_alias => { :alias => @project.identifier }
    end
    assert_response 200
    assert_template :new
    assert_equal @project.identifier, assigns(:project_alias).alias
    assert_equal @project, assigns(:project_alias).project
  end

  def setup
    @project = Project.first
    @user = @project.users.where(:admin => :false).first
    @request.session[:user_id] = @user.id
  end

  def grant_permission
    get_role.add_permission! :edit_project
  end

  def remove_permission
    get_role.remove_permission! :edit_project
  end

  def get_role
    @user.roles_for_project(@project).first
  end
end
