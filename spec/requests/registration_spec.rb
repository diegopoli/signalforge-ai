require "rails_helper"

RSpec.describe "Registration", type: :request do
  let(:headers) do
    {
      "HOST" => "localhost",
      "User-Agent" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36"
    }
  end

  it "shows the password length requirement on the sign up page" do
    get new_user_registration_path, headers: headers

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Use at least 8 characters.")
  end
end