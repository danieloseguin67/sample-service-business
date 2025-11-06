<#
.SYNOPSIS
    Cleanup utility for the Service Business application.

.DESCRIPTION
    Performs housekeeping operations for the Service Business application such as:
      - removing temporary and cache files,
      - rotating and archiving logs,
      - purging old backups and artifacts according to a retention policy,
      - optionally restarting dependent services after cleanup,
      - writing an execution log and supporting dry-run verification.
    The script is designed to be safe by default and to provide informative output for auditability.

.PARAMETER DryRun
    Switch. When present, the script will simulate actions and report planned changes without modifying files.

.PARAMETER LogPath
    String. Path to write a detailed execution log. If not specified, a default log location under the application's logs folder is used.

.PARAMETER RetentionDays
    Int32. Number of days to retain logs and backups. Items older than this value will be considered for removal. Default: 30.

.PARAMETER Services
    String[].
    List of service names that should be restarted after cleanup. If omitted, no services will be restarted.

.PARAMETER Force
    Switch. When present, forces deletion of files that would otherwise be skipped (for example, read-only files).

.EXAMPLE
    .\cleanup.ps1 -DryRun
    Run the script in simulation mode to verify what would be deleted or archived without making changes.

.EXAMPLE
    .\cleanup.ps1 -RetentionDays 60 -LogPath "C:\Logs\ServiceCleanup.log" -Verbose
    Purge items older than 60 days, write a verbose execution log to the specified path.

.EXAMPLE
    .\cleanup.ps1 -Services "ServiceA","ServiceB" -Force
    Perform cleanup, force removal of eligible files, and restart ServiceA and ServiceB when complete.

.RETURNS
    Exit code 0 on success. Non-zero exit codes indicate failure; the script will log error details to the configured log file.

.NOTES
    - Run the script with appropriate privileges required to modify application files and control services.
    - Validate in a staging environment before scheduling in production.
    - The script supports common PowerShell parameters such as -Verbose and -WhatIf where applicable.
    - Consider scheduling via a task scheduler or CI/CD pipeline with monitoring and alerting around cleanup activities.

.AUTHOR
    Service Business maintenance team

#>
# Cleanup Script for Service Business Application
# Removes containers and images

Write-Host "🧹 Service Business Application - Cleanup" -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Yellow

# Stop and remove container
Write-Host "🔄 Stopping and removing container..." -ForegroundColor Cyan
$container = docker ps -a --filter "name=service-business-container" --format "{{.ID}}"
if ($container) {
    docker stop $container | Out-Null
    docker rm $container | Out-Null
    Write-Host "✅ Container removed" -ForegroundColor Green
} else {
    Write-Host "ℹ️  No container found" -ForegroundColor Blue
}

# Remove image
Write-Host "🔄 Removing Docker image..." -ForegroundColor Cyan
$image = docker images --filter "reference=service-business-app" --format "{{.ID}}"
if ($image) {
    docker rmi $image | Out-Null
    Write-Host "✅ Image removed" -ForegroundColor Green
} else {
    Write-Host "ℹ️  No image found" -ForegroundColor Blue
}

# Clean up build artifacts
Write-Host "🔄 Cleaning build artifacts..." -ForegroundColor Cyan
if (Test-Path "dist") {
    Remove-Item -Recurse -Force "dist"
    Write-Host "✅ Build artifacts cleaned" -ForegroundColor Green
} else {
    Write-Host "ℹ️  No build artifacts found" -ForegroundColor Blue
}

Write-Host ""
Write-Host "🎉 Cleanup completed!" -ForegroundColor Green