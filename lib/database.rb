require 'sqlite3'
require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/courses.db")

class Course_row
  include DataMapper::Resource
  property :id, Serial
  property :program, Text, :required => true
  property :name, Text, :required => true
  property :url, Text, :required => true
  property :desc, Text, :required => false
  property :credits, Text, :required => false
  #property :prereqs, Text, :required => false # Todo: probably want multiple rows
end

class Prereq
  include DataMapper::Resource
  property :id, Serial
  property :parent_name, Text, :required => true
  property :parent_url, Text, :required => true
  property :prereq_name, Text, :required => true
  property :prereq_url, Text, :required => true
end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the tables
Course_row.auto_upgrade!
Course_row.raise_on_save_failure = true

Prereq.auto_upgrade!
Prereq.raise_on_save_failure = true
