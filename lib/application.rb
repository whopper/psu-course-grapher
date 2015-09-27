#! /Users/will/.rbenv/shims/ruby

require File.expand_path('../scraper.rb', __FILE__)
require File.expand_path('../database.rb', __FILE__)

def populate_databases
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/courses.db")
  course_list = Scraper.scrape_program('CS-Computer-Science')

  course_list.each do |course|
    co = Course_row.new
    co.program = course.program
    co.name    = course.name
    co.url     = course.url
    co.desc    = course.description
    co.credits = course.credits

    course.prereqs.each do |prereq|
      pr = Prereq.new
      pr.parent_name = course.name
      pr.parent_url = course.url
      pr.prereq_name = prereq.name
      pr.prereq_url = prereq.url
      pr.save
    end

    co.save
  end
end

def print_database_content
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/courses.db")
  @courses = Course_row.all
  @courses.each do |c|
    puts "Course: #{c.name}"
    puts "Program: #{c.program}"
    puts "URL: #{c.url}"
    puts "Description: #{c.desc}"
    puts "Credits: #{c.credits}"
    @prereqs = Prereq.all(:parent_name => c.name)
    puts "Prerequisits" if @prereqs.length >= 1
    @prereqs.each do |p|
        puts p.prereq_name
    end

    puts "\n"
  end

=begin
  @prereqs = Prereq.all
  @prereqs.each do |p|
    puts "Parent: #{p.parent_name}"
    #puts p.parent_url
    puts "Prereq name: #{p.prereq_name}"
    puts "Prereq URL: #{p.prereq_url}"
  end
=end
end

# For testing
if ARGV[0] == "populate"
  populate_databases
else
  print_database_content
end
