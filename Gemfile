# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'dotenv'
gem 'falcon', '~> 0.39.2'
gem 'json-schema', '~> 2.8', '>= 2.8.1'
gem 'nanites', git: 'https://github.com/tstaetter/nanites', branch: 'main'
gem 'sinatra', '~> 2.1'

group :development, :test do
end

group :test do
  gem 'rack-test'
  gem 'rspec'
  gem 'simplecov', require: false
end
