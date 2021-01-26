
#Specify a start directory or file and end directory
param (
    [string]$startPath, 
    [string]$endPath,
    [bool]$includeSubfolders
)

#Debug
#$startPath = ""
#$endPath = ""
#$includeSubfolders = $false

$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))

if ((Test-Path $startPath) -eq $false) 
{
    Write-Host "Source folder or file does not exist."
    return
}

if((Test-Path $endPath) -eq $false) 
{
    $message = "Path does not exist."
    $question =  "Create a new folder?"
    
    $decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)

    if ($decision)
    {
        New-Item -ItemType "directory" -Path $endPath
    }
    else {
        Write-Host "Request cancelled"
        return
    }        
}

if($includeSubfolders) 
{
    Get-ChildItem -Path $startPath | Copy-Item -Destination $endPath -Recurse
}
else 
{
    Get-ChildItem -Path $startPath | Copy-Item -Destination $endPath
}



