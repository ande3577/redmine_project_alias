require File.expand_path('../../test_helper', __FILE__)

class ProjectTest < ActiveSupport::TestCase
  fixtures :projects 
  
  def setup
    @project = Project.first
    @alias = ProjectAlias.new(:project => @project, :alias => 'project_alias')
    assert @alias.save
  end
  
  def test_destroy_project
    assert_difference ['ProjectAlias.count'], -1 do
      @project.destroy()
    end
  end

  def test_require_identifier_to_be_unique_with_respect_to_alias
    assert !Project.new(:identifier => @alias.alias, :name => 'New Project Name').save
  end

  def test_create_new_project
    assert Project.new(:identifier => 'new_project_identifier', :name => 'New Project Name').save
  end
  
  def test_find_project_by_identifier
    assert_equal @project, Project.find(@project.identifier)
  end

  def test_find_project_by_alias
    assert_equal @project, Project.find(@alias.alias) 
  end

end
