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

  it "should throw an error if you attempt to create a user without a phone number" do
    visit '/'
    click-button "Create account"
    expect(page).to have_errors
  end
end