# Frontend Setup Script
# Sets up Blazor WebAssembly frontend with .NET dependencies

param(
    [string]$ProjectRoot = ".",
    [switch]$StartServer
)

Write-Host "🌐 Frontend Setup - Blazor WebAssembly" -ForegroundColor Green
Write-Host "=======================================" -ForegroundColor Cyan

function Test-DotNet {
    Write-Host "Checking .NET SDK installation..." -ForegroundColor Gray
    if (Get-Command dotnet -ErrorAction SilentlyContinue) {
        $version = (dotnet --version) 2>&1
        Write-Host "✅ .NET SDK $version" -ForegroundColor Green
        return $true
    } else {
        Write-Host "❌ .NET SDK not found. Please install .NET 8.0 SDK from https://dotnet.microsoft.com" -ForegroundColor Red
        return $false
    }
}

function Test-BlazorProject {
    Write-Host "`nChecking Blazor project structure..." -ForegroundColor Gray
    
    $projectFile = "$ProjectRoot/frontend/SmartEnterprise.Blazor/SmartEnterprise.Blazor.csproj"
    if (Test-Path $projectFile) {
        Write-Host "✅ Blazor project file found" -ForegroundColor Green
        return $true
    } else {
        Write-Host "⚠️ Blazor project file not found at expected location: $projectFile" -ForegroundColor Yellow
        
        # Check if frontend directory exists
        if (Test-Path "$ProjectRoot/frontend") {
            Write-Host "Frontend directory exists. Looking for .csproj files..." -ForegroundColor Gray
            $projFiles = Get-ChildItem "$ProjectRoot/frontend" -Recurse -Filter "*.csproj"
            if ($projFiles.Count -gt 0) {
                Write-Host "Found project files:" -ForegroundColor Green
                foreach ($file in $projFiles) {
                    Write-Host "  📁 $($file.FullName)" -ForegroundColor Gray
                }
                return $true
            }
        }
        
        Write-Host "❌ No Blazor project files found. Frontend setup cannot continue." -ForegroundColor Red
        return $false
    }
}

function Restore-Dependencies {
    Write-Host "`nRestoring NuGet packages..." -ForegroundColor Yellow
    
    Push-Location "$ProjectRoot/frontend"
    
    try {
        Write-Host "Running dotnet restore..." -ForegroundColor Gray
        dotnet restore
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ NuGet packages restored successfully" -ForegroundColor Green
            Pop-Location
            return $true
        } else {
            throw "dotnet restore failed with exit code $LASTEXITCODE"
        }
    }
    catch {
        Write-Host "❌ Failed to restore NuGet packages: $_" -ForegroundColor Red
        Pop-Location
        return $false
    }
}

function Build-Project {
    Write-Host "`nBuilding Blazor project..." -ForegroundColor Yellow
    
    Push-Location "$ProjectRoot/frontend"
    
    try {
        Write-Host "Running dotnet build..." -ForegroundColor Gray
        dotnet build --configuration Debug --no-restore
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Blazor project built successfully" -ForegroundColor Green
            Pop-Location
            return $true
        } else {
            throw "dotnet build failed with exit code $LASTEXITCODE"
        }
    }
    catch {
        Write-Host "❌ Failed to build project: $_" -ForegroundColor Red
        Pop-Location
        return $false
    }
}

function Start-FrontendServer {
    Write-Host "`n🎯 Starting Frontend Server..." -ForegroundColor Green
    Write-Host "Frontend App: http://localhost:5000" -ForegroundColor Cyan
    Write-Host "Backend API: http://localhost:5001" -ForegroundColor Cyan
    Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Gray
    
    Push-Location "$ProjectRoot/frontend"
    
    try {
        dotnet run
    }
    catch {
        Write-Host "❌ Failed to start frontend server: $_" -ForegroundColor Red
    }
    finally {
        Pop-Location
    }
}

function Create-BasicFrontendStructure {
    Write-Host "`nCreating basic frontend structure..." -ForegroundColor Yellow
    
    # Check if we need to create a basic frontend structure
    if (-not (Test-Path "$ProjectRoot/frontend")) {
        Write-Host "Frontend directory doesn't exist. Creating basic structure..." -ForegroundColor Gray
        
        New-Item -ItemType Directory -Path "$ProjectRoot/frontend" -Force | Out-Null
        Write-Host "✅ Created frontend directory" -ForegroundColor Green
        
        Write-Host "⚠️  Note: Full Blazor frontend setup is required." -ForegroundColor Yellow
        Write-Host "    Run the frontend creation script or set up Blazor project manually." -ForegroundColor Gray
        return $false
    }
    
    return $true
}

# Main execution
try {
    Write-Host "Setting up frontend in: $(Resolve-Path $ProjectRoot)/frontend" -ForegroundColor Gray
    
    # Run setup steps
    $steps = @(
        @{ Name = ".NET SDK Check"; Function = { Test-DotNet } },
        @{ Name = "Project Structure"; Function = { Test-BlazorProject } },
        @{ Name = "Dependency Restoration"; Function = { Restore-Dependencies } },
        @{ Name = "Project Build"; Function = { Build-Project } }
    )
    
    $allSuccess = $true
    foreach ($step in $steps) {
        Write-Host "`n▶️ Step: $($step.Name)" -ForegroundColor Yellow
        $success = & $step.Function
        if (-not $success) {
            # For project structure issues, try to create basic structure
            if ($step.Name -eq "Project Structure") {
                Write-Host "Attempting to create basic frontend structure..." -ForegroundColor Yellow
                $success = Create-BasicFrontendStructure
            }
            
            if (-not $success) {
                $allSuccess = $false
                Write-Host "❌ Frontend setup failed at step: $($step.Name)" -ForegroundColor Red
                break
            }
        }
    }
    
    if ($allSuccess) {
        Write-Host "`n🎉 Frontend setup completed successfully!" -ForegroundColor Green
        
        if ($StartServer) {
            Start-FrontendServer
        } else {
            Write-Host "`nYou can start the frontend server with:" -ForegroundColor White
            Write-Host "  .\scripts\setup-frontend.ps1 -StartServer" -ForegroundColor Gray
            Write-Host "  .\scripts\setup-foundation.ps1 -StartFrontend" -ForegroundColor Gray
        }
    } else {
        Write-Host "`n💥 Frontend setup failed. Please check the errors above." -ForegroundColor Red
        Write-Host "`n📝 Next steps:" -ForegroundColor Yellow
        Write-Host "   1. Ensure .NET 8.0 SDK is installed" -ForegroundColor Gray
        Write-Host "   2. Create Blazor WebAssembly project in /frontend directory" -ForegroundColor Gray
        Write-Host "   3. Run setup again" -ForegroundColor Gray
    }
}
catch {
    Write-Host "❌ Frontend setup failed: $_" -ForegroundColor Red
}