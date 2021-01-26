[string]$server = ""
[string]$token = ""
[string]$group = ""


[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ids = Invoke-RestMethod -Uri https://$server/api/v4/groups/$group/projects -Method Get -Headers @{ "PRIVATE-TOKEN"="$token" } 
$filterDate = $filterDate = (Get-Date).AddDays(-2)



Write-Host "Completed Commits"
foreach($id in $ids) {
    $projectId = $id.id
    Write-Host "Project Name: " $id.name
    $commits = Invoke-RestMethod -Uri https://$server/api/v4/projects/$projectId/repository/commits -Method Get -Headers @{ "PRIVATE-TOKEN"="$token" }
    $commits | Where -Property committer_name -like -Value 'Maxey, John' 
#Where -and committed_date -gt  (Get-date).AddDays(-2)
#Where -Property committer_name -Contains -Value 'john'
#Format-Table -Property committer_name, committed_date, message , committed-date

<#
Write-Host "Pending Merge Requests"
foreach($id in $ids) {
    #$id.name
    $projectId = $id.id
    $openMerge = Invoke-RestMethod -Uri https://$server/api/v4/projects/$projectId/merge_requests/?state=opened -Method Get -Headers @{ "PRIVATE-TOKEN"="$token" }
    $openMerge  | Format-List -property title, description, web_url, source_branch, target_branch, created_at, author

}#>