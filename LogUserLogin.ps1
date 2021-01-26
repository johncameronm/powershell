$path = "X:\Code\Powershell\LogUserLogins\UserLogins_" + (Get-Date -UFormat %Y%m%d).ToString() + ".log"

if ((Test-Path -Path $path) -eq $false)
{
    $file = New-Item -Path $path -ItemType "file"
    Add-Content -Path $path -Value "<Logins>"
}

$fileString = (Get-Content -Path $file.PSPath).ToString().Replace("</Logins>","")
$fileString

$fileString = $fileString + "<Login>"+
"<User>" + $env:UserName + "</User>" +
"<Domain>" + $env:UserDomain + "</Domain>" +
"<Computer>" + $env:COMPUTERNAME + "</Computer>" +
"<Time>" + (Get-Date).ToString()+ "</Time>" +
"</Login>" +
"</Logins>"

Set-Content -Path $file.PSPath -Value $fileString