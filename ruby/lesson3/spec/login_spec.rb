require 'selenium-webdriver'
require 'capybara/rspec'
require_relative 'spec_helper'
require_relative 'login_helper'

VALID_USERS = %w[standard_user visual_user].freeze
LOCKED_USERS = %w[error_user locked_out_user].freeze

RSpec.describe 'Login Test' do
  include Capybara::DSL
  include LoginHelper

  before(:each) do
    visit @url
  end

  context "Login with username and password" do
    VALID_USERS.each do |username|
      it "should be able to login with the username and password" do
        login(username, PASSWORD)
        expect(account_header.text).to eql SUCCESS_LOGIN
      end
    end
  end

  context "Login with locked user" do
    LOCKED_USERS.each do |username|
      it "should not allow login with locked user #{username}" do
        login(username, PASSWORD)
        expect(error_message.text).to include LOCKED_USER_ERROR
      end
    end
  end

end