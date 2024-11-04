require 'minitest/autorun'
require 'minitest/reporters'
require 'date'
require_relative '../app/student'

Minitest::Reporters.use! [
                           Minitest::Reporters::SpecReporter.new,
                           Minitest::Reporters::HtmlReporter.new(
                             reports_dir: 'reports',
                             report_filename: 'test_results.html',
                             clean: true,
                             add_timestamp: true
                           )
                         ]

FIRST_STUDENT_AGE = 15
SECOND_STUDENT_AGE = 20
THIRD_STUDENT_AGE = 30

class StudentTest < Minitest::Test
  def setup
    Student.class_variable_set(:@@students, [])

    @student1 = Student.new('Pavlo', 'Borysov', Date.new(Date.today.year - FIRST_STUDENT_AGE, Date.today.month, Date.today.day))
    @student2 = Student.new('Smith', 'Jane', Date.new(Date.today.year - SECOND_STUDENT_AGE, Date.today.month, Date.today.day))
    @student3 = Student.new('Doe', 'John', Date.new(Date.today.year - THIRD_STUDENT_AGE, Date.today.month, Date.today.day))
  end

  def test_student_initialization
    assert_equal 'Pavlo', @student1.surname
    assert_equal 'Borysov', @student1.name
    assert_equal Date.new(Date.today.year - FIRST_STUDENT_AGE, Date.today.month, Date.today.day), @student1.date_of_birth
  end

  def test_calculate_age
    assert_equal FIRST_STUDENT_AGE, @student1.calculate_age , "Expected age to be #{FIRST_STUDENT_AGE} for @student1"
    assert_equal SECOND_STUDENT_AGE, @student2.calculate_age , "Expected age to be #{SECOND_STUDENT_AGE} for @student1"
    assert_equal THIRD_STUDENT_AGE, @student3.calculate_age, "Expected age to be #{THIRD_STUDENT_AGE} for @student1"
  end

  def test_raises_error_when_birth_date_today
    error = assert_raises(ArgumentError) { Student.new("FirstName", "LastName", Date.today) }
    assert_equal "Date of birth must be in the past.", error.message
  end

  def test_duplicate_student
    error = assert_raises(ArgumentError) do
      Student.new('Doe', 'John', Date.new(Date.today.year - THIRD_STUDENT_AGE, Date.today.month, Date.today.day))
    end
    assert_equal "This student has already been added.", error.message
  end

  def test_get_students_by_age
    students_age_15 = Student.get_students_by_age(FIRST_STUDENT_AGE)
    students_age_20 = Student.get_students_by_age(SECOND_STUDENT_AGE)

    assert_includes students_age_15, @student1, "Expected @student1 to be in the list of students with age #{FIRST_STUDENT_AGE}"
    assert_includes students_age_20, @student2, "Expected @student2 to be in the list of students with age #{SECOND_STUDENT_AGE}"
    refute_includes students_age_15, @student2, "Expected @student2 not to be in the list of students with age #{FIRST_STUDENT_AGE}"
  end

  def test_get_students_by_name
    students_named_john = Student.get_students_by_name('John')
    students_named_jane = Student.get_students_by_name('Jane')

    assert_includes students_named_jane, @student2, "Expected @student2 to be in the list of students named Jane"
    assert_includes students_named_john, @student3, "Expected @student3 to be in the list of students named John"
    refute_includes students_named_john, @student2, "Expected @student2 not to be in the list of students named John"
  end

  def test_all_students
    all_students = Student.all_students
    assert_equal [@student1, @student2, @student3], all_students, "Expected all_students to contain @student1, @student2, and @student3"
  end

  def test_remove_student
    Student.remove_student(@student1)
    all_students = Student.all_students

    refute_includes all_students, @student1, "Expected @student1 to be removed from all_students"
    assert_includes all_students, @student2, "Expected @student2 to still be in all_students"
    assert_includes all_students, @student3, "Expected @student3 to still be in all_students"
  end

  def test_invalid_date_of_birth
    error = assert_raises(ArgumentError) { Student.new('Invalid', 'Student', Date.today + 1) }
    assert_equal "Date of birth must be in the past.", error.message
  end

  def teardown
    Student.class_variable_set(:@@students, [])
  end
end
