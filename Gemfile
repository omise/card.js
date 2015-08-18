# If you do not have OpenSSL installed, update
# the following line to use "http://" instead
source 'https://rubygems.org'

gem "middleman", "~>3.3.7"

# Live-reloading plugin
gem "middleman-livereload", "~> 3.1.0"

# For faster file watcher updates on Windows:
gem "wdm", "~> 0.1.0", :platforms => [:mswin, :mingw]

# Windows does not come with time zone data
gem "tzinfo-data", platforms: [:mswin, :mingw]

group :development, :test do
  # Sprockets is a Ruby library for compiling and serving web assets (assets management)
  # Used with 'middleman-jasmine' for run Jasmine javascript unit test
  gem "middleman-sprockets"

  gem "jasmine"

  gem "middleman-jasmine"
end