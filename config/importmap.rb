# Pin npm packages by running ./bin/importmap

pin "application"

# Use local Rails UJS instead of external CDN
pin "@rails/ujs", to: "vendor/@rails/ujs.js"
