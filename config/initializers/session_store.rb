# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_ch3_app_session',
  :secret      => '4d54540382b437720482a060a0a5c21aea362dbe982f93c194a5ebc017c227aad8abbff776ae1959001d7d88fe8c59f360abda3d7905b4fd0fa4853ef94a6230'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
