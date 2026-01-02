ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.

# Speed up boot time by caching expensive operations.
# Bootsnap may fail in restricted environments, so we make it optional
begin
  require "bootsnap/setup"
rescue Errno::EPERM, LoadError
  # Bootsnap failed due to permissions or missing gem - continue without it
  # This is fine for development, bootsnap is just an optimization
end

