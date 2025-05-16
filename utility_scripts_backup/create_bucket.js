// This is a Node.js script to create a Google Cloud Storage bucket
// You'll need to install the Google Cloud Storage Node.js client library:
// npm install @google-cloud/storage

const {Storage} = require('@google-cloud/storage');

// Path to your service account key file
const keyFilename = './config/credentials/google_service_account.json';

// Create a storage client
const storage = new Storage({
  keyFilename,
  projectId: 'kinetic-harbor-454218-t7'
});

// Create a bucket
const bucketName = 'otakuwarrior-store-bucket';
const location = 'us-central1';  // Choose a location close to your users

async function createBucket() {
  try {
    const [bucket] = await storage.createBucket(bucketName, {
      location,
    });
    console.log(`Bucket ${bucket.name} created.`);
  } catch (error) {
    if (error.code === 409) {
      console.log(`Bucket ${bucketName} already exists.`);
    } else {
      console.error('ERROR:', error);
    }
  }
}

createBucket();