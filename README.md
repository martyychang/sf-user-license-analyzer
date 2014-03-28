## Note from the author

    Please let me know if you run the scripts and produce new results, so that
    we can confirm the validity of [what I originally published](http://carvingintheclouds.blogspot.com/2014/03/allowed-user-licenses-changes-upgrades.html).
    It would be great if you can also share any contradictions or different
    results that you encounter, so that the Salesforce community can always
    have an accurate and up-to-date reference for managing user licenses.
    -- Marty C.

## How do I use the scripts?

### Prerequisites

You should be comfortable with:

* Downloading files
* Creating and editing .csv files
* Running commands in the Command Prompt (Windows) or the shell (*nix)

You'll also need to have on your computer:

* A Salesforce org that allows you to create (not deploy) Apex. 
  Typically this means a sandbox org or a Developer Edition org.
* [Ruby](https://www.ruby-lang.org/en/). If you're on Windows, 
  make life simple and run [RailsInstaller](http://railsinstaller.org/en).
* [Nokogiri](http://nokogiri.org/) for Ruby
* The scripts. Easiest way is to just download this repo as a .zip file and
  extract it to your computer

### Step 1. List all licenses available to you for testing

The **ruby** folder contains a sample **UserLicense.csv** file, which should list
every user license available in your org to use for testing. To avoid errors,
you should generate this list from your org using SOQL.

```
SELECT Name FROM UserLicense ORDER BY Name
```

Make sure you leave the **Name** column header in the UserLicense.csv file. The
script assumes that this header is present and will skip the first row when
executing.

### Step 2. Create profiles in your org for testing purposes

**TIP**: All of the test profiles created have names that begin with "ApexUnit".
If this will conflict with a real naming convention in your org, please 
_abort this exercise_.

Since you can't actually create profiles in Apex tests (at least in Winter '14
and API 29.0), you will need to create real profiles that will only be used
for testing purposes.

This part should be pretty painless:

1. Launch a command line interface (e.g., Command Prompt, Terminal)
2. Change to the **ruby** folder for this project
3. `> ruby create_new_profiles_package.rb`
4. Log into [Workbench](https://workbench.developerforce.com). You can skip this
   step and use any other Metadata API-compatible deployment tool if you want,
   but these instructions are written assuming you will use Workbench.
5. Hover over the **migration** nav header, then click **Deploy**
6. Select the "ApexUnit Profiles Package __.zip" file that was generated by the
   script, which should be in the same **ruby** folder
7. Mark these checkboxes: Rollback On Error; Single Package; Run All Tests
8. Click Next, then click Deploy

### Step 3. Run the test and save the test log

**TIP**: As noted as a prerequisite, you _must_ be able to create Apex in your
org, because the test class used here cannot be deployed to a production org.

1. Create a `UserLicenseTest` Apex class in your org, using the code from the
**src/classes/UserLicenseTest.class** file
2. Open the Developer Console in Salesforce
3. Run the tests contained in the UserLicenseTest class
4. Open the test results and download the log file

### Step 4. Create a CSV file of the results

You're almost done! This last part is a bit tedious but manageable.

1. Open the log file
2. Find the `USER_DEBUG` line that contains the raw CSV output of the results
3. Copy all of the raw CSV output, then paste it into a new text file
4. Save the text file as a .csv file
5. Open the .csv file in Excel, pretty it up, and distribute!

Again, if you do succeed in running this script in your org, many people will
appreciate your sharing the results back with the community.