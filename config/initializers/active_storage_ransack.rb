# Allow ActiveStorage attachments to work with ActiveAdmin + Ransack
Rails.application.config.to_prepare do
    ActiveStorage::Attachment.class_eval do
      def self.ransackable_attributes(auth_object = nil)
        %w[blob_id created_at id name record_id record_type]
      end
    end
  
    ActiveStorage::Blob.class_eval do
      def self.ransackable_attributes(auth_object = nil)
        %w[checksum content_type created_at filename id key metadata service_name byte_size]
      end
    end
  end
  