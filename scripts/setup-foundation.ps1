# Foundation Phase Setup Script
# Sets up the basic environment and starts the application

param(
    [string]$ProjectRoot = ".",
    [switch]$SetupOnly,
    [switch]$StartBackend,
    [switch]$StartFrontend
)

Write-Host "🚀 Smart Enterprise Management System - Foundation Phase" -ForegroundColor Green
Write-Host "======================================================" -ForegroundColor Cyan

function Test-CommandExists {
    param($command)
    return (Get-Command $command -ErrorAction SilentlyContinue) -ne $null
}

function Setup-Backend {
    Write-Host "`n📦 Setting up Backend..." -ForegroundColor Yellow
    
    Push-Location "$ProjectRoot/backend"
    
    try {
        # Check Python
        if (-not (Test-CommandExists "python")) {
            throw "Python is not installed or not in PATH"
        }
        
        # Create virtual environment
        if (-not (Test-Path "venv")) {
            Write-Host "Creating Python virtual environment..." -ForegroundColor Gray
            python -m venv venv
        }
        
        # Activate virtual environment
        Write-Host "Activating virtual environment..." -ForegroundColor Gray
        $venvActivate = ".\venv\Scripts\Activate.ps1"
        if (Test-Path $venvActivate) {
            . $venvActivate
        } else {
            throw "Virtual environment activation failed"
        }
        
        # Install dependencies
        Write-Host "Installing Python dependencies..." -ForegroundColor Gray
        pip install --upgrade pip
        pip install -r requirements.txt
        
        # Create .env from example if it doesn't exist
        if (-not (Test-Path ".env")) {
            Write-Host "Creating .env file from .env.example..." -ForegroundColor Gray
            Copy-Item ".env.example" ".env" -ErrorAction SilentlyContinue
            if (Test-Path ".env") {
                Write-Host "✅ .env file created. Please review and update configuration." -ForegroundColor Green
            } else {
                Write-Host "⚠️  Could not create .env file. Please create it manually." -ForegroundColor Yellow
            }
        }
        
        # Initialize database
        Write-Host "Initializing database..." -ForegroundColor Gray
        if (Test-Path "..\database\development.db") {
            Remove-Item "..\database\development.db" -Force
        }
        
        # Create database directory if it doesn't exist
        if (-not (Test-Path "..\database")) {
            New-Item -ItemType Directory -Path "..\database" -Force | Out-Null
        }
        
        # Run initial setup
        python -c "
import sys
sys.path.append('.')
from app import create_app
from database.connection import db
app = create_app()
with app.app_context():
    db.create_all()
    print('✅ Database tables created successfully')
"
        
        Write-Host "✅ Backend setup completed successfully!" -ForegroundColor Green
        
        if ($StartBackend -or (-not $SetupOnly -and -not $StartFrontend)) {
            Start-Backend
        }
    }
    catch {
        Write-Host "❌ Backend setup failed: $_" -ForegroundColor Red
    }
    finally {
        Pop-Location
    }
}

function Start-Backend {
    Write-Host "`n🎯 Starting Backend Server..." -ForegroundColor Yellow
    Write-Host "Backend API will be available at: http://localhost:5001" -ForegroundColor Cyan
    Write-Host "API Documentation: http://localhost:5001/api/docs" -ForegroundColor Cyan
    Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Gray
    
    try {
        python run.py
    }
    catch {
        Write-Host "❌ Failed to start backend: $_" -ForegroundColor Red
    }
}

function Setup-Frontend {
    Write-Host "`n📦 Setting up Frontend..." -ForegroundColor Yellow
    
    Push-Location "$ProjectRoot/frontend"
    
    try {
        # Check .NET SDK
        if (-not (Test-CommandExists "dotnet")) {
            throw ".NET SDK is not installed or not in PATH"
        }
        
        # Restore packages
        Write-Host "Restoring NuGet packages..." -ForegroundColor Gray
        dotnet restore
        
        # Build project
        Write-Host "Building project..." -ForegroundColor Gray
        dotnet build
        
        Write-Host "✅ Frontend setup completed successfully!" -ForegroundColor Green
        
        if ($StartFrontend -or (-not $SetupOnly -and -not $StartBackend)) {
            Start-Frontend
        }
    }
    catch {
        Write-Host "❌ Frontend setup failed: $_" -ForegroundColor Red
    }
    finally {
        Pop-Location
    }
}

function Start-Frontend {
    Write-Host "`n🎯 Starting Frontend Application..." -ForegroundColor Yellow
    Write-Host "Frontend will be available at: http://localhost:5000" -ForegroundColor Cyan
    Write-Host "Press Ctrl+C to stop the application" -ForegroundColor Gray
    
    try {
        dotnet run
    }
    catch {
        Write-Host "❌ Failed to start frontend: $_" -ForegroundColor Red
    }
}

function Show-SetupSummary {
    Write-Host "`n📋 SETUP SUMMARY" -ForegroundColor Cyan
    Write-Host "=================" -ForegroundColor Cyan
    
    # Check backend
    Push-Location "$ProjectRoot/backend"
    $backendOk = (Test-Path "venv") -and (Test-Path ".env")
    Pop-Location
    
    # Check frontend
    Push-Location "$ProjectRoot/frontend"
    $frontendOk = Test-Path "bin"
    Pop-Location
    
    Write-Host "Backend Setup: $(if ($backendOk) { '✅' } else { '❌' })" -ForegroundColor $(if ($backendOk) { 'Green' } else { 'Red' })
    Write-Host "Frontend Setup: $(if ($frontendOk) { '✅' } else { '❌' })" -ForegroundColor $(if ($frontendOk) { 'Green' } else { 'Red' })
    
    if ($backendOk -and $frontendOk) {
        Write-Host "`n🎉 Foundation phase setup completed!" -ForegroundColor Green
        Write-Host "You can now start the applications using:" -ForegroundColor White
        Write-Host "  .\scripts\setup-foundation.ps1 -StartBackend" -ForegroundColor Gray
        Write-Host "  .\scripts\setup-foundation.ps1 -StartFrontend" -ForegroundColor Gray
        Write-Host "  .\scripts\setup-foundation.ps1 (starts both)" -ForegroundColor Gray
    } else {
        Write-Host "`n⚠️  Some setup steps failed. Please check the errors above." -ForegroundColor Yellow
    }
}

# Main execution
try {
    # Create necessary directories
    $directories = @("database", "uploads", "logs", "temp", "backups")
    foreach ($dir in $directories) {
        if (-not (Test-Path "$ProjectRoot/$dir")) {
            New-Item -ItemType Directory -Path "$ProjectRoot/$dir" -Force | Out-Null
            Write-Host "Created directory: $dir" -ForegroundColor Gray
        }
    }
    
    # Setup based on parameters
    if ($StartBackend) {
        Setup-Backend
    } elseif ($StartFrontend) {
        Setup-Frontend
    } elseif ($SetupOnly) {
        Setup-Backend
        Setup-Frontend
    } else {
        # Start both in separate processes (simplified - starts backend only for now)
        Setup-Backend
    }
    
    Show-SetupSummary
}
catch {
    Write-Host "❌ Setup failed: $_" -ForegroundColor Red
}