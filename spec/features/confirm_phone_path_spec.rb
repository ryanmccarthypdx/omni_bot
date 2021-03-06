require 'spec_helper'

describe "the phone confirmation process" do
  let(:user) { FactoryGirl.create(:user) }

  before do
    page.set_rack_session(:id => user.id)
  end

  it "should display the confirmation input form correctly" do
    visit "/confirm_phone"
    expect(page).to have_content("We have sent a confirmation code to your phone")
    expect(page).to have_content("Submit")
    expect(page).to have_content("Resend Code")
  end

  it "should resend the confirmation code when 'Resend Code' is clicked" do
    original_code = user.confirmation_code
    visit "/confirm_phone"
    click_on("Resend Code")
    expect(user.reload.confirmation_code.eql?(original_code)).to be false
  end

  it "should flash the too many confirmations error if MAX_CONFIRMATIONS has been reached" do
    user.total_confirmations = MAX_CONFIRMATIONS
    user.save
    visit "/confirm_phone"
    click_on("Resend Code")
    expect(page).to have_content("This number has had too many confirmation attempts.")
  end

  it "should flash the incorrect-input error if you submit with no code or the wrong code inputted" do
    visit "/confirm_phone"
    click_button("Submit")
    expect(page).to have_content("The code you entered is not correct")
  end

  it "should flash the expired error if code is older than CODE_VALID_TIME" do
    user.confirmation_time -= ((CODE_VALID_TIME * 60) + 1)
    user.save
    visit "/confirm_phone"
    fill_in "phone_confirm", with: user.confirmation_code
    click_button("Submit")
    expect(page).to have_content("This code has expired. Please click 'Resend Code' below")
  end

  it "should redirect to the services page if phone code is confirmed" do
    visit "/confirm_phone"
    fill_in "phone_confirm", with: user.confirmation_code
    click_button("Submit")
    expect(page).to have_content("Available Services")
  end
end
