require "./profile_package_factory.rb"

# Define constants

API_VERSION = 29.0

# List all of the available user license names

user_license_names = [
    'Chatter External',
    'Chatter Only',
    'Knowledge Only',
    'Siteforce Only',
    'Salesforce',
    'Salesforce Platform',
    'Content Only',
    'Gold Partner',
    'Force.com - One App',
    'Customer Portal Manager Custom',
    'Customer Portal Manager Standard',
    'Chatter Free',
    'High Volume Customer Portal',
    'Partner Community',
    'Customer Community Login',
    'Partner Community Login',
    'Customer Community',
    'Work.com Only'
]

# Instantiate a new profile package factory, primed with the available licenses

factory = ProfilePackageFactory.new user_license_names

# Create a new package

factory.produce_package "ApexUnit"