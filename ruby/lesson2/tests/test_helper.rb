
require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use! Minitest::Reporters::HtmlReporter.new(
  reports_dir: 'reports',
  color: true,
  mode: :clean
)