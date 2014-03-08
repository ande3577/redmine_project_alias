class ProjectAliasProjectHook < Redmine::Hook::ViewListener
 render_on :view_projects_form, :partial => "project_alias/project_settings" 
end
