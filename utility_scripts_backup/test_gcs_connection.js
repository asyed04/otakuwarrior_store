// This is a Node.js script to test the connection to Google Cloud Storage
// and list the files in the bucket

const {Storage} = require('@google-cloud/storage');

// Path to your service account key file
const keyFilename = './config/credentials/google_service_account.json';

// Create a storage client
const storage = new Storage({
  keyFilename,
  projectId: 'kinetic-harbor-454218-t7'
});

// Bucket name
const bucketName = 'otaku_anz_7';

async function listFiles() {
  try {
    // Get a reference to the bucket
    const bucket = storage.bucket(bucketName);
    
    // Check if the bucket exists
    const [exists] = await bucket.exists();
    if (!exists) {
      console.error(`Bucket ${bucketName} does not exist.`);
      return;
    }
    
    console.log(`Successfully connected to bucket: ${bucketName}`);
    
    // List files in the bucket
    const [files] = await bucket.getFiles();
    
    console.log('Files:');
    files.forEach(file => {
      console.log(`- ${file.name}`);
    });
    
    if (files.length === 0) {
      console.log('No files found in the bucket.');
    }
  } catch (error) {
    console.error('ERROR:', error);
  }
}

listFiles();