#GET CURRENT DIRECTORY
$currentDirectory = $PWD.Path

# Specify the module name and directory containing resources
$moduleName = "apj.core"
$resourcesDirectory = Join-Path -Path $currentDirectory -ChildPath "\lib"

# Start generating module.xml
$xmlContent = '<?xml version="1.0" encoding="UTF-8"?>'
$xmlContent +=[Environment]::NewLine
$xmlContent += "<module xmlns=`"urn:jboss:module:1.5`" name=`"$moduleName`">"
$xmlContent +=[Environment]::NewLine
$xmlContent += "    <resources>"
$xmlContent +=[Environment]::NewLine
# Loop through each file and subdirectory in the resources directory
Get-ChildItem -Path $resourcesDirectory -Recurse | ForEach-Object {
    # Get the relative path of the file or subdirectory
    $relativePath = $_.FullName.Substring($resourcesDirectory.Length + 1)

    # Replace backslashes with forward slashes for module.xml
    $relativePath = $relativePath -replace '\\', '/'

    # Add resource-root element for files or subdirectories
    $xmlContent += "        <resource-root path=`"lib/$relativePath`"/>"
    $xmlContent +=[Environment]::NewLine
}
$xmlContent += "        <resource-root path=`"lib/apj-ejb.jar`"/>"
$xmlContent += [Environment]::NewLine
# End module.xml
$xmlContent += "    </resources>"
$xmlContent +=[Environment]::NewLine
$xmlContent += "</module>"
$moduleXmlPath = Join-Path -Path $currentDirectory -ChildPath "module.xml"
$xmlContent | Out-File -FilePath $moduleXmlPath -Encoding UTF8
#PROMPT WILDFLY PATH

$wildflyPath = Read-Host "WILDFLY PATH:"
[System.Environment]::SetEnvironmentVariable("WILDFLY_HOME",$wildflyPath, "Machine")
$modulePath = Join-Path -Path $wildflyPath -ChildPath "\modules\system\layers\base\apj"
if (Test-Path -Path $modulePath -PathType Container) {
    Write-Host "APJ Folder already exists."
} else {
    Write-Host "Creating folder APJ right now"
    New-Item -Path $modulePath -ItemType Directory
    $moduleCorePath= Join-Path -Path $wildflyPath -ChildPath "\modules\system\layers\base\apj\core"
    New-Item -Path $moduleCorePath -ItemType Directory
    $moduleMainPath = Join-Path -Path $wildflyPath -ChildPath "\modules\system\layers\base\apj\core\main"
}

$moduleCorePath = Join-Path -Path $wildflyPath -ChildPath "\modules\system\layers\base\apj\core\main"
$moduleToCopy = Join-Path -Path $currentDirectory -ChildPath "\module.xml"
$libToCopy = Join-Path -Path $currentDirectory -ChildPath "\lib"
$libPath = Join-Path -Path $moduleCorePath -ChildPath "\lib"
New-Item -Path $libPath -ItemType Directory
Write-Host "Copying the module.xml Folder"
Copy-Item -Path $libToCopy -Destination $moduleCorePath -Recurse -Force
Write-Host "Copying the lib to the folder"
Copy-Item -Path $moduleToCopy -Destination $moduleCorePath -Force
$buildXml = Join-Path -Path $currentDirectory -ChildPath "\build-apj.xml"
Invoke-Expression "ant -Dwildfly='$wildflyPath' -f $buildXml"
$jarLocal = Join-Path -Path $currentDirectory -ChildPath "\output\ear\apj-ejb.jar"
Copy-Item -Path $jarLocal -Destination $libPath -Force
Write-Host "Installed jar successfully"
