#requires -modules Az.Accounts, Az.Resources
<#
=================================================================================
AUTHOR: Tao Yang
DATE: 06/05/2023
NAME: newBicepModule.ps1
VERSION: 0.0.1
COMMENT: Initiate an Bicep module folder and files structure for an empty module
=================================================================================
#>
[CmdletBinding()]
param (
  [parameter(Mandatory = $true, HelpMessage = "Resource Provider without 'microsoft.' prefix")]
  [string]$resourceProvider,

  [parameter(Mandatory = $true, HelpMessage = "ResourceType (lowerCamelCase).")]
  [string]$resourceType,

  [parameter(Mandatory = $false, HelpMessage = "Copy Module from CARML.")]
  [switch]$copyFromCARML
)

#region functions
Function isFileExistsOrEmpty {
  param (
    [parameter(Mandatory = $true, HelpMessage = "File path.")]
    [string]$filePath
  )
  if (test-path $filePath -PathType Leaf) {
    $fileContent = get-content $filePath
    if ($fileContent -eq $null -or $fileContent -eq "") {
      return $false
    } else {
      return $true
    }
  } else {
    return $false
  }
}
Function GetCARMLModuleContent {
  param (
    [parameter(Mandatory = $true, HelpMessage = "Resource Provider.")]
    [string]$resourceProvider,

    [parameter(Mandatory = $true, HelpMessage = "ResourceType.")]
    [string]$resourceType
  )

  $rpPrefix = $resourceProvider.split('.')[0]
  $rpShortName = $resourceProvider.split('.')[1]
  $rpShortName = $rpShortName.Substring(0, 1).ToUpper() + $rpShortName.Substring(1).ToLower()

  $carmlModuleUrl = "https://raw.githubusercontent.com/Azure/ResourceModules/main/modules/$rpShortName/$resourceType/main.bicep"
  Write-Verbose "Downloading module from CARML: $carmlModuleUrl"
  $carmlModuleRequest = Invoke-WebRequest -method Get -Uri $carmlModuleUrl -UseBasicParsing

  if ($carmlModuleRequest.StatusCode -ne 200) {
    write-warning "Unable to download module from CARML. Please check the resource provider and resource type and make sure the module exists in CARML."
    $moduleContent = $null
  } else {
    $moduleContent = $carmlModuleRequest.Content
  }
  return $moduleContent
}

Function CheckResourceType {
  param (
    [parameter(Mandatory = $true, HelpMessage = "Resource Provider.")]
    [string]$resourceProvider,

    [parameter(Mandatory = $true, HelpMessage = "ResourceType.")]
    [string]$resourceType
  )
  #make sure resource provider string starts with 'microsoft.'
  if ($resourceProvider.tolower() -inotmatch '^microsoft\..*') {
    $resourceProvider = "Microsoft.$resourceProvider"
  }
  $objResult = @{
    "resourceProvider"   = $null
    "resourceType"       = $null
    "resourceTypeExists" = $false
  }
  $resourceProviderLookup = Get-AzResourceProvider -ProviderNamespace $resourceProvider
  if ($resourceProviderLookup) {
    $objResult.resourceProvider = $resourceProviderLookup[0].ProviderNamespace
  }
  $reourceTypeLookup = $resourceProviderLookup | where-Object { $_.resourceTypes.ResourceTypeName -ieq $resourceType }
  if ($reourceTypeLookup) {
    $objResult.resourceType = $reourceTypeLookup.ResourceTypes.ResourceTypeName
    $objResult.resourceTypeExists = $true
  }
  $objResult
}

Function convertToLowerCamlCase {
  param (
    [parameter(Mandatory = $true, HelpMessage = "String to convert.")]
    [string]$string
  )
  $string = $string.Substring(0, 1).ToLower() + $string.Substring(1)
  $string
}
#endregion
#region variables

$bicepConfigFileName = "bicepconfig.json"
$bicepModuleFileName = "main.bicep"
$metadataFileName = "metadata.json"
#make sure the resource provider string is using lowerCamelCase
$resourceProvider = convertToLowerCamlCase -string $resourceProvider

$bicepConfigFileContent = @'
{
  "analyzers": {
    "core": {
      "enabled": true,
      "verbose": true,
      "rules": {
        "adminusername-should-not-be-literal": {
          "level": "error"
        },
        "max-outputs": {
          "level": "error"
        },
        "max-params": {
          "level": "error"
        },
        "no-hardcoded-env-urls": {
          "level": "warning"
        },
        "no-unnecessary-dependson": {
          "level": "error"
        },
        "no-unused-params": {
          "level": "warning"
        },
        "no-unused-vars": {
          "level": "error"
        },
        "outputs-should-not-contain-secrets": {
          "level": "error"
        },
        "prefer-interpolation": {
          "level": "error"
        },
        "secure-parameter-default": {
          "level": "error"
        },
        "simplify-interpolation": {
          "level": "error"
        },
        "use-protectedsettings-for-commandtoexecute-secrets": {
          "level": "error"
        },
        "use-stable-vm-image": {
          "level": "error"
        },
        "explicit-values-for-loc-params": {
          "level": "off"
        }
      }
    }
  }
}
'@

