class Course
  attr_accessor :program, :name, :url, :description, :prereqs, :credits

  def initialize
    @prereqs = Array.new
  end

  def add_prereq(course)
    @prereqs << course
  end
end
