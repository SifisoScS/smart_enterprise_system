# Backend Setup Script
# Sets up Python Flask backend with virtual environment and dependencies

param(
    [string]$ProjectRoot = ".",
    [switch]$StartServer
)

Write-Host "🐍 Backend Setup - Python Flask" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Cyan

function Test-Python {
    Write-Host "Checking Python installation..." -ForegroundColor Gray
    if (Get-Command python -ErrorAction SilentlyContinue) {
        $version = (python --version) 2>&1
        Write-Host "✅ $version" -ForegroundColor Green
        return $true
    } else {
        Write-Host "❌ Python not found. Please install Python 3.9+ from https://python.org" -ForegroundColor Red
        return $false
    }
}

function Setup-VirtualEnvironment {
    Write-Host "`nSetting up Python virtual environment..." -ForegroundColor Yellow
    
    Push-Location "$ProjectRoot/backend"
    
    try {
        # Remove existing venv if it exists
        if (Test-Path "venv") {
            Write-Host "Removing existing virtual environment..." -ForegroundColor Gray
            Remove-Item -Recurse -Force venv
        }
        
        # Create new virtual environment
        Write-Host "Creating new virtual environment..." -ForegroundColor Gray
        python -m venv venv
        
        # Activate virtual environment
        Write-Host "Activating virtual environment..." -ForegroundColor Gray
        $activateScript = ".\venv\Scripts\Activate.ps1"
        if (Test-Path $activateScript) {
            . $activateScript
            Write-Host "✅ Virtual environment activated" -ForegroundColor Green
        } else {
            throw "Failed to activate virtual environment"
        }
        
        # Upgrade pip
        Write-Host "Upgrading pip..." -ForegroundColor Gray
        python -m pip install --upgrade pip
        
        Pop-Location
        return $true
    }
    catch {
        Write-Host "❌ Virtual environment setup failed: $_" -ForegroundColor Red
        Pop-Location
        return $false
    }
}

function Install-Dependencies {
    Write-Host "`nInstalling Python dependencies..." -ForegroundColor Yellow
    
    Push-Location "$ProjectRoot/backend"
    
    try {
        # Activate virtual environment
        $activateScript = ".\venv\Scripts\Activate.ps1"
        if (Test-Path $activateScript) {
            . $activateScript
        }
        
        # Install requirements
        if (Test-Path "requirements.txt") {
            Write-Host "Installing from requirements.txt..." -ForegroundColor Gray
            pip install -r requirements.txt
        } else {
            Write-Host "⚠️ requirements.txt not found. Installing basic Flask dependencies..." -ForegroundColor Yellow
            pip install flask flask-sqlalchemy flask-cors python-dotenv pyjwt cryptography
        }
        
        # Install development dependencies
        if (Test-Path "requirements-dev.txt") {
            Write-Host "Installing development dependencies..." -ForegroundColor Gray
            pip install -r requirements-dev.txt
        }
        
        Write-Host "✅ Dependencies installed successfully" -ForegroundColor Green
        Pop-Location
        return $true
    }
    catch {
        Write-Host "❌ Dependency installation failed: $_" -ForegroundColor Red
        Pop-Location
        return $false
    }
}

function Test-ModelImports {
    Write-Host "`nTesting model imports..." -ForegroundColor Yellow
    
    Push-Location "$ProjectRoot/backend"
    
    try {
        # Activate virtual environment
        $activateScript = ".\venv\Scripts\Activate.ps1"
        if (Test-Path $activateScript) {
            . $activateScript
        }
        
        # Test basic imports
        Write-Host "Testing database model imports..." -ForegroundColor Gray
        python -c "
import sys
sys.path.append('.')
try:
    from app.core.models.base_model import BaseModel
    from app.core.models.tenant import Tenant
    from app.core.models.user import User
    from app.core.models.role import Role
    print('✅ All core models imported successfully')
    print('   - BaseModel ✓')
    print('   - Tenant ✓') 
    print('   - User ✓')
    print('   - Role ✓')
except ImportError as e:
    print(f'❌ Model import failed: {e}')
    print('This usually means the model files are missing or have syntax errors')
    sys.exit(1)
"
        
        Pop-Location
        return $true
    }
    catch {
        Write-Host "❌ Model import test failed: $_" -ForegroundColor Red
        Pop-Location
        return $false
    }
}

