param(
    [string]$InstallPath = "C:\Users\dinusha dilshan\apache-tomcat-10",
    [string]$WarSource = "c:\Users\dinusha dilshan\Desktop\smart-boys-fashion\smart-boys-fashion\target\smart-boys-fashion.war",
    [string]$TomcatUrl = 'https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.14/bin/apache-tomcat-10.1.14-windows-x64.zip'
)

$zip = Join-Path $env:TEMP 'tomcat10.zip'
if(Test-Path $InstallPath){ Write-Host "Removing existing $InstallPath"; Remove-Item -Recurse -Force $InstallPath }

Write-Host "Downloading Tomcat 10..."
Invoke-WebRequest -Uri $TomcatUrl -OutFile $zip -UseBasicParsing

Write-Host "Extracting Tomcat..."
Expand-Archive -Path $zip -DestinationPath $env:TEMP -Force
$extracted = Join-Path $env:TEMP 'apache-tomcat-10.1.14'
if(-not (Test-Path $extracted)){
    Write-Error "Extraction failed; expected folder $extracted not found"
    exit 1
}

Move-Item -Path $extracted -Destination $InstallPath
Remove-Item $zip -Force
Write-Host "Tomcat installed to $InstallPath"

$server = Join-Path $InstallPath 'conf\server.xml'
Write-Host "Updating ports in $server"
$content = Get-Content $server -Raw
$content = $content -replace 'port="8005"','port="8006"'
$content = $content -replace 'port="8080"','port="8081"'
Set-Content -Path $server -Value $content -Encoding UTF8

if(-not (Test-Path $WarSource)){
    Write-Error "WAR not found at $WarSource"
    exit 1
}
Copy-Item -Path $WarSource -Destination (Join-Path $InstallPath 'webapps') -Force
Write-Host "WAR deployed to webapps"

$env:JAVA_HOME='C:\Program Files\Java\jdk-23'
$env:CATALINA_HOME=$InstallPath
Write-Host "Starting Tomcat from $InstallPath"
& "${InstallPath}\bin\startup.bat"
Start-Sleep -s 5

# Poll
$urlApp = 'http://localhost:8081/smart-boys-fashion'
for($i=0;$i -lt 20;$i++){
    try{
        $r = Invoke-WebRequest -Uri $urlApp -UseBasicParsing -TimeoutSec 5
        Write-Host "HTTP_STATUS: $($r.StatusCode)"
        exit 0
    }catch{
        Write-Host "TRY $($i+1) FAILED: $($_.Exception.Message)"
        Start-Sleep -s 2
    }
}
Write-Error "App did not respond on http://localhost:8081/smart-boys-fashion"
exit 2
