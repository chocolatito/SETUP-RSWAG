# frozen_string_literal: true

require 'swagger_helper'

describe 'Categories API V1 Docs', type: :request, swagger_doc: 'v1/swagger.yaml' do
  TAGS_CATEGORY = 'Category'

  # Integration tests
  path '/api/v1/categories' do
    get 'Retrieves all categories' do
      tags TAGS_CATEGORY
      produces 'application/json'

      response '200', 'Categories found' do
        before do
          create_list(:category, 2)
        end

        include_context 'with integration test'
      end
    end
  end

  path '/api/v1/categories/{id}' do
    get 'Retrieves a category.' do
      tags TAGS_CATEGORY
      description 'a category'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'Category found' do
        let(:category) { create(:category) }
        let(:id) { category.id }

        include_context 'with integration test'
      end

      response '404', 'Category not found' do
        let(:id) { -1 }

        include_context 'with integration test'
      end
    end
  end
  path '/api/v1/categories' do
    post 'Create a category' do
      tags TAGS_CATEGORY
      consumes 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          category: {
            type: :object,
            properties: {
              name: { type: :string },
              description: { type: :text }
            },
            required: %w[name description]
          }
        },
        required: ['category']
      }
      produces 'application/json'

      response '201', 'Category created' do
        let(:params) { { category: attributes_for(:category) } }
        include_context 'with integration test'
      end

      response '422', 'Category creation failed for parameter missing' do
        let(:params) { { name: '', description: '' } }
        include_context 'with integration test'
      end
    end
  end
  path '/api/v1/categories/{id}' do
    delete 'Update a category' do
      tags TAGS_CATEGORY
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      produces 'application/json'

      response '204', 'Destroy the category' do
        let(:id) { create(:category).id }

        run_test!
      end
    end
  end
end
