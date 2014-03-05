module ProjectAliasProjectPatch
  def self.included(base)
    unloadable
    
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
    base.class_eval do
      has_many :project_aliases, :dependent => :destroy

      validates_each :identifier do |record, attr, value|
        record.errors.add(attr, 'has already been taken') unless ProjectAlias.where(:alias => value).empty?
      end

      class << Project
        alias_method_chain :find, :project_alias
      end
    end
  end
  
  module ClassMethods
    def find_with_project_alias(*args)
      begin
        find_without_project_alias(*args)
      rescue ActiveRecord::RecordNotFound
        if args.first && args.first.is_a?(String) && !args.first.match(/^\d*$/)
          project_alias = ProjectAlias.where(:alias => args.first).first
          raise ActiveRecord::RecordNotFound, "Couldn't find Project with identifier=#{args.first}" if project_alias.nil?
          project_alias.project
        end
      end
    end
  end
  
  module InstanceMethods
  end
  
end

Project.send(:include, ProjectAliasProjectPatch)