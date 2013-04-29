#encoding: UTF-8
require 'spec_helper'

describe "Test create with social account function in gamer model" do
  it "saves the new gamer in the database with the is_local function set to false and returns true" do
    gamer, was_saved = Gamer.create_with_social_account(
      "amr123456@fakemail.com", "AMR123456", "male", "1993-11-23", "Egypt", "School")
    expect(was_saved).to eq(true)
    expect(gamer.is_local).to eq(false)
  end

  it "does not save the gamer since the validations do not pass" do
    gamer, was_saved = Gamer.create_with_social_account(
      "amr123456@fakemail.com", "AMR123456", "male", "1993-11-23", "Egypt", "Schoool")
    expect(was_saved).to eq(false)
    expect(gamer.id).to eq(nil)
  end

end