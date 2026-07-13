param(
    [string]$TomcatPath = $env:CATALINA_HOME
)

function Fail([string]$msg){ Write-Error $msg; exit 1 }

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
if (-not $TomcatPath) {
    Write-Host "CATALINA_HOME not set and no Tomcat path provided."
    $TomcatPath = Read-Host "Enter Tomcat installation path (e.g. C:\tomcat)"
}

if (-not (Test-Path $TomcatPath)) { Fail "Tomcat path '$TomcatPath' not found." }

$mvn = Get-Command mvn -ErrorAction SilentlyContinue
Push-Location $projectRoot
try {
    if ($mvn) {
        Write-Host "Maven detected. Building with mvn clean package..."
        mvn clean package -DskipTests
        $war = Get-ChildItem -Path .\target -Filter *.war | Select-Object -Last 1
        if (-not $war) { Fail "No WAR produced by Maven." }
    }
    else {
        Write-Host "Maven not found. Attempting to assemble WAR from project files."
        $temp = Join-Path $env:TEMP "smartboys_war_$(Get-Random)"
        New-Item -ItemType Directory -Path $temp | Out-Null

        # Copy webapp contents
        $webappSrc = Join-Path $projectRoot 'src\main\webapp'
        if (-not (Test-Path $webappSrc)) { Fail "Webapp folder not found: $webappSrc" }
        Copy-Item -Path (Join-Path $webappSrc '*') -Destination $temp -Recurse

        # Ensure WEB-INF\classes exists and copy compiled classes if available
        $classesSrc = Join-Path $projectRoot 'target\classes'
        $classesDest = Join-Path $temp 'WEB-INF\classes'
        New-Item -ItemType Directory -Path $classesDest -Force | Out-Null
        if (Test-Path $classesSrc) { Copy-Item -Path (Join-Path $classesSrc '*') -Destination $classesDest -Recurse }
        else { Write-Warning "Compiled classes not found at target\classes. The webapp may fail without compilation." }

        # Create WAR by zipping the folder
        $warPath = Join-Path $projectRoot 'target\smart-boys-fashion.war'
        if (Test-Path $warPath) { Remove-Item $warPath -Force }
        Compress-Archive -Path (Join-Path $temp '*') -DestinationPath $warPath
        $war = Get-Item $warPath
        Remove-Item -Recurse -Force $temp
        Write-Host "WAR assembled at $($war.FullName)"
    }

    # Deploy WAR to Tomcat
    $dest = Join-Path $TomcatPath 'webapps'
    if (-not (Test-Path $dest)) { Fail "Tomcat webapps folder not found at $dest" }
    Copy-Item -Path $war.FullName -Destination $dest -Force
    Write-Host "Copied $($war.Name) to $dest"

    # Start Tomcat
    $startup = Join-Path $TomcatPath 'bin\startup.bat'
    if (Test-Path $startup) {
        Write-Host "Starting Tomcat..."
        Start-Process -FilePath $startup
        Write-Host "Tomcat started (or already running). Visit http://localhost:8080/$($war.BaseName)"
    }
    else { Write-Warning "Tomcat startup script not found at $startup. Please start Tomcat manually." }
}
finally { Pop-Location }
