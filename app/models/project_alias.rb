class ProjectAlias < ActiveRecord::Base
  unloadable

  ALIAS_MAX_LENGTH = 100

  belongs_to :project
  validates_presence_of :project, :alias
  validates_uniqueness_of :alias
  validates_length_of :alias, :in => 1..ALIAS_MAX_LENGTH
  # donwcase letters, digits, dashes but not digits only
  validates_format_of :alias, :with => /\A(?!\d+$)[a-z0-9\-_]*\z/, :if => Proc.new { |a| a.alias_changed? }
  # reserved words
  validates_exclusion_of :alias, :in => %w( new )

  validates_each :alias do |record, attr, value|
    record.errors.add(attr, 'has already been taken') unless Project.where(:identifier => value).empty?
  end
end
