
$base = "C:\"
$server1 = "svr1name", "svr1path"
$server2 = "svr2name", "svr2path"
$server3 = "svr3name", "svr3path"
$elements = $server1, $server2, $server3

foreach($element in $elements){
    $localScriptRoot = $element[0]
    $Server = $element[1]
    $scripts = Get-ChildItem "$base\$localScriptRoot" | Where-Object {$_.Extension -eq ".sql"} | Sort-Object
    try {
    foreach ($s in $scripts)
    {
        Write-Host "Running Script : " $s.Name -BackgroundColor DarkGreen -ForegroundColor White
        $script = $s.FullName
        Invoke-Sqlcmd -ServerInstance $Server -InputFile $script       
        #Write-Host "Script Complete : " $s.Name -BackgroundColor DarkGreen -ForegroundColor White
    }
    }
    catch {
        Write-Host $s.FullName
    }
}