function Setup-Environment {
    Write-Host "`nSetting up environment configuration..." -ForegroundColor Yellow
    
    Push-Location "$ProjectRoot/backend"
    
    try {
        # Create .env from example if it doesn't exist
        if (-not (Test-Path ".env") -and (Test-Path ".env.example")) {
            Write-Host "Creating .env file from .env.example..." -ForegroundColor Gray
            Copy-Item ".env.example" ".env"
            Write-Host "✅ .env file created. Please review the configuration." -ForegroundColor Green
        } elseif (Test-Path ".env") {
            Write-Host "ℹ️ .env file already exists" -ForegroundColor Gray
        } else {
            Write-Host "⚠️ No .env.example found. Please create .env manually." -ForegroundColor Yellow
        }
        
        Pop-Location
        return $true
    }
    catch {
        Write-Host "❌ Environment setup failed: $_" -ForegroundColor Red
        Pop-Location
        return $false
    }
}

function Initialize-Database {
    Write-Host "`nInitializing database..." -ForegroundColor Yellow
    
    Push-Location "$ProjectRoot/backend"
    
    try {
        # Activate virtual environment
        $activateScript = ".\venv\Scripts\Activate.ps1"
        if (Test-Path $activateScript) {
            . $activateScript
        }
        
        # Create database directory if it doesn't exist
        if (-not (Test-Path "..\database")) {
            New-Item -ItemType Directory -Path "..\database" -Force | Out-Null
        }
        
        # Initialize database using Python
        Write-Host "Creating database tables..." -ForegroundColor Gray
        python -c "
import sys
import os
sys.path.append('.')
try:
    from app import create_app
    from database.connection import db

    app = create_app()
    with app.app_context():
        db.create_all()
        print('✅ Database tables created successfully')
        
        # Create initial data
        from database.connection import create_initial_data
        create_initial_data()
except Exception as e:
    print(f'❌ Database initialization failed: {e}')
    import traceback
    traceback.print_exc()
    sys.exit(1)
"
        
        Write-Host "✅ Database initialized successfully" -ForegroundColor Green
        Pop-Location
        return $true
    }
    catch {
        Write-Host "❌ Database initialization failed: $_" -ForegroundColor Red
        Pop-Location
        return $false
    }
}

function Start-BackendServer {
    Write-Host "`n🎯 Starting Backend Server..." -ForegroundColor Green
    Write-Host "Backend API: http://localhost:5001" -ForegroundColor Cyan
    Write-Host "Health Check: http://localhost:5001/api/health" -ForegroundColor Cyan
    Write-Host "API Documentation: http://localhost:5001/api/docs" -ForegroundColor Cyan
    Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Gray
    
    Push-Location "$ProjectRoot/backend"
    
    try {
        # Activate virtual environment
        $activateScript = ".\venv\Scripts\Activate.ps1"
        if (Test-Path $activateScript) {
            . $activateScript
        }
        
        # Start the Flask application
        python run.py
    }
    catch {
        Write-Host "❌ Failed to start backend server: $_" -ForegroundColor Red
    }
    finally {
        Pop-Location
    }
}

# Main execution
try {
    Write-Host "Setting up backend in: $(Resolve-Path $ProjectRoot)/backend" -ForegroundColor Gray
    
    # Run setup steps
    $steps = @(
        @{ Name = "Python Check"; Function = { Test-Python } },
        @{ Name = "Virtual Environment"; Function = { Setup-VirtualEnvironment } },
        @{ Name = "Dependencies"; Function = { Install-Dependencies } },
        @{ Name = "Model Import Test"; Function = { Test-ModelImports } },
        @{ Name = "Environment Setup"; Function = { Setup-Environment } },
        @{ Name = "Database"; Function = { Initialize-Database } }
    )
    
    $allSuccess = $true
    foreach ($step in $steps) {
        Write-Host "`n▶️ Step: $($step.Name)" -ForegroundColor Yellow
        $success = & $step.Function
        if (-not $success) {
            $allSuccess = $false
            Write-Host "❌ Backend setup failed at step: $($step.Name)" -ForegroundColor Red
            break
        }
    }
    
    if ($allSuccess) {
        Write-Host "`n🎉 Backend setup completed successfully!" -ForegroundColor Green
        
        if ($StartServer) {
            Start-BackendServer
        } else {
            Write-Host "`nYou can start the backend server with:" -ForegroundColor White
            Write-Host "  .\scripts\setup-backend.ps1 -StartServer" -ForegroundColor Gray
            Write-Host "  .\scripts\setup-foundation.ps1 -StartBackend" -ForegroundColor Gray
        }
    } else {
        Write-Host "`n💥 Backend setup failed. Please check the errors above." -ForegroundColor Red
    }
}
catch {
    Write-Host "❌ Backend setup failed: $_" -ForegroundColor Red
}