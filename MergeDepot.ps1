# Add specific step for azure
# Download Azure Transform tool

Add-type -AssemblyName "System.IO.Compression.FileSystem"
$mergeDepotToolContainerUrl = "https://siwtest.blob.core.windows.net/mergedepot"

if(!(Test-Path ".optemp"))
{
    New-Item ".optemp" -ItemType Directory
}

$currentFolder = Get-Location
$MergeDepotToolSource = "$mergeDepotToolContainerUrl/MergeDepotTool.zip"
$MergeDepotToolDestination = "$currentFolder\.optemp\MergeDepotTool.zip"

echo 'Start Download!'
Invoke-WebRequest -Uri $MergeDepotToolSource -OutFile $MergeDepotToolDestination | Write-Host
echo 'Download Success!'

$MergeDepotToolUnzipFolder = "$currentFolder\.optemp\MergeDepotTool"
if((Test-Path "$MergeDepotToolUnzipFolder"))
{
    Remove-Item $MergeDepotToolUnzipFolder -Force -Recurse
}

[System.IO.Compression.ZipFile]::ExtractToDirectory($MergeDepotToolDestination, $MergeDepotToolUnzipFolder) | Write-Host
echo 'Extract Success!' 
$MergeDepotTool = "$MergeDepotToolUnzipFolder\MergeDepot.exe"

git checkout master 2>&1
git status

# Call merge depot
# echo "Clean merge depot"
# Copy-Item ".\mergedepot\.manifest.json" -Destination ".\.optemp\.manifest.json"
# remove-item -path ".\mergedepot" -Force -Recurse
# New-Item "mergedepot" -ItemType Directory
# Copy-Item ".\.optemp\.manifest.json" -Destination ".\mergedepot\.manifest.json"

echo "Start to call merge depot tool"
&"$MergeDepotTool" "$currentFolder\mergedepot"
echo "Finish calling merge depot tool"

echo "Start to push to git repository"
git config --global core.safecrlf false
git add * -A -v
git commit -m "update" -v
git push origin master -v
echo "Finish pushing to git repository"