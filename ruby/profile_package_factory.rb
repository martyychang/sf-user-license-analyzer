require "date"
require "nokogiri"
require "uri"
require "zip/zip"

class ProfilePackageFactory

    # Return the expected profile name, given the user license name
    # and a prefix
    def get_profile_name user_license_name, prefix = "ProfilePackageFactory"
        return "#{prefix} #{user_license_name}"
    end

    # Return the list of profile names given the known user licenses and
    # a user-specified prefix
    def get_profile_names prefix
        @profile_names = []
        
        @user_license_names.each do |name|
            @profile_names.push self.get_profile_name(name, prefix)
        end

        @profile_names  # returned
    end

    # Constructor that remembers a list of known user license names.
    # It also remembers to use a different API version if one is specified,
    # otherwise defaulting to 29.0
    def initialize user_license_names, api_version = 29.0
        @user_license_names = user_license_names
        @api_version = api_version
    end

    # Create a package that can be used to create one new profile for
    # each known user license, named after the user license with a keyword
    # prepended to the profile name.
    def produce_package prefix
        timestamp = DateTime.now.strftime "%Y%m%d%H%M%S"
        package_filename = "#{prefix} Profiles Package #{timestamp}.zip"

        Zip::ZipFile.open(package_filename, Zip::ZipFile::CREATE) do |zip_file|

            # Create the manifest file

            zip_file.get_output_stream("package.xml") do |manifest_file|
                manifest_file.puts self.produce_package_xml prefix
            end

            # Create all of the profile definitions

            zip_file.mkdir "profiles"

            @user_license_names.each do |user_license_name|
                profile_name = self.get_profile_name(user_license_name, prefix)
                profile_path = "profiles/#{URI.escape(profile_name)}.profile"

                zip_file.get_output_stream(profile_path) do |profile_file|
                    profile_file.puts self.produce_profile(user_license_name)
                end
            end
        end
    end

    # Create the package.xml file as a Nokogiri document, which enumerates
    # all of the new profiles that would be created based on the known
    # user licenses
    def produce_package_xml prefix
        package_xml = Nokogiri::XML::Document.new
        
        # Create the root element

        root = package_xml.create_element "Package", 
            :xmlns => "http://soap.sforce.com/2006/04/metadata"
        package_xml.add_child root

        # Create the profile types element

        profile_types = package_xml.create_element "types"
        root.add_child profile_types

        # Add all of the profiles to the profile types

        self.get_profile_names(prefix).each do |profile_name|
            profile_members = package_xml.create_element "members"
            profile_members.content = URI.escape(profile_name)
            profile_types.add_child profile_members
        end

        # Specify the name for the profile types

        profile_name_el = package_xml.create_element "name"
        profile_name_el.content = "Profile"
        profile_types.add_child profile_name_el

        # Specify the API version

        version = package_xml.create_element "version"
        version.content = @api_version
        root.add_child version

        package_xml.to_s  # returned
    end

    # Create a profile XML file that can be used to create a profile
    # via deployment through the Metadata API
    def produce_profile user_license_name
        profile_xml = Nokogiri::XML::Document.new

        # Create the root element

        root = profile_xml.create_element "Profile",
            :xmlns => "http://soap.sforce.com/2006/04/metadata"
        profile_xml.add_child root

        # Create the user license element

        user_license_el = profile_xml.create_element "userLicense"
        user_license_el.content = user_license_name
        root.add_child user_license_el

        profile_xml.to_s  # returned
    end
end