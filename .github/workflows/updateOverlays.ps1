Install-Module -Name powershell-yaml
Import-Module powershell-yaml

param (    
    $overlayEnvironment,
    $imageTag    
)

function Load-Yaml {
    param (
        $FileName
    )

    [string[]]$fileContent = Get-Content $FileName
    $content = ''
    
    foreach ($line in $fileContent) 
    { 
        $content = $content + "`n" + $line 
    }
    
    $yml = ConvertFrom-YAML $content
    
    return $yml
}
 
function Write-Yaml {
    param (
        $FileName,
        $Content
    )
	
    $result = ConvertTo-YAML $Content
    
    Set-Content -Path $FileName -Value $result
}

$overlayEnvironment = "dev"
$imageTag = "0.1.33-versiondisplay.4"

$overlayFileName = "..\..\k8s\overlays\$($overlayEnvironment)\kustomization.yaml"
Write-Host "Loading $overlayFileName"
$overlayYaml = Load-Yaml -FileName $overlayFileName

Write-host "Setting the first image tag to $imageTag"
$overlayYaml.Images[0].newTag = $imageTag

Write-Host "Updating $overlayFileName with the new content"
Write-Yaml -FileName $overlayFileName -Content $overlayYaml
