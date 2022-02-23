# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/users', type: :request do
  let(:valid_attributes) { attributes_for(:user) }

  let(:invalid_attributes) { attributes_for(:user).merge(first_name: nil) }

  let(:valid_headers) { {} }

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'returns http created' do
        post api_v1_auth_register_url,
             params: { user: valid_attributes },
             headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
      end

      it 'creates a new User' do
        expect do
          post api_v1_auth_register_url,
               params: { user: valid_attributes },
               headers: valid_headers, as: :json
        end.to change(User, :count).by(1)
      end

      it 'renders a JSON response with the new user' do
        post api_v1_auth_register_url,
             params: { user: valid_attributes },
             headers: valid_headers, as: :json
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'returns http unproccesable entity' do
        post api_v1_auth_register_url,
             params: { user: invalid_attributes },
             headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create a new User' do
        expect do
          post api_v1_auth_register_url,
               params: { user: invalid_attributes }, as: :json
        end.to change(User, :count).by(0)
      end

      it 'renders a JSON response with errors for the new user' do
        post api_v1_auth_register_url,
             params: { user: invalid_attributes },
             headers: valid_headers, as: :json
        expect(response.content_type).to eq('application/json')
      end
    end
  end
end
