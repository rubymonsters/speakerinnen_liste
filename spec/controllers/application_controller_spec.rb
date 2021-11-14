require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  controller do
    def show
      head :ok
    end
  end

  before do
    routes.draw { get "show" => "anonymous#show" }
  end

  it "returns current region for existing subdomain" do
    request.host = 'vorarlberg.speakerinnen.org'
    get :show
    expect(controller.current_region).to eq :vorarlberg
  end

  it "returns nil without subdomain" do
    request.host = 'speakerinnen.org'
    get :show
    expect(controller.current_region).to eq nil
  end

  it "returns nil if subdomain for state does not exist" do
    request.host = 'berlin.speakerinnen.org'
    get :show
    expect(controller.current_region).to eq nil
  end

  it "returns nil if subdomain for country does not exist" do
    request.host = 'at.speakerinnen.org'
    get :show
    expect(controller.current_region).to eq nil
  end
end
