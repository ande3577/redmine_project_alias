module ProjectAliasProjectPatch
  def self.included(base)
    unloadable
    
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
    base.class_eval do
      has_many :project_aliases, :dependent => :destroy
      belongs_to :default_alias, :class_name => 'ProjectAlias'
      safe_attributes 'default_alias_id'

      validates_each :identifier do |record, attr, value|
        record.errors.add(attr, 'has already been taken') unless ProjectAlias.where(:alias => record.identifier_attribute).empty?
      end

      class << Project
        alias_method_chain :find, :project_alias
      end

      def identifier
        return default_alias.alias if default_alias
        identifier_attribute
      end

      def identifier_attribute
        read_attribute(:identifier)
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