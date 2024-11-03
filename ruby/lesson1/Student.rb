require 'date'

class Student
  @@students = []

  attr_accessor :surname, :name, :date_of_birth

  def initialize(surname, name, date_of_birth)
    @date_of_birth = validate_date_of_birth(date_of_birth)
    validate_age
    @surname = surname
    @name = name
    add_student
  end

  def calculate_age
    today = Date.today
    birth_day_this_year = Date.new(today.year, @date_of_birth.month, @date_of_birth.day)

    if today >= birth_day_this_year
      today.year - @date_of_birth.year
    else
      today.year - @date_of_birth.year - 1
    end
  end

  def add_student
    is_duplicate = @@students.any? { |student| student.surname == surname && student.name == name && student.date_of_birth == date_of_birth }

    if is_duplicate
      raise ArgumentError, 'This student has already been added.'
    else
      @@students << self
    end
  end

  def self.remove_student(student)
    @@students.delete(student)
  end

  def self.get_students_by_age(age)
    @@students.select { |student| student.calculate_age == age }
  end

  def self.get_students_by_name(name)
    @@students.select { |student| student.name == name }
  end

  def self.all_students
    @@students
  end

  private

  def validate_date_of_birth(date_of_birth)
    raise ArgumentError, 'Date of birth must be in the past.' if date_of_birth > Date.today
    date_of_birth
  end

  def validate_age
    age = calculate_age
    raise ArgumentError, 'Student age must be between 5 and 100 years.' unless age.between?(5, 100)
  end
end

Student.new('Pavlo', 'Borysov', Date.new(2003, 11, 13))
Student.new('Vasyl', 'Vengrov', Date.new(1995, 2, 2))