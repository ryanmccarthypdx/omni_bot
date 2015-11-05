require 'spec_helper'

describe "the user creation process" do

  it "should display the new user form" do
    visit '/'
    expect(page).to have_content "Create account"
    expect(page).to have_content "New user sign up"
    expect(page).to have_content "Mobile Phone:"
    expect(page).to have_content "Zip Code:"
    expect(page).to have_content "Password:"
    expect(page).to have_content "Confirm Password:"
  end

  it "should throw a phone-specific error if you attempt to create a user without a phone number" do
    visit '/'
    click_button "Create account"
    expect(page).to have_content("Phone number is not a valid US mobile number!")
  end

  it "should throw a password-specific error if you attempt to create a user without a password" do
    visit '/'
    fill_in "create_phone", with: ENV["KNOWN_REAL_CELL_NUMBER"]
    click_button "Create account"
    expect(page).to have_content("Password can't be blank")
  end

  it "should throw a confirm_password-specific error if you attempt to create a user with a wrong confirmation" do
    visit '/'
    fill_in "create_phone", with: ENV["KNOWN_REAL_CELL_NUMBER"]
    fill_in "create_password", with: "password"
    fill_in "password_confirmation", with: "notpassword"
    click_button "Create account"
    expect(page).to have_content("Password confirmation doesn't match Password")
  end

  it "should redirect to confirmation page if you put in valid info" do
    visit '/'
    fill_in "create_phone", with: ENV["KNOWN_REAL_CELL_NUMBER"]
    fill_in "create_password", with: "password"
    fill_in "password_confirmation", with: "password"
    click_button "Create account"
    expect(page).to have_content "We have sent a confirmation code to your phone"
  end
end
