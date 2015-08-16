# Be sure to restart your server when you modify this file.

# Skunkwerx::Application.config.session_store :cookie_store, key: '_skunkwerx_session'

# Sessions will be backed by ActiveRecord store and will not be
# limited to 4kb limit thereby avoiding
# ActionDispatch::Cookies::CookieOverflow error
Skunkwerx::Application.config.session_store :active_record_store
