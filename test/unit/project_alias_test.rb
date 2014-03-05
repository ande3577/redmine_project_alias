require File.expand_path('../../test_helper', __FILE__)

class ProjectAliasTest < ActiveSupport::TestCase
  fixtures :projects

  def test_create
    assert @project_alias.save
  end

  def test_requires_project
    @project_alias.project = nil
    assert !@project_alias.save
  end

  def test_invalid_alias
    check_invalid_alias(nil)
    check_invalid_alias('')
    check_invalid_alias('alias with space')
  end

  def test_alias_cannot_be_a_project_identifier
    check_invalid_alias(@project.identifier)
  end

  def test_destroy_alias
    assert_difference ['Project.count'], 0 do
      @project_alias.destroy()
    end
  end

  def setup
    @project = Project.first
    @project_alias = ProjectAlias.new(:project => @project, :alias => 'project_alias')
  end

  private
  def check_invalid_alias(alias_name)
    @project_alias.alias = alias_name
    assert !@project_alias.save
  end
end
