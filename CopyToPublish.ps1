echo "Bypass Build."
$copySourceFolder = Join-Path $repositoryRoot "mergedepotdynamic"
$copyTargetFolder = Join-Path $OutputFolder "mergedepotdynamic"
echo "Start copying files and folders from $copySourceFolder to $copyTargetFolder."
Copy-Item $copySourceFolder $copyTargetFolder -recurse
echo "Finish copying files and folders from $copySourceFolder to $copyTargetFolder."
