#! /Users/will/.rbenv/shims/ruby

require File.expand_path('../scraper.rb', __FILE__)

# For testing
if ARGV[0]
  course_list = Scraper.scrape_program(ARGV[0])
  Scraper.print_courses(course_list)
end
