# Security validation script
# Checks for common security issues in the project

param(
    [string]$ProjectRoot = "."
)

Write-Host "🔒 Security Validation Check" -ForegroundColor Green
Write-Host "============================" -ForegroundColor Cyan

$issues = @()
$warnings = @()

function Test-EnvSecurity {
    Write-Host "`nChecking environment configuration..." -ForegroundColor Yellow
    
    $envFile = "$ProjectRoot\backend\.env"
    
    if (Test-Path $envFile) {
        $content = Get-Content $envFile -Raw
        
        # Check for default secrets
        $defaultSecrets = @(
            "dev-secret-key-2024-sems-foundation",
            "dev-jwt-secret-2024-sems-change-in-production",
            "your-development-secret-key-change-in-production",
            "your-super-secure-jwt-secret-key-change-this-in-production",
            "fallback-secret-key-change-in-production",
            "fallback-jwt-secret-change-in-production"
        )
        
        foreach ($secret in $defaultSecrets) {
            if ($content -match [regex]::Escape($secret)) {
                $issues += "⚠️  Default secret detected: $secret"
                Write-Host "❌ Default secret found: $secret" -ForegroundColor Red
            }
        }
        
        # Check for debug mode in potential production
        if ($content -match "FLASK_ENV=production" -and $content -match "FLASK_DEBUG=True") {
            $issues += "🚨 Debug mode enabled in production environment"
            Write-Host "❌ Debug mode enabled in production" -ForegroundColor Red
        }
        
        # Check for empty secrets
        if ($content -match "SECRET_KEY=\s*`"`"|SECRET_KEY=\s*$") {
            $issues += "🚨 SECRET_KEY is empty"
            Write-Host "❌ SECRET_KEY is empty" -ForegroundColor Red
        }
        
        if ($content -match "JWT_SECRET_KEY=\s*`"`"|JWT_SECRET_KEY=\s*$") {
            $issues += "🚨 JWT_SECRET_KEY is empty"
            Write-Host "❌ JWT_SECRET_KEY is empty" -ForegroundColor Red
        }
        
        if ($issues.Count -eq 0) {
            Write-Host "✅ Environment configuration looks good" -ForegroundColor Green
        }
    } else {
        $warnings += "No .env file found (run backend setup to create one)"
        Write-Host "ℹ️  No .env file found (run backend setup to create one)" -ForegroundColor Yellow
    }
}

function Test-GitIgnore {
    Write-Host "`nChecking .gitignore rules..." -ForegroundColor Yellow
    
    $gitIgnoreFile = "$ProjectRoot\.gitignore"
    
    if (Test-Path $gitIgnoreFile) {
        $content = Get-Content $gitIgnoreFile -Raw
        
        $requiredIgnores = @(
            "\.env",
            "backend/\.env",
            "database/\*\.db",
            "uploads/",
            "logs/",
            "frontend/bin/",
            "frontend/obj/"
        )
        
        $missingIgnores = @()
        foreach ($ignore in $requiredIgnores) {
            if ($content -notmatch $ignore) {
                $missingIgnores += $ignore
            }
        }
        
        if ($missingIgnores.Count -gt 0) {
            foreach ($missing in $missingIgnores) {
                $warnings += "Missing .gitignore rule: $missing"
                Write-Host "⚠️  Missing .gitignore: $missing" -ForegroundColor Yellow
            }
        } else {
            Write-Host "✅ .gitignore rules look good" -ForegroundColor Green
        }
    } else {
        $issues += ".gitignore file missing"
        Write-Host "❌ .gitignore file not found" -ForegroundColor Red
    }
}

function Test-CommittedSecrets {
    Write-Host "`nChecking for committed secrets..." -ForegroundColor Yellow
    
    # Check if .env is committed
    $result = git check-ignore "backend/.env" 2>$null
    if (-not $result) {
        $issues += ".env file might be committed to git"
        Write-Host "❌ .env file is not gitignored" -ForegroundColor Red
    } else {
        Write-Host "✅ .env file is properly gitignored" -ForegroundColor Green
    }
    
    # Check if any .env files are tracked
    $trackedEnvFiles = git ls-files | Where-Object { $_ -like "*.env" }
    if ($trackedEnvFiles) {
        foreach ($file in $trackedEnvFiles) {
            $issues += "Environment file tracked in git: $file"
            Write-Host "❌ Environment file tracked: $file" -ForegroundColor Red
        }
    }
}

# Run checks
Test-EnvSecurity
Test-GitIgnore
Test-CommittedSecrets

# Summary
Write-Host "`n📋 SECURITY SUMMARY" -ForegroundColor Cyan
Write-Host "==================" -ForegroundColor Cyan

if ($issues.Count -eq 0 -and $warnings.Count -eq 0) {
    Write-Host "🎉 All security checks passed!" -ForegroundColor Green
} else {
    if ($issues.Count -gt 0) {
        Write-Host "`n❌ CRITICAL ISSUES ($($issues.Count)):" -ForegroundColor Red
        foreach ($issue in $issues) {
            Write-Host "  • $issue" -ForegroundColor Red
        }
    }
    
    if ($warnings.Count -gt 0) {
        Write-Host "`n⚠️  WARNINGS ($($warnings.Count)):" -ForegroundColor Yellow
        foreach ($warning in $warnings) {
            Write-Host "  • $warning" -ForegroundColor Yellow
        }
    }
    
    if ($issues.Count -gt 0) {
        Write-Host "`n🚨 Please address CRITICAL issues before proceeding to production." -ForegroundColor Red
    } else {
        Write-Host "`nℹ️  Warnings should be addressed but are not blocking." -ForegroundColor Yellow
    }
}

# Return exit code based on issues
if ($issues.Count -gt 0) {
    exit 1
} else {
    exit 0
}