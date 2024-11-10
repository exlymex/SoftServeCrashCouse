SUCCESS_LOGIN = "Products"
LOCKED_USER_ERROR = "Epic sadface: Sorry, this user has been locked out."
PASSWORD = "secret_sauce"

module LoginHelper
  def login(username, password)
    fill_in 'user-name', visible: true, with: username
    fill_in 'password', visible: true, with: password
    click_button 'login-button'
  end

  def account_header
    find('[data-test="title"]')
  end

  def error_message
    find('[data-test="error"]')
  end
end
