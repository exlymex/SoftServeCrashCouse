require 'minitest/autorun'
require 'minitest/spec'
require 'date'
require_relative '../app/student'
require_relative 'test_helper'

describe Student do

  before do
    Student.class_variable_set(:@@students, [])
  end

  let(:student) { Student.new('John', 'Doe', Date.new(Date.today.year - 5, Date.today.month, Date.today.day)) }
  let(:student_older) { Student.new('Jane', 'Smith', Date.new(Date.today.year - 20, Date.today.month, Date.today.day)) }

  it "#initialize sets correct attributes" do
    expect(student.surname).must_equal 'John'
    expect(student.name).must_equal 'Doe'
    expect(student.date_of_birth).must_equal Date.new(Date.today.year - 5, Date.today.month, Date.today.day)
  end

  it "#calculate_age returns the correct age" do
    expect(student.calculate_age).must_equal 5
    expect(student_older.calculate_age).must_equal 20
  end

  it "#get_students_by_age returns students with the specified age" do
    Student.class_variable_set(:@@students, [student, student_older])
    students_age_5 = Student.get_students_by_age(5)
    expect(students_age_5).must_include student
  end

  it "#get_students_by_age does not return students of a different age" do
    Student.class_variable_set(:@@students, [student, student_older])
    students_age_20 = Student.get_students_by_age(20)
    expect(students_age_20).wont_include student
  end

  describe "#get_students_by_name" do
    before do
      Student.class_variable_set(:@@students, [student, student_older])
    end

    it "returns students with the specified name" do
      students_named_smith = Student.get_students_by_name('Smith')
      expect(students_named_smith).must_include student_older
    end

    it "does not return students with a different name" do
      students_named_john = Student.get_students_by_name('John')
      expect(students_named_john).wont_include student
    end
  end
end

describe "Negative tests for Student class" do
  it "#must raise error for future birth date" do
    expect { Student.new("Future", "Person", Date.today + 1) }.must_raise ArgumentError
  end

  it "#must raise error for duplicate student" do
    Student.class_variable_set(:@@students, [])
    Student.new("John", "Doe", Date.new(Date.today.year - 5, Date.today.month, Date.today.day))
    expect { Student.new("John", "Doe", Date.new(Date.today.year - 5, Date.today.month, Date.today.day)) }.must_raise ArgumentError
  end
end
