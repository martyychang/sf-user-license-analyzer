require "./profile_package_factory.rb"
require "csv"

# Define constants

DEFAULT_API_VERSION = 29.0  # Assumed if none is given

# Look for a different API version to use when passed as a parameter

api_version = DEFAULT_API_VERSION
api_version = ARGV[0].to_f if ARGV.size > 0

# List all of the available user license names, 
# reading them from UserLicense.csv

user_license_names = []

CSV.read("./UserLicense.csv").each do |row|
    value = row[0]
    user_license_names.push value unless value == "Name"
end

# Instantiate a new profile package factory, primed with the available licenses

factory = ProfilePackageFactory.new user_license_names, api_version

# Create a new package

factory.produce_package "ApexUnit"