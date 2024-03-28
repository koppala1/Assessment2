############################################################################################################
1. Create a new Rails app
Ans) 
step step 2 => rails new myapp
1 => cd path/to/your/directory
step 3 => cd myapp

############################################################################################################
2. Create a new model with a name and data of your choosing with some basic validations
Ans)
step 1 => rails generate model ModelName attribute1:string attribute2:integer
step 2 => rails db:migrate
step 3 => 

class ModelName < ApplicationRecord
  validates :attribute1, presence: true
  validates :attribute2, numericality: { only_integer: true }
end

############################################################################################################
3. Create a controller for this model that contains endpoints for create and update
i) No authentication is required
ii) Include some basic verification for submitted parameters
Ans)
step 1 => rails generate controller ControllerName
step 2 => 

class ControllerNameController < ApplicationController
  # Endpoint for creating a new record
  def create
    @model = ModelName.new(model_params)
    if @model.save
      render json: { message: 'Record created successfully', data: @model }, status: :created
    else
      render json: { error: 'Failed to create record', errors: @model.errors }, status: :unprocessable_entity
    end
  end

  # Endpoint for updating an existing record
  def update
    @model = ModelName.find(params[:id])
    if @model.update(model_params)
      render json: { message: 'Record updated successfully', data: @model }, status: :ok
    else
      render json: { error: 'Failed to update record', errors: @model.errors }, status: :unprocessable_entity
    end
  end

  private

  # Strong parameters method to whitelist attributes for mass assignment
  def model_params
    params.require(:model_name).permit(:attribute1, :attribute2)
  end
end

step 3 => 

Rails.application.routes.draw do
  resources :model_name, only: [:create, :update]
end

#######################################################################################################

4. Available third-party API endpoints should be configurable (backend support only, no need for GUI)
Ans) step 1 => 
# Access environment variables
endpoint_url = ENV['THIRD_PARTY_API_ENDPOINT_URL']

development:
  third_party_api_endpoint_url: 'http://example.com/api'

test:
  third_party_api_endpoint_url: 'http://test.example.com/api'

production:
  third_party_api_endpoint_url: 'https://api.example.com'

# Load configuration file
third_party_apis = YAML.load_file(Rails.root.join('config', 'third_party_apis.yml'))

# Access endpoint based on environment
endpoint_url = third_party_apis[Rails.env]['third_party_api_endpoint_url']

###########################################################################################################
5. When new data is stored or updated, all configured endpoints should be notified of the changes
Ans)

# app/services/webhook_service.rb
class WebhookService
  def self.notify_endpoints(data)
    webhooks = Webhook.all
    webhooks.each do |webhook|
      send_request(webhook.url, data)
    end
  end

  def self.send_request(url, data)
    # Use an HTTP client library like HTTParty or RestClient to send POST requests
    # Example:
    # response = RestClient.post(url, data.to_json, headers: { 'Content-Type': 'application/json' })
    # Handle response if needed
  rescue RestClient::ExceptionWithResponse => e
    # Handle errors
  end
end

# Inside your model or controller where data is created or updated
after_commit :notify_webhooks, on: [:create, :update]

def notify_webhooks
  WebhookService.notify_endpoints(self)
end

############################################################################################################

6. Third parties should be provided with means to verify the authenticity of the webhook request
Ans)
  Shared Secret or API Key: Provide each third party with a unique shared secret or API key. 
  This key should be included in the webhook request headers or payload.

  HMAC (Hash-based Message Authentication Code): Use the shared secret/API key to generate an HMAC of the request payload. 
  Include this HMAC in the request headers or payload.

   Verification on Third-Party Side: Third parties can then use the shared secret/API key to regenerate the HMAC on their side and 
   compare it with the HMAC received in the request. If they match, it indicates that the request originated from the expected source.

   Timestamps: Include a timestamp in the webhook request to prevent replay attacks. Third parties can verify that the timestamp is within an 
    acceptable range to ensure the request's freshness.

   HTTPS: Ensure that webhook requests are transmitted over HTTPS to encrypt the data in transit and prevent man-in-the-middle attacks.

#########################################################################################################################################

# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
