namespace :storage do
  desc 'Create Google Cloud Storage bucket'
  task create_bucket: :environment do
    require 'google/cloud/storage'

    # Create a storage client using Rails credentials
    storage = Google::Cloud::Storage.new(
      project_id: Rails.application.credentials.dig(:google, :project_id),
      credentials: {
        type: 'service_account',
        project_id: Rails.application.credentials.dig(:google, :project_id),
        private_key_id: Rails.application.credentials.dig(:google, :private_key_id),
        private_key: Rails.application.credentials.dig(:google, :private_key),
        client_email: Rails.application.credentials.dig(:google, :client_email),
        client_id: Rails.application.credentials.dig(:google, :client_id),
        auth_uri: 'https://accounts.google.com/o/oauth2/auth',
        token_uri: 'https://oauth2.googleapis.com/token',
        auth_provider_x509_cert_url: 'https://www.googleapis.com/oauth2/v1/certs',
        client_x509_cert_url: Rails.application.credentials.dig(:google, :client_x509_cert_url),
      }
    )

    # Create a bucket
    bucket_name = Rails.application.credentials.dig(:google, :bucket)
    location = 'us-central1' # Choose a location close to your users

    begin
      bucket = storage.create_bucket bucket_name, location: location
      puts "Bucket #{bucket.name} created."
    rescue Google::Cloud::AlreadyExistsError
      puts "Bucket #{bucket_name} already exists."
    end
  end
end
