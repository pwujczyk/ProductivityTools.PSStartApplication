#
# Module manifest for module 'module'
#
# Generated by: pwujczyk
#
# Generated on: 3/27/2018 9:31:40 PM
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'Start-Application.psm1'

# Version number of this module.
ModuleVersion = '0.0.7'

# ID used to uniquely identify this module
GUID = '30c9b11c-5192-4f6c-8e5c-52bde2cb184e'

# Author of this module
Author = 'Pawel Wujczyk'

# Description of the functionality provided by this module
Description = 'Not working currently'

# Modules that must be imported into the global environment prior to importing this module
RequiredModules = @('ProductivityTools.MasterConfiguration')

# Functions to export from this module
FunctionsToExport = @('Set-StartApplicationConfigurationPath','Start-Application')

# HelpInfo URI of this module
HelpInfoURI = 'http://www.productivitytools.tech/start-application/'

PrivateData = @{
    
    PSData = @{
        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('Start','AutoStart', "Application")
    
        # A URL to the main website for this project.
        ProjectUri = 'http://www.productivitytools.tech/start-application/'
    
            } # End of PSData hashtable
    } # End of PrivateData hashtable   
}

