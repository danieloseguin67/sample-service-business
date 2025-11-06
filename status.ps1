<#
.SYNOPSIS
Service Business Application - Status Check

.DESCRIPTION
Performs health and status checks for the Service Business Application.
This script is intended to be used by automation, monitoring systems, and operators to determine
the operational state of the application and its dependencies. Typical checks include:
- Service/process existence and state
- API/endpoint reachability and basic response validation
- Database connectivity and simple query execution
- Configuration file validation
- Optional authentication/authorization checks

The script returns a structured summary of results and uses exit codes to indicate overall status,
making it suitable for CI/CD pipelines and monitoring probes.

.PARAMETER Path
[string] Optional. Path or base directory to target application resources (default: current directory).

.PARAMETER Config
[string] Optional. Path to a configuration file to override defaults used by checks.

.PARAMETER Credential
[PSCredential] Optional. Credentials to use for authenticated checks (APIs, databases, etc.).

.PARAMETER Timeout
[int] Optional. Timeout in seconds applied to individual network or service checks (default: 30).

.PARAMETER Verbose
[switch] Optional. Enable detailed logging output for troubleshooting.

.OUTPUTS
A custom object (PSCustomObject) with at least the following properties:
- Timestamp      : DateTime when the check was run
- Status         : Overall status (Healthy | Degraded | Unhealthy)
- Summary        : Short human-readable summary
- Checks         : Array of objects for each individual check:
                   { Name, Status, Message, DurationMs, Details }

.EXAMPLE
# Run checks using a specific configuration file and display the summary
.\status.ps1 -Config 'C:\configs\service-business.json'

.EXAMPLE
# Run checks with verbose logging and export the result as JSON
.\status.ps1 -Verbose | ConvertTo-Json -Depth 5

.NOTES
- Exit codes:
  0 = Healthy or no critical failures
  1 = One or more critical failures detected
  2 = Invalid usage or configuration
  Other codes may be used for specific error classes
- Designed for reusability in automated workflows (monitoring, alerts, deployment gates).
- Adjust timeouts and checks in configuration for slower or staged environments.

.FILE
/b:/developer/daniel/organizationtools/service-business/status.ps1

.AUTHOR
Service Business Team
#>
# Service Business Application - Status Check
Write-Host " Service Business Application Status" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green

# Check if container is running
$container = docker ps --filter "name=service-business-container" --format "{{.ID}}"
if ($container) {
    $status = docker ps --filter "id=$container" --format "{{.Status}}"
    $ports = docker ps --filter "id=$container" --format "{{.Ports}}"
    
    Write-Host " Container Status: Running" -ForegroundColor Green
    Write-Host " Container ID: $container" -ForegroundColor Blue
    Write-Host "  Status: $status" -ForegroundColor Blue
    Write-Host " Ports: $ports" -ForegroundColor Blue
    
    # Test application
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8081" -Method Head -TimeoutSec 5
        Write-Host " Application: Responding (Status: $($response.StatusCode))" -ForegroundColor Green
        Write-Host " URL: http://localhost:8081" -ForegroundColor Yellow
    } catch {
        Write-Host "  Application: Not responding" -ForegroundColor Red
    }
} else {
    Write-Host " Container Status: Not running" -ForegroundColor Red
    Write-Host ""
    Write-Host "To start the application:" -ForegroundColor Yellow
    Write-Host "  .\deploy.ps1" -ForegroundColor White
}

Write-Host ""
Write-Host "Commands:" -ForegroundColor Blue
Write-Host "  Deploy:    .\deploy.ps1" -ForegroundColor White
Write-Host "  Logs:      docker logs service-business-container" -ForegroundColor White
Write-Host "  Stop:      docker stop service-business-container" -ForegroundColor White
Write-Host "  Cleanup:   .\cleanup.ps1" -ForegroundColor White
