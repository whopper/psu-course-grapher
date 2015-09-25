#! /Users/will/.rbenv/shims/ruby

require 'nokogiri'
require 'open-uri'
require './course.rb'

def get_detailed_course_info(course)
  course_info = Nokogiri::HTML(open("http://pdx.smartcatalogiq.com" + course.url))
  course.description=(course_info.css('div.desc')[0].children.text).strip

  if (course_info.css('div.credits')[0])
    course.credits=(course_info.css('div.credits')[0].children.text).strip
  else
    course.credits=(course_info.css('div#credits')[0].children.text).strip
  end

  course_info.css('a.sc-courselink').each do |link|
    course.add_prereq(link.children.text)
  end
end

def get_courses_from_html
  course_list = Array.new
  bulletin = Nokogiri::HTML(open("http://pdx.smartcatalogiq.com/en/2015-2016/Bulletin/Courses/CS-Computer-Science"))

  courses = bulletin.css('ul.sc-child-item-links')[0].children
  courses.each do |c|
    course = Course.new
    course.name=(c.children[0].children[0].text)
    course.url=(c.children[0].attributes['href'].value)
    get_detailed_course_info(course)
    course_list << course
  end

  course_list
end

def print_courses(course_list)
  course_list.each do |course|
    puts course.name
    puts course.url
    puts course.description
    puts course.credits
    puts course.prereqs
    puts "==========="
  end
end

def main
  course_list = get_courses_from_html
  print_courses(course_list)
end

main
