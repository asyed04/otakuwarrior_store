#!/bin/bash
sudo service postgresql start
sudo -u postgres psql -f /mnt/c/Users/syeda/FullStack/Rails/otakuwarrior_store/manual_fix.sql