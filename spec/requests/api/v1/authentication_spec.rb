# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authentications', type: :request do
  let(:valid_attributes) { attributes_for(:user) }
  let(:valid_headers) { {} }

  describe 'POST /api/v1/login' do
    it 'login users' do
      post api_v1_auth_login_url,
           params: { user: valid_attributes },
           headers: valid_headers, as: :json
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end
end
