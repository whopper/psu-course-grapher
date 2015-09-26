#! /Users/will/.rbenv/shims/ruby

require 'nokogiri'
require 'open-uri'
require File.expand_path('../course.rb', __FILE__)

class Scraper
  def scrape_course_list_from_html(parsed_html)
    course_list = Array.new

    courses = parsed_html.css('ul.sc-child-item-links')[0].children
    courses.each do |co|
      course = Course.new
      course.name = co.children[0].children[0].text
      course.url = 'http://pdx.smartcatalogiq.com' + co.children[0].attributes['href'].value
      course_list << course
    end

    course_list
  end

  def scrape_course_description(parsed_html)
    parsed_html.css('div.desc')[0].children.text.strip
  end

  def scrape_course_credits(parsed_html)
    if (parsed_html.css('div.credits')[0])
      parsed_html.css('div.credits')[0].children.text.strip
    else
      parsed_html.css('div#credits')[0].children.text.strip
    end
  end

  def scrape_course_prereqs(parsed_html)
    prereqs = Array.new

    parsed_html.css('a.sc-courselink').each do |link|
      prereqs << link.children.text
    end

    prereqs
  end

  def parse_html(source)
    Nokogiri::HTML(open(source))
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
end

def main
  scraper = Scraper.new
  parsed_html = scraper.parse_html("http://pdx.smartcatalogiq.com/en/2015-2016/Bulletin/Courses/CS-Computer-Science")
  course_list = scraper.scrape_course_list_from_html(parsed_html)

  course_list.each do |course|
    parsed = scraper.parse_html(course.url)
    course.description = scraper.scrape_course_description(parsed)
    course.credits = scraper.scrape_course_credits(parsed)
    scraper.scrape_course_prereqs(parsed).each do |prereq|
      course.add_prereq(prereq)
    end
  end

  scraper.print_courses(course_list)
end

if ARGV[0] == 'populate'
  main
end
