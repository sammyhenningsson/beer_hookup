# frozen_string_literal: true

if Rails.env.development?
  require "debug/open_nonstop"
elsif Rails.env.test?
  require "debug"
end
