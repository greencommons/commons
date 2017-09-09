RSpec.shared_examples 'the user is not authenticated' do
  it 'redirects to the login page' do
    response.should redirect_to(new_user_session_path)
  end
end
