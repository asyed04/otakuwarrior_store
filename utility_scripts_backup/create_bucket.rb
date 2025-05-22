require "google/cloud/storage"

# Path to your service account key file
key_file = "config/credentials/google_service_account.json"

# Create a storage client
storage = Google::Cloud::Storage.new(
  project_id: "kinetic-harbor-454218-t7",
  credentials: key_file
)

# Create a bucket
bucket_name = "otakuwarrior-store-bucket"
location = "us-central1"  # Choose a location close to your users

begin
  bucket = storage.create_bucket bucket_name, location: location
  puts "Bucket #{bucket.name} created."
rescue Google::Cloud::AlreadyExistsError
  puts "Bucket #{bucket_name} already exists."
end