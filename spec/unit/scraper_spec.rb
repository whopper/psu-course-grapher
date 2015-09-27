require File.expand_path('../../../lib/scraper.rb', __FILE__)

describe Scraper do
  subject { described_class.new }

  context 'collecting all courses from program bulletin' do
    it 'should determine all course names' do
      parsed_html = subject.parse_html(File.expand_path("spec/fixtures/program_bulletin.html"))
      courses = subject.scrape_course_list_from_html(parsed_html)
      expect(courses.length).to eq(2)
      expect(courses[0].name).to eq('CS 105 Computing Fundamentals I')
      expect(courses[1].name).to eq('CS 106 Computing Fundamentals II')
    end

    it 'should determine all course URLs' do
      parsed_html = subject.parse_html(File.expand_path("spec/fixtures/program_bulletin.html"))
      courses = subject.scrape_course_list_from_html(parsed_html)
      expect(courses.length).to eq(2)
      expect(courses[0].url).to eq('http://pdx.smartcatalogiq.com/en/CS-105')
      expect(courses[1].url).to eq('http://pdx.smartcatalogiq.com/en/CS-106')
    end

    it 'should find the course description' do
      parsed_html = subject.parse_html(File.expand_path("spec/fixtures/course_detail.html"))
      expect(subject.scrape_course_description(parsed_html)).to eq('This is the course description!')
    end

    it 'should find the number of credits provided by the course' do
      parsed_html = subject.parse_html(File.expand_path("spec/fixtures/course_detail.html"))
      expect(subject.scrape_course_credits(parsed_html)).to eq('4')
    end

    it 'should find all course prerequisites' do
      parsed_html = subject.parse_html(File.expand_path("spec/fixtures/course_detail.html"))
      prereqs = subject.scrape_course_prereqs(parsed_html)
      expect(prereqs.length).to eq(1)
      expect(prereqs[0].name).to eq('CS 162')
      expect(prereqs[0].url).to eq('http://pdx.smartcatalogiq.com/en/CS-162')
    end
  end
end
