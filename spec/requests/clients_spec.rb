require "rails_helper"

RSpec.describe "Clients", type: :request do
  let(:headers) do
    {
      "HOST" => "localhost",
      "User-Agent" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36"
    }
  end

  it "supports client CRUD happy path" do
    user = User.create!(
      email: "crm-user@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    sign_in(user)

    get new_client_path, headers: headers
    csrf_token = response.body[/name="csrf-token" content="([^"]+)"/, 1]
    csrf_headers = headers.merge("X-CSRF-Token" => csrf_token)

    post clients_path,
      params: {
        client: {
          full_name: "Jane Investor",
          email: "jane.investor@example.com",
          phone: "+1 555 100 2000",
          risk_profile: "Balanced",
          lifecycle_stage: "active",
          profile_notes: "Prefers tax-efficient portfolios"
        }
      },
      headers: csrf_headers

    expect(response).to have_http_status(:found), "Create failed with status=#{response.status}. Body=#{response.body}"
    expect(user.clients.where(email: "jane.investor@example.com").count).to eq(1)

    client = user.clients.find_by!(email: "jane.investor@example.com")
    expect(response).to redirect_to(client_path(client))

    get client_path(client), headers: headers
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Jane Investor")

    patch client_path(client),
      params: {
        client: {
          lifecycle_stage: "at_risk",
          profile_notes: "Requested urgent drawdown review"
        }
      },
      headers: csrf_headers

    expect(response).to redirect_to(client_path(client))
    expect(client.reload.lifecycle_stage).to eq("at_risk")

    expect do
      delete client_path(client), headers: csrf_headers
    end.to change(Client, :count).by(-1)

    expect(response).to redirect_to(clients_path)
  end
end
