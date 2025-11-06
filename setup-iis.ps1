# PowerShell script to set up service-business website in IIS
# Run this script as Administrator

param(
    [Parameter(Mandatory=$false)]
    [string]$SiteName = "service-business",
    
    [Parameter(Mandatory=$false)]
    [string]$Port = "8082",
    
    [Parameter(Mandatory=$false)]
    [string]$PhysicalPath = "B:\developer\daniel\organizationtools\service-business\dist\service-business\browser"
)

# Import IIS module
Import-Module WebAdministration

Write-Host "Setting up IIS website for Service Business Application..." -ForegroundColor Green

# Check if IIS is installed and enabled
$iisFeature = Get-WindowsOptionalFeature -Online -FeatureName "IIS-WebServerRole"
if ($iisFeature.State -ne "Enabled") {
    Write-Host "IIS is not enabled. Enabling IIS features..." -ForegroundColor Yellow
    
    # Enable IIS and required features
    Enable-WindowsOptionalFeature -Online -FeatureName "IIS-WebServerRole" -All
    Enable-WindowsOptionalFeature -Online -FeatureName "IIS-WebServer" -All
    Enable-WindowsOptionalFeature -Online -FeatureName "IIS-CommonHttpFeatures" -All
    Enable-WindowsOptionalFeature -Online -FeatureName "IIS-HttpErrors" -All
    Enable-WindowsOptionalFeature -Online -FeatureName "IIS-HttpRedirect" -All
    Enable-WindowsOptionalFeature -Online -FeatureName "IIS-ApplicationDevelopment" -All
    Enable-WindowsOptionalFeature -Online -FeatureName "IIS-StaticContent" -All
    Enable-WindowsOptionalFeature -Online -FeatureName "IIS-DefaultDocument" -All
    Enable-WindowsOptionalFeature -Online -FeatureName "IIS-DirectoryBrowsing" -All
    Enable-WindowsOptionalFeature -Online -FeatureName "IIS-UrlRewrite" -All
    
    Write-Host "IIS features have been enabled. Please restart your computer and run this script again." -ForegroundColor Red
    return
}

# Check if URL Rewrite Module is installed
$rewriteModule = Get-WindowsFeature -Name "IIS-URLRewrite" -ErrorAction SilentlyContinue
if (-not $rewriteModule -or $rewriteModule.InstallState -ne "Installed") {
    Write-Host "URL Rewrite Module is required for Angular routing. Please install it from:" -ForegroundColor Red
    Write-Host "https://www.iis.net/downloads/microsoft/url-rewrite" -ForegroundColor Yellow
    Write-Host "Then run this script again." -ForegroundColor Yellow
    return
}

# Check if the physical path exists
if (-not (Test-Path $PhysicalPath)) {
    Write-Host "Physical path does not exist: $PhysicalPath" -ForegroundColor Red
    Write-Host "Please build the Angular application first using: npm run build" -ForegroundColor Yellow
    return
}

# Remove existing website if it exists
$existingSite = Get-Website -Name $SiteName -ErrorAction SilentlyContinue
if ($existingSite) {
    Write-Host "Removing existing website: $SiteName" -ForegroundColor Yellow
    Remove-Website -Name $SiteName
}

# Create application pool
$appPoolName = "$SiteName-AppPool"
$existingAppPool = Get-IISAppPool -Name $appPoolName -ErrorAction SilentlyContinue
if ($existingAppPool) {
    Write-Host "Removing existing application pool: $appPoolName" -ForegroundColor Yellow
    Remove-WebAppPool -Name $appPoolName
}

Write-Host "Creating application pool: $appPoolName" -ForegroundColor Green
New-WebAppPool -Name $appPoolName -Force
Set-ItemProperty -Path "IIS:\AppPools\$appPoolName" -Name "processModel.identityType" -Value "ApplicationPoolIdentity"
Set-ItemProperty -Path "IIS:\AppPools\$appPoolName" -Name "managedRuntimeVersion" -Value ""  # No managed code for static files

# Create website
Write-Host "Creating website: $SiteName" -ForegroundColor Green
New-Website -Name $SiteName -Port $Port -PhysicalPath $PhysicalPath -ApplicationPool $appPoolName

# Copy web.config to the build output directory
$webConfigSource = "B:\developer\daniel\organizationtools\service-business\web.config"
$webConfigDestination = "$PhysicalPath\web.config"

if (Test-Path $webConfigSource) {
    Copy-Item -Path $webConfigSource -Destination $webConfigDestination -Force
    Write-Host "Copied web.config to build output directory" -ForegroundColor Green
} else {
    Write-Host "Warning: web.config not found at $webConfigSource" -ForegroundColor Yellow
}

# Set proper permissions for IIS_IUSRS
Write-Host "Setting permissions for IIS_IUSRS..." -ForegroundColor Green
$acl = Get-Acl $PhysicalPath
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("IIS_IUSRS", "ReadAndExecute", "ContainerInherit,ObjectInherit", "None", "Allow")
$acl.SetAccessRule($accessRule)
Set-Acl -Path $PhysicalPath -AclObject $acl

Write-Host "Website setup completed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Website Details:" -ForegroundColor Cyan
Write-Host "  Name: $SiteName" -ForegroundColor White
Write-Host "  URL: http://localhost:$Port" -ForegroundColor White
Write-Host "  Physical Path: $PhysicalPath" -ForegroundColor White
Write-Host "  Application Pool: $appPoolName" -ForegroundColor White
Write-Host ""
Write-Host "You can now access your Service Business website at: http://localhost:$Port" -ForegroundColor Green
Write-Host ""
Write-Host "To manage the website:" -ForegroundColor Yellow
Write-Host "  - Open IIS Manager (inetmgr)" -ForegroundColor White
Write-Host "  - Navigate to Sites > $SiteName" -ForegroundColor White
Write-Host ""
Write-Host "To rebuild and redeploy:" -ForegroundColor Yellow
Write-Host "  1. Run 'npm run build' in the project directory" -ForegroundColor White
Write-Host "  2. The files will be automatically updated in IIS" -ForegroundColor White

# Optional: Start the website
$website = Get-Website -Name $SiteName
if ($website.State -eq "Stopped") {
    Start-Website -Name $SiteName
    Write-Host "Website started successfully!" -ForegroundColor Green
}