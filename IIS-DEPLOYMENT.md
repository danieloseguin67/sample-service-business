# Service Business - IIS Deployment Guide

This guide will help you deploy the Service Business Angular application to IIS on your devai computer.

## Prerequisites

1. **Windows with IIS enabled**
   - Internet Information Services (IIS)
   - IIS Management Console
   - Static Content feature
   - Default Document feature

2. **URL Rewrite Module**
   - Download and install from: https://www.iis.net/downloads/microsoft/url-rewrite
   - This is required for Angular routing to work properly

3. **Node.js and npm** (for building the application)

## Quick Setup

### Method 1: Automated Setup (Recommended)

1. **Build the application:**
   ```cmd
   cd "B:\developer\daniel\organizationtools\service-business"
   npm install
   npm run build
   ```

2. **Run the setup script as Administrator:**
   - Right-click on `setup-iis.bat` and select "Run as administrator"
   - Or run PowerShell as Administrator and execute: `.\setup-iis.ps1`

3. **Access your website:**
   - Open browser and go to: http://localhost:8082

### Method 2: Manual Setup

If you prefer to set up manually or need to troubleshoot:

1. **Build the application:**
   ```cmd
   npm run build
   ```

2. **Open IIS Manager:**
   - Press Win+R, type `inetmgr`, press Enter

3. **Create Application Pool:**
   - Right-click "Application Pools" → "Add Application Pool"
   - Name: `service-business-AppPool`
   - .NET CLR Version: `No Managed Code`
   - Click OK

4. **Create Website:**
   - Right-click "Sites" → "Add Website"
   - Site name: `service-business`
   - Application pool: `service-business-AppPool`
   - Physical path: `B:\developer\daniel\organizationtools\service-business\dist\service-business\browser`
   - Port: `8082`
   - Click OK

5. **Set Permissions:**
   - Right-click on the physical path folder
   - Properties → Security → Edit
   - Add `IIS_IUSRS` with Read & Execute permissions

## Configuration Files

### web.config
The `web.config` file is automatically copied to the build output and includes:
- URL rewriting for Angular routing
- Static content caching
- Security headers
- Error handling
- MIME type configurations

### Important URLs
- **Local Development:** http://localhost:4200 (ng serve)
- **IIS Production:** http://localhost:8082

## Troubleshooting

### Common Issues:

1. **404 Errors on Angular routes:**
   - Ensure URL Rewrite Module is installed
   - Verify web.config is in the root of the website
   - Check that the rewrite rule is properly configured

2. **500 Internal Server Error:**
   - Check IIS logs in `C:\inetpub\logs\LogFiles\W3SVC1\`
   - Verify file permissions for IIS_IUSRS
   - Ensure web.config syntax is correct

3. **Static files not loading:**
   - Check that Static Content feature is enabled in IIS
   - Verify MIME type mappings in web.config
   - Check file permissions

4. **Port conflicts:**
   - Change port in the setup script or manually in IIS Manager
   - Common alternative ports: 8080, 8081, 8083

### Useful Commands:

```cmd
# Rebuild and redeploy
npm run build

# Check IIS status
iisreset /status

# Restart IIS (if needed)
iisreset /restart

# View running websites
powershell "Get-Website"
```

## Updating the Application

When you make changes to the Angular application:

1. Build the application: `npm run build`
2. The files are automatically updated in IIS (no restart needed)
3. Refresh your browser to see changes

## Security Considerations

The included web.config provides:
- XSS protection headers
- Content security policies
- MIME type security
- Server information hiding

For production deployment, consider:
- Using HTTPS (SSL certificates)
- Implementing proper authentication
- Regular security updates
- Firewall configuration

## Support

If you encounter issues:
1. Check the IIS logs
2. Verify all prerequisites are installed
3. Ensure the script was run as Administrator
4. Check Windows Event Logs for system errors

## File Structure

```
service-business/
├── dist/
│   └── service-business/
│       └── browser/          ← IIS website root
│           ├── index.html
│           ├── web.config    ← Auto-copied
│           ├── assets/
│           └── *.js, *.css files
├── setup-iis.ps1           ← PowerShell setup script
├── setup-iis.bat           ← Batch file wrapper
├── web.config               ← Source configuration
└── package.json
```