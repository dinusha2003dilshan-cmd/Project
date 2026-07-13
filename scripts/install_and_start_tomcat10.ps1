$tomcat10='C:\apache-tomcat-10'
$zip='C:\apache-tomcat-10.zip'
if(Test-Path $tomcat10){ Write-Host "Removing existing $tomcat10"; Remove-Item -Recurse -Force $tomcat10 }

$url='https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.14/bin/apache-tomcat-10.1.14-windows-x64.zip'
Write-Host "Downloading Tomcat 10 from $url"
Invoke-WebRequest -Uri $url -OutFile $zip -UseBasicParsing
Write-Host "Extracting Tomcat to C:\"
Expand-Archive -Path $zip -DestinationPath C:\ -Force
if(Test-Path 'C:\apache-tomcat-10.1.14') { Rename-Item -Path 'C:\apache-tomcat-10.1.14' -NewName 'apache-tomcat-10' }
Remove-Item $zip -Force

$server='C:\apache-tomcat-10\conf\server.xml'
if(-not (Test-Path $server)){
    Write-Host "server.xml not found at $server"; exit 1
}

# Change shutdown port to 8006 and HTTP connector to 8081
$content = Get-Content $server
$content = $content -replace 'port="8005"','port="8006"'
$content = $content -replace '(?<=<Connector[^>]*port=")8080(?=")','8081'
Set-Content -Path $server -Value $content -Encoding UTF8
Write-Host "Updated server.xml ports"

# Copy WAR
$warSrc='c:\Users\dinusha dilshan\Desktop\smart-boys-fashion\smart-boys-fashion\target\smart-boys-fashion.war'
if(-not (Test-Path $warSrc)){ Write-Host "WAR not found at $warSrc"; exit 1 }
Copy-Item -Path $warSrc -Destination "$tomcat10\webapps\" -Force
Write-Host "WAR copied to $tomcat10\webapps\"

# Start Tomcat
$env:JAVA_HOME='C:\Program Files\Java\jdk-23'
$env:CATALINA_HOME=$tomcat10
Write-Host "Starting Tomcat 10"
& "$tomcat10\bin\startup.bat"
Start-Sleep -s 5

# Poll the app
$urlApp='http://localhost:8081/smart-boys-fashion'
for($i=0;$i -lt 20;$i++){
    try{
        $r=Invoke-WebRequest -Uri $urlApp -UseBasicParsing -TimeoutSec 5
        Write-Host "HTTP_STATUS: $($r.StatusCode)"
        break
    }catch{
        Write-Host "TRY $($i+1) FAILED: $($_.Exception.Message)"
        Start-Sleep -s 2
    }
}
