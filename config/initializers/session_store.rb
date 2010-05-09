# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_fakemytweet_session',
  :secret      => '6cd26fd644d204f68482d6fec905544165b2ad197757016a603e4de2b5418a411e9fe02e8334db484efc6c9d438638eb4d49c864ed8b5dac553deba74e3c3e3c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
