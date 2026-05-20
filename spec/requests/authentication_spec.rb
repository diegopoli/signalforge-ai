require "rails_helper"

RSpec.describe "Authentication", type: :request do
  let(:headers) do
    {
      "HOST" => "localhost",
      "User-Agent" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36"
    }
  end

  it "requires auth and supports signed-in access" do
    user = User.create!(
      email: "auth-user@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    get dashboard_path, headers: headers
    expect(response).to redirect_to(new_user_session_path)

    sign_in(user)

    get dashboard_path, headers: headers

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Dashboard")
  end
end
