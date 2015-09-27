#! /Users/will/.rbenv/shims/ruby

require 'nokogiri'
require 'open-uri'
require File.expand_path('../course.rb', __FILE__)

class Scraper

  # method: scrape_course_list_from_html
  # Creates a list of courses found on a main program page.
  # @param [String] parsed_html Nokogiri-parsed html from the main program page.
  # @return [Array<Course>] course_list An array of course objects.
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

  # method: scrape_course_description
  # Scrapes the detailed course info page of a course for the class description.
  # @param [String] parsed_html Nokogiri-parsed html of the detailed class info page.
  # @return [String] description The description text for the course.
  def scrape_course_description(parsed_html)
    parsed_html.css('div.desc')[0].children.text.strip
  end

  # method: scrape_course_credits
  # Scrapes the detailed course info page of a course for number of course credits.
  # @param [String] parsed_html Nokogiri-parsed html of the detailed class info page.
  # @return [String] credits The number of credits.
  def scrape_course_credits(parsed_html)
    if (parsed_html.css('div.credits')[0])
      parsed_html.css('div.credits')[0].children.text.strip
    else
      parsed_html.css('div#credits')[0].children.text.strip
    end
  end

  # method: scrape_course_prereqs
  # Scrapes the detailed course info page of a course for prerequisite classes.
  # @param [String] parsed_html Nokogiri-parsed html of the detailed class info page.
  # @return [Array<String>] Array of course names which are prereqs.
  # TODO: Make sure we can link these strings to the courses themselves.
  # TODO: Have to tell the difference between co-preqeqs, prereqs, recommended, etc.
  def scrape_course_prereqs(parsed_html)
    prereqs = Array.new

    parsed_html.css('a.sc-courselink').each do |link|
      prereqs << link.children.text
    end

    prereqs
  end

  # method parse_html
  # Parses the HTML in a given source, file or URL, via Nokogiri
  # @param [String] source The file or URL to parse.
  # @return [Nokogiri::HTML] parsed_html The parsed HTML in a Nokogiri HTML object.
  def parse_html(source)
    Nokogiri::HTML(open(source))
  end

  # method print_courses
  # Prints all course info from a provided list of courses.
  # @param [Array<Course>] course_list The list of courses.
  # @return None.
  def self.print_courses(course_list)
    course_list.each do |course|
      puts course.name
      puts course.url
      puts course.description
      puts course.credits
      puts course.prereqs
      puts "==========="
    end
  end

  # method scrape_program
  # Uses Scraper API to collect all course info about all courses listed on a program
    #bulletin page.
  # @param [String] program The name of the program, in the form of "Abr-Full_name"
  # @return [Array<Course>] course_list A list of courses in the program.
  def self.scrape_program(program)
    scraper = Scraper.new
    parsed_html = scraper.parse_html("http://pdx.smartcatalogiq.com/en/2015-2016/Bulletin/Courses/#{program}")
    course_list = scraper.scrape_course_list_from_html(parsed_html)

    course_list.each do |course|
      parsed = scraper.parse_html(course.url)
      course.description = scraper.scrape_course_description(parsed)
      course.credits = scraper.scrape_course_credits(parsed)
      scraper.scrape_course_prereqs(parsed).each do |prereq|
        course.add_prereq(prereq)
      end
    end

    course_list
  end
end
