# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_follow-that-bird_session',
  :secret      => '9c60d7ccd8752ef632bce57134f6d6c16c46aca2391132ec5e109d5c2b09a36437b8132011a752560f3b7fcb2c3264e2b515e361b9f73b3e717affadac6772b6'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
