require File.expand_path('../../../lib/course.rb', __FILE__)

describe Course do
  subject { described_class.new }

  ['name', 'url', 'description', 'prereqs', 'credits'].each do |attr|
    it "should have a settable and retrievable #{attr} attribute" do
      subject.send("#{attr}=", "foo")
      expect(subject.send(attr)).to eq('foo')
    end
  end

  it 'should append items to the course_list with add_prereq' do
    pre_course = Course.new
    pre_course.name = "prereq"
    subject.add_prereq(pre_course)
    expect(subject.prereqs).to eq([pre_course])
  end
end
