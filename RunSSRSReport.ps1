#Debug 
#...APX_RunSSRS.ps1 -server "" -reportPath "" -parameters "" -exportType "EXCEL" -fileName ""

param
(
    [string]$server = "",
    [string]$reportPath = "",
    [string]$parameters = "", #string with `n between
    [string]$exportType = "EXCELOPENXML",
    [string]$fileName = "" 
)

#Need to load assembly if not already, webfoms assembly might work also.
Add-Type -AssemblyName "Microsoft.ReportViewer.WinForms, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"

#Start here

#build hash table from string
#string format: <name>=<value>`n<name>=<value>
$hashParameters = ConvertFrom-StringData $parameters

#convert date parameters from APX
[array]$keys = $null
ForEach($key in @($hashParameters.Keys)) 
{
    If($key -like "*date*")
    {
        $keys += $key
    }
}

ForEach($key in $keys)
{
    If($hashParameters[$key].Length -eq 6)
    {
        $hashParameters[$key] = (($hashParameters[$key]).Substring(0,2) + "/" + ($hashParameters[$key]).Substring(2,2) + "/" + ($hashParameters[$key]).Substring(4,2))
    }
}

#Create report viewer object
$rv = New-Object Microsoft.Reporting.WinForms.ReportViewer
$rv.ServerReport.ReportServerUrl = $server
$rv.ServerReport.ReportPath = $reportPath
$rv.ProcessingMode = "Remote" #This is needed to use server resources for report generation

#Set parameters
#multi-value parameters pass in as string. Syntax, val = [string[]]('a','b')
$params = New-Object 'Microsoft.Reporting.WinForms.ReportParameter[]' $hashParameters.Count #parameter array
$i = 0

foreach($p in $hashParameters.GetEnumerator()) #$parameters may need to be reset if used again.
{
    $params[$i] = New-Object Microsoft.Reporting.WinForms.ReportParameter($p.Name, $p.Value, $false)
    $i++
}
$rv.ServerReport.SetParameters($params)

#configure render formatting
$mimeType = $null 
$encoding = $null 
$extension = $null 
$streamids = $null 
$warnings = $null

$bytes = $null 
$bytes = $rv.ServerReport.Render(
    $exportType, #file type to render as
    $null,
    [ref] $mimeType,
    [ref] $encoding,
    [ref] $extension,
    [ref] $streamids,
    [ref] $warnings
) 

#Export report, save using file stream
$fileStream = New-Object System.IO.FileStream($fileName, [System.IO.FileMode]::OpenOrCreate)
$fileStream.Write($bytes, 0, $bytes.Length)
$fileStream.Close()