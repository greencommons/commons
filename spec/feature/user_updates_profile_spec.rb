require 'rails_helper'

RSpec.feature 'Update Profile' do
  scenario 'users can update their profile' do
    fake_time = Time.now
    allow(Time).to receive(:now).and_return(fake_time)

    user = feature_login

    click_link 'My Profile'
    expect(find('h1')).to have_content('My Profile')
    within("#edit_user_#{user.id}") do
      fill_in 'user[first_name]', with: 'John'
      fill_in 'user[last_name]', with: 'Wick'
      fill_in 'user[email]', with: 'johnwick@example.com'
      fill_in 'user[bio]', with: 'Something interesting.'
      attach_file 'user[avatar]', Rails.root.join('spec/support/samples/horse.jpg')
      click_on 'UPDATE'
    end

    expect(page).to have_content('Profile updated.')
    user = user.reload

    expect(user.first_name).to eq 'John'
    expect(user.last_name).to eq 'Wick'
    expect(user.email).to eq 'johnwick@example.com'
    expect(user.bio).to eq 'Something interesting.'
    expect(user.avatar.url).to eq "/uploads/user/avatar/#{user.id}/john-wick-avatar-#{fake_time.to_i}"

    expect(page).to have_selector("img[src='#{user.avatar.url}']")
  end

  scenario 'users can update their password' do
    user = feature_login
    original = user.encrypted_password

    click_link 'My Profile'
    expect(page).to have_current_path(profile_path)
    click_link 'Change My Password'

    within("#edit_user_#{user.id}") do
      fill_in 'user[current_password]', with: 'thecommons'
      fill_in 'user[password]', with: 'commons2'
      fill_in 'user[password_confirmation]', with: 'commons2'
      click_on 'UPDATE'
    end

    expect(page).to have_content('Password updated.')
    expect(user.reload.encrypted_password).not_to eq original
  end
end
