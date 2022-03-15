# Setup Rswag

> Basado en [___Let’s forget painful API documentation___](https://medium.com/wolox/lets-forget-painful-api-documentation-f5d0f5d0d06d)
https://stackoverflow.com/questions/64064973/how-to-set-a-bearer-token-param-for-testing-a-rails-api-using-rswag-ui

---
## Use it in your API

### Modelo y controlador


### Install the gem

#### Step 1: Install it

En su aplicación actual o en una nueva aplicación, agregue estas líneas a su Gemfile:
```ruby
# Gemfile
# [...]
gem 'rswag-api'
gem 'rswag-ui'


group :development, :test do
  # [...]
  gem 'rspec-rails', '~> 4.1' # https://rubygems.org/gems/rspec-rails
  gem 'rswag-specs'
end
# [...]
```

Instale la gema y use el task de ellos para generar los archivos necesarios:
```sh
bundle install
rails g rswag:api:install
rails g rswag:ui:install
RAILS_ENV=test rails g rswag:specs:install
```

### Step 2: configure it
En */config/initializer/rswag-api.rb* se define la ruta donde se crearán los archivos de configuración Json/Yaml. Debería ser igual a esto, pero se puede adaptar para que se ajuste a sus necesidades:
```ruby
# /config/initializer/rswag-api.rb
Rswag::Api.configure do |c|
  c.swagger_root = Rails.root.to_s + '/swagger'
end
```

Configuración de rutas personalizadas:
```ruby
# /config/routes.rb
Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      # [...]
end
```

> Nota: La ruta UI es la que se utilizará para acceder a la documentación en el navegador.

Ahora el inicializador de la interfaz de usuario de Swagger:
```ruby
# /config/initializer/rswag-ui.rb
Rswag::Ui.configure do |c|
  c.swagger_endpoint '/api-docs/v1/swagger.yaml', 'OT151-SERVER API V1 Docs'
end
```

Hay 2 datos a tener en cuenta:
- `/api-docs/v1/swagger.yaml` es donde la gema debe buscar el archivo de configuración Json/Yaml en su proyecto.
- `OT151-SERVER API V1 Docs` es el nombre que aparecerá en el HTML

Para permitir una respuesta de body de generación automática en este ejemplo, necesitaremos agregar estas líneas a *application.rb*:
```ruby
# /config/application.rb

# [...]
module OT151Server
  class Application < Rails::Application
    # [...]
    config.api_only = true
    if Rails.env.test?
      RSpec.configure do |config|
        config.swagger_dry_run = false
      end
    end
  end
end
```

___OPCIONAL___: Tal vez tenga algo de lógica para protegerse del ataque del rack. Una prueba de integración evita rápidamente que el ataque al rack envíe un `429`. Cambie sus límites de solicitud:
```yaml
# /config/secrets.yml
test:
  <<: *development
  max_requests_per_second: 50
```

### Step 3: Hide files for pull request (optional)
Los archivos de configuración Json/Yaml se generan automáticamente y cambiarán cada vez que volvamos a generar la documentación. No queremos mostrar estos cambios en un _pull request_, por lo que agregaremos esto a nuestro proyecto:

```
# .gitattributes
/swagger/v1/* linguist-generated=true
/swagger/v1/* -diff
```

### Create an integration test for documentation

#### Step 1: set up the Swagger Helper
Editaremos el archivo (*swagger_helper.rb*) generado por el task que ejecutamos antes.:
1. *swagger_root*: es la ruta donde la gema generará el archivo de configuración JSON y debe ser la misma que la del *initializer* para *rswag-api*;
2. *swagger_docs* : es la configuración general de la documentación.

```ruby
# /spec/swagger_helper.rb
require 'rails_helper'
 
RSpec.configure do |config|
  config.swagger_root = Rails.root.join('swagger').to_s
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      swagger: '2.0',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {},
      servers: [
        {
          url: 'https://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'www.example.com'
            }
          }
        }
      ]
    }
  }
end
```


#### Step 2: Let’s create a shared piece of test
Cada vez que queramos generar documentación necesitamos agregar la línea `run_test!` en el código. 
Además, para permitir que la gema genere automáticamente un ejemplo de _body response_, debemos agregar algunas líneas. Entonces, ¿qué es mejor que un `share_context` para eso?
```ruby
#spec/support/shared_contexts/integration_test.rb
require 'rails_helper'
 
shared_context 'with integration test' do
  run_test!
  after do |example|
    example.metadata[:response][:examples] =
      { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
  end
end
```
> Nota: Sea sume que existe la siguiente linea en  *rails_helper.rb* para solicitar los archivos que tiene en su directorio de soporte.
```ruby
#spec/rails_helper.rb
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
```

#### Step 3: Document your endpoints
Cada endpoint necesita datos específicos, y la estructura debe adaptarse para cada uno.  
___Pero aquí intentaremos dar la estructura general para cada tipo (GET, POST, PATCH, DELETE), para que tengamos un conocimiento común sobre cómo construir la prueba de integración. Y eso es perfecto porque en nuestro CRUD tenemos este tipo de endpoint.___

Además, gem nos permite usar todos los métodos de rspec.

Además, llamamos a esta prueba de integración porque cuando se ejecuta rspec, esta prueba de integración también se ejecutará y no debería fallar... Esto nos permitirá mantener mejor la documentación y asegurarnos de que estamos creando la documentación necesaria.

La idea es crear un archivo de integración para cada controlador, por ejemplo:
- *app/controllers/api/v1/categories_controller.rb* -> *spec/integration/api/v1/categories_spec.rb*

> NOTA: Para fines de este ejemplo, se añade la acción `index` del controlador y se modifican las lineas 
```ruby
# before_action :authenticate_with_token!, only: %i[update]
# before_action :admin, only: %i[update show]
before_action :set_category, only: %i[show destroy]
```

Además, cada archivo contendrá. Ejemplo para *categories_spec.rb*:
```ruby
# frozen_string_literal: true

require 'swagger_helper'
 
describe 'Categories API V1 Docs', type: :request, swagger_doc: 'v1/swagger.yaml' do
  TAGS_CATEGORY = 'Category'

  # Integration tests
  # [...]
```

#### Ejemplo generico

```ruby
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
```

Algunas observaciones.
- Este ejemplo sirve para generar la documentación para un endpoint que devuelve un response con status y body definido en el controlador.
- Si se necesitan otros test (por ejemplo, para paginación, controlar que coincidan los datos del POST con el response, etc.) se deberia omitir la linea include_context 'with integration test' e implementar los test despues de la instrucción `run_test!`. Por ejemplo
```
# consultar https://github.com/rswag/rswag#paths-operations-and-responses
  # [...]
  run_test! do |response|
    data = JSON.parse(response.body)
    expect(data['title']).to eq('foo')
  end
end
```

### Generate the documentation
> Nota, en este ejemplo se centa el archivo */spec/requests/api/v1/users/auth_spec.rb* ya que continene un error en uno de los test
1. En primer lugar, verifique que haya pasado la prueba de integración;
2. Generar la documentación;
3. Ejecute su servidor.
```sh
bundle exec rspec spec/integration
RAILS_ENV=test bundle exec rake rswag:specs:swaggerize
rails server
```

Acceso a la documentación: *http://localhost:3000/api-docs/*

### Configuración generada
Este es el archivo generado al ejecutar `rswag:specs:swaggerize`
```yaml
# swagger/v1/swagger.yaml
--- 
swagger: '2.0'
info:
  title: API V1
  version: v1
paths:
  "/api/v1/categories":
    get:
      summary: Retrieves all categories
      tags:
      - Category
      produces:
      - application/json
      responses:
        '200':
          description: Categories found
          examples:
            application/json:
              data:
              - id: '141'
                type: category
                attributes:
                  name: Ryan Carnation
                  description: Re-engineered directional projection
              - id: '142'
                type: category
                attributes:
                  name: Joy Kil
                  description: Upgradable empowering structure
    post:
      summary: Create a category
      tags:
      - Category
      consumes:
      - application/json
      parameters:
      - name: params
        in: body
        schema:
          type: object
          properties:
            category:
              type: object
              properties:
                name:
                  type: string
                description:
                  type: text
              required:
              - name
              - description
          required:
          - category
      produces:
      - application/json
      responses:
        '201':
          description: Category created
          examples:
            application/json:
              data:
                id: '144'
                type: category
                attributes:
                  name: Helena Hanbaskett
                  description: Reduced composite leverage
        '422':
          description: Category creation failed for parameter missing
          examples:
            application/json:
              message: 'Validation failed: Name can''t be blank, Name is too short
                (minimum is 4 characters), Description can''t be blank, Description
                is too short (minimum is 4 characters)'
  "/api/v1/categories/{id}":
    get:
      summary: Retrieves a category.
      tags:
      - Category
      description: a category
      produces:
      - application/json
      parameters:
      - name: id
        in: path
        type: string
        required: true
      responses:
        '200':
          description: Category found
          examples:
            application/json:
              data:
                id: '143'
                type: category
                attributes:
                  name: Theresa Green
                  description: Multi-channelled coherent definition
        '404':
          description: Category not found
          examples:
            application/json:
              message: Couldn't find Category with 'id'=-1
    delete:
      summary: Update a category
      tags:
      - Category
      consumes:
      - application/json
      parameters:
      - name: id
        in: path
        type: string
        required: true
      produces:
      - application/json
      responses:
        '204':
          description: Destroy the category
servers:
- url: https://{defaultHost}
  variables:
    defaultHost:
      default: www.example.com

```
