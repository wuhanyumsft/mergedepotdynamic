Param(
  [string]$DhsConnectionConfigs
)

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
Invoke-WebRequest -Uri $MergeDepotToolSource -OutFile $MergeDepotToolDestination
echo 'Download Success!'

$MergeDepotToolUnzipFolder = "$currentFolder\.optemp\MergeDepotTool"
if((Test-Path "$MergeDepotToolUnzipFolder"))
{
    Remove-Item $MergeDepotToolUnzipFolder -Force -Recurse
}

[System.IO.Compression.ZipFile]::ExtractToDirectory($MergeDepotToolDestination, $MergeDepotToolUnzipFolder)
echo 'Extract Success!' 
$MergeDepotTool = "$MergeDepotToolUnzipFolder\MergeDepot.exe"

git checkout master 2>&1 | Write-Host
git status

echo "Start to call merge depot tool"
&"$MergeDepotTool" "$currentFolder\mergedepot" "-c" "$DhsConnectionConfigs"
echo "Finish calling merge depot tool"

echo "Start to push to git repository"
git config --global core.safecrlf false
git add * -A -v
echo "Finish Git add."
git commit -m "update" 2>&1 | Write-Host
git push origin master 2>&1 | Write-Host
echo "Finish pushing to git repository"