param(
    [string]$ProjectRoot = "C:\Users\dinusha dilshan\Desktop\smart-boys-fashion\smart-boys-fashion",
    [string]$TomcatHome = "C:\Users\dinusha dilshan\apache-tomcat-10",
    [string]$LoginUrl = "http://localhost:8081/smart-boys-fashion/admin/login",
    [string]$UploadUrl = "http://localhost:8081/smart-boys-fashion/admin/products"
)

$warSource = Join-Path $ProjectRoot 'target\smart-boys-fashion.war'
$warDest = Join-Path $TomcatHome 'webapps\smart-boys-fashion.war'

if (-not (Test-Path $warSource)) {
    Write-Error "WAR not found: $warSource"
    exit 1
}

Copy-Item -Path $warSource -Destination $warDest -Force
Write-Host "Copied WAR to $warDest"

Write-Host "Stopping Tomcat..."
& "${TomcatHome}\bin\shutdown.bat"
Start-Sleep -Seconds 3

Write-Host "Starting Tomcat..."
& "${TomcatHome}\bin\startup.bat"
Start-Sleep -Seconds 8

function Wait-AppReady {
    param([string]$Url, [int]$Retries = 15, [int]$Delay = 2)
    for ($i = 0; $i -lt $Retries; $i++) {
        try {
            $r = Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec 5
            Write-Host "App ready: $($r.StatusCode)"
            return $true
        } catch {
            Write-Host "Waiting for app... ($($i+1)/$Retries)"
            Start-Sleep -Seconds $Delay
        }
    }
    return $false
}

if (-not (Wait-AppReady -Url 'http://localhost:8081/smart-boys-fashion')) {
    Write-Error "App did not become ready on http://localhost:8081/smart-boys-fashion"
    exit 1
}

# Create test PNG
$pngPath = Join-Path $env:TEMP 'test-upload.png'
$base64 = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR4nGNgYAAAAAMAASsJTYQAAAAASUVORK5CYII='
[System.IO.File]::WriteAllBytes($pngPath, [System.Convert]::FromBase64String($base64))
Write-Host "Created test image: $pngPath"

# Build multipart form data
Add-Type -AssemblyName System.Net.Http
$content = [System.Net.Http.MultipartFormDataContent]::new()
$values = @{
    categoryId = '1'
    productName = 'TestUpload'
    description = 'uploaded test'
    price = '9.99'
    color = 'Blue'
    sizeLabel = 'S'
    minAge = '1'
    maxAge = '3'
    stockQty = '10'
    lowStockLimit = '1'
    active = 'on'
}
foreach ($key in $values.Keys) {
    $content.Add([System.Net.Http.StringContent]::new($values[$key]), $key)
}
$fileStream = [System.IO.File]::OpenRead($pngPath)
$fileContent = [System.Net.Http.StreamContent]::new($fileStream)
$fileContent.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::Parse('image/png')
$content.Add($fileContent, 'imageFile', 'test-upload.png')

$handler = [System.Net.Http.HttpClientHandler]::new()
$handler.CookieContainer = [System.Net.CookieContainer]::new()
$handler.AllowAutoRedirect = $true
$client = [System.Net.Http.HttpClient]::new($handler)

# Perform admin login
$loginValues = [System.Collections.Generic.List[System.Collections.Generic.KeyValuePair[string,string]]]::new()
$loginValues.Add([System.Collections.Generic.KeyValuePair[string,string]]::new('email','owner@smartboys.lk'))
$loginValues.Add([System.Collections.Generic.KeyValuePair[string,string]]::new('password','admin123'))
$loginContent = [System.Net.Http.FormUrlEncodedContent]::new($loginValues)
$loginResponse = $client.PostAsync($LoginUrl, $loginContent).GetAwaiter().GetResult()
Write-Host "Login status: $($loginResponse.StatusCode)"
$loginBody = $loginResponse.Content.ReadAsStringAsync().GetAwaiter().GetResult()
Write-Host "Login response length: $($loginBody.Length)"

# Perform upload
$uploadContent = [System.Net.Http.MultipartFormDataContent]::new()
$values = @{
    categoryId = '1'
    productName = 'TestUpload'
    description = 'uploaded test'
    price = '9.99'
    color = 'Blue'
    sizeLabel = 'S'
    minAge = '1'
    maxAge = '3'
    stockQty = '10'
    lowStockLimit = '1'
    active = 'on'
}
foreach ($key in $values.Keys) {
    $uploadContent.Add([System.Net.Http.StringContent]::new($values[$key]), $key)
}
$fileStream = [System.IO.File]::OpenRead($pngPath)
$fileContent = [System.Net.Http.StreamContent]::new($fileStream)
$fileContent.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::Parse('image/png')
$uploadContent.Add($fileContent, 'imageFile', 'test-upload.png')

$uploadResponse = $client.PostAsync($UploadUrl, $uploadContent).GetAwaiter().GetResult()
Write-Host "Upload status: $($uploadResponse.StatusCode)"
$uploadBody = $uploadResponse.Content.ReadAsStringAsync().GetAwaiter().GetResult()
Write-Host "Upload response length: $($uploadBody.Length)"
Write-Host "Upload response snippet:"
Write-Host ($uploadBody.Substring(0, [Math]::Min(400, $uploadBody.Length)))

$fileStream.Dispose()
$uploadContent.Dispose()
$client.Dispose()

Write-Host "Upload test completed."