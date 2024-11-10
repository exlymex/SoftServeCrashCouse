# frozen_string_literal: true

require 'selenium-webdriver'
require 'capybara/rspec'
require_relative 'spec_helper'

ITEMS = [
  { add_item: "#add-to-cart-sauce-labs-backpack", remove_item: "#remove-sauce-labs-backpack" },
  { add_item: "#add-to-cart-sauce-labs-bolt-t-shirt", remove_item: "#remove-sauce-labs-bolt-t-shirt" }
].freeze

VALID_USER = 'standard_user'
ADDED_CART_COUNT = "2"

RSpec.describe 'Products Test' do
  include Capybara::DSL
  include LoginHelper

  before(:each) do
    visit @url
    login(VALID_USER, PASSWORD)
    expect(account_header.text).to eql SUCCESS_LOGIN
  end

  def card_badge
    find('[data-test="shopping-cart-badge"]')
  end

  def add_item_to_cart(item)
    add_button = find(item[:add_item])
    expect(add_button.text).to eql "Add to cart"
    add_button.click
  end

  def remove_item_from_cart(item)
    remove_button = find(item[:remove_item])
    expect(remove_button.text).to eql "Remove"
    remove_button.click
  end

  context "Add 2 items to cart" do
    it "should be able to add items to cart" do
      ITEMS.each { |item| add_item_to_cart(item) }
      expect(card_badge.text).to eql ADDED_CART_COUNT
    end
  end

  context "Remove items from cart" do
    it "should be able to remove items from cart" do
      ITEMS.each do |item|
        add_item_to_cart(item)
      end
      ITEMS.each do |item|
        remove_item_from_cart(item)
      end
      expect(page).not_to have_selector('[data-test="shopping-cart-badge"]')
    end
  end


end