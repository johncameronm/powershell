function Add-Scripts {
    param (
            [string[]]$scripts
        )

        foreach($script in $scripts) {
            [string]$text = (Get-Content ".$script" ) -join "`n"
            Add-Content -Path ".${folderPath}${fileName}" -Value $text
        }
}

#execute script in local git repo folder
try {
    #combined sql
    $fileName = "scripts.sql"
    #local git folder
    $folderPath = ".\"

    if(!(Test-Path -Path "${folderPath}")) {
        New-Item -Path "${folderPath}" -ItemType Directory
    }
    if(!(Test-Path -Path "${folderPath}${fileName}")) {
        New-Item -Path "${folderPath}${fileName}" -ItemType File
    }

    [string[]]$scripts = git diff origin/master --name-only | Where-Object {$_ -like "*.sql"}

    $tables = $scripts | Where-Object {$_ -like "*/Tables/*"}
    $procs = $scripts | Where-Object {$_ -like "*/Stored Procedures/*"}
    $views = $scripts | Where-Object {$_ -like "*/Views/*"}
    $funcs = $scripts | Where-Object {$_ -like "*/Functions/*"}

    if($tables) {Add-Scripts -scripts $tables}
    if($views) {Add-Scripts -scripts $views}
    if($procs) {Add-Scripts -scripts $procs}
    if($funcs) {Add-Scripts -scripts $funcs}
}
catch {     
    Write-Host "Script Failed : $s" -BackgroundColor Red -ForegroundColor White
    Write-Host $_.Exception.GetType().FullName  -BackgroundColor Red -ForegroundColor White
    Write-Host $_.Exception.Message  -BackgroundColor Red -ForegroundColor White
    #Write-Host $_.Exception -BackgroundColor Red -ForegroundColor White
    Break
}