#endregion
#region main

#make sure it's logged in to Azure
if (!(Get-AzContext)) {
  Write-Output "Please login to Azure first."
  Add-AzAccount -UseDeviceAuthentication
}

#Lookup Resource Type
$validResourceType = CheckResourceType -resourceProvider $resourceProvider -resourceType $resourceType
if ($validResourceType.resourceProvider) {
  Write-Output "Resource Provider '$resourceProvider' exists."
  if ($resourceType.contains('/')) {
    # child resources, resource provider lookup may not able to find the resource type. as long as the resource provider is valid, we can proceed
    if (!$validResourceType.resourceTypeExists) {
      Write-Warning "Resource Type '$resourceType' is a child resource and it cannot be found in Resource Provider '$resourceProvider'. Will proceed anyway. Please make sure the resource type specified is in correct case."
    } else {
      Write-Output "The specified resource Type '$resourceType' does not exist in Resource Provider '$resourceProvider'."
      Write-Output "Please check the Resource Provider and Resource Type and try again."
      exit 1
    }
  }
} else {
  Write-Output "Resource Provider '$resourceProvider' does not exist."
  Write-Output "Please check the Resource Provider and try again."
  exit 1
}

#Need to use the exact RP and resource type names from the lookup because it's case sensitive
$rpNameFromLookup = $validResourceType.resourceProvider
if ($null -ne $validResourceType.resourceType) {
  $rtNameFromLookup = $validResourceType.resourceType
} else {
  $rtNameFromLookup = $resourceType
}

$moduleRootFolder = join-path (get-item $PSScriptRoot).Parent "modules/carml"
$moduleFolder = join-path $moduleRootFolder "$resourceProvider/$rtNameFromLookup"
$metadataFilePath = join-path $moduleFolder $metadataFileName
$bicepModuleFilePath = join-path $moduleFolder $bicepModuleFileName
$bicepConfigFilePath = join-path $moduleFolder $bicepConfigFileName
$metadataFileContent = @"
  {
    "itemDisplayName": "Bicep Module for '$rpNameFromLookup/$resourceType'",
    "description": "This module deploys a '$rpNameFromLookup/$resourceType' resource.",
    "summary": "Deploys a '$rpNameFromLookup/$resourceType' resource using Azure Bicep."
  }
"@
#look up Resource Provider
Write-Output "Module Root Folder: '$moduleRootFolder'"
Write-Output "Resource Provider: '$rpNameFromLookup'"
Write-Output "Resource Type: '$rtNameFromLookup'"

if (test-path $moduleFolder) {
  Write-Output "Module folder '$moduleFolder' already exists."
} else {
  Write-Output "Creating module folder '$moduleFolder'..."
  New-Item -Path $moduleFolder -ItemType Directory -Force -ErrorAction Stop
}

if ($copyFromCARML) {
  Write-output "Try to copy existing module from CARML(https://aka.ms/CARML)..."
  $carmlModuleContent = GetCARMLModuleContent -resourceProvider $rpNameFromLookup -resourceType $rtNameFromLookup
}
Write-Output "Creating module files..."
Write-output "  - Creatting metadata file '$metadataFileName'..."
if (isFileExistsOrEmpty $metadataFilePath) {
  Write-Output "Metadata file '$metadataFilePath' already exists."
} else {
  Write-Output "Creating metadata file '$metadataFilePath'..."
  $metadataFileContent | Out-File $metadataFilePath -Force -ErrorAction Stop
}

Write-Output "  - Creatting bicep module file '$bicepModuleFileName'..."
if (isFileExistsOrEmpty $bicepModuleFilePath) {
  Write-Output "Bicep module file '$bicepModuleFilePath' already exists."
} else {
  if ($carmlModuleContent) {
    Write-Output "Creating the Bicep module file by copying the content from CARML"
    $carmlModuleContent | Out-File $bicepModuleFilePath -Force -ErrorAction Stop
  } else {
    Write-Output "Creating an empty bicep module file '$bicepModuleFilePath'..."
    New-Item -Path $bicepModuleFilePath -ItemType File -Force -ErrorAction Stop
  }
}

Write-Output "  - Creatting bicep config file '$bicepConfigFileName'..."
if (isFileExistsOrEmpty $bicepConfigFilePath) {
  Write-Output "Bicep config file '$bicepConfigFilePath' already exists."
} else {
  Write-Output "Creating bicep config file '$bicepConfigFilePath'..."
  $bicepConfigFileContent | Out-File $bicepConfigFilePath -Force -ErrorAction Stop
}

Write-Output "Done."

#endregion