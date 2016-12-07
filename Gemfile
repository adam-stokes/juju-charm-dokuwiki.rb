# frozen_string_literal: true
source "https://rubygems.org"

gem "rake"
gem "rspec"
gem "charmkit", "~> 0.4.4"

# Bundletester will install its own mechanize via apt install ruby-mechanize
# see hooks/install for the bundle command we run without development on our production
# charm.
#
# This is useful for running our local tests/* before uploading to charm store
gem 'mechanize', :group => :development
