# Smart Enterprise Management System (SEMS) Project Generator
# This script creates the complete folder structure and placeholder files

param(
    [string]$ProjectRoot = ".\smart_enterprise_system"
)

function Create-FolderStructure {
    Write-Host "Creating Smart Enterprise Management System project structure..." -ForegroundColor Green
    
    # Root directory
    $root = $ProjectRoot
    New-Item -ItemType Directory -Path $root -Force | Out-Null
    
    # Main directories
    $mainDirs = @(
        "backend",
        "frontend",
        "database",
        "docs",
        "deployment",
        "config",
        "monitoring",
        "security",
        "backups",
        "temp",
        "uploads"
    )
    
    foreach ($dir in $mainDirs) {
        New-Item -ItemType Directory -Path "$root\$dir" -Force | Out-Null
    }
    
    # Backend structure
    Create-BackendStructure -root $root
    
    # Frontend structure
    Create-FrontendStructure -root $root
    
    # Database structure
    Create-DatabaseStructure -root $root
    
    # Documentation structure
    Create-DocsStructure -root $root
    
    # Deployment structure
    Create-DeploymentStructure -root $root
    
    # Config files
    Create-ConfigFiles -root $root
    
    # Monitoring files
    Create-MonitoringFiles -root $root
    
    # Security files
    Create-SecurityFiles -root $root
    
    # Root files
    Create-RootFiles -root $root
    
    Write-Host "Project structure created successfully at: $root" -ForegroundColor Green
    Write-Host "Total files created: $fileCount" -ForegroundColor Yellow
}

function Create-BackendStructure {
    param($root)
    
    $backendDirs = @(
        "backend\app",
        "backend\app\core",
        "backend\app\core\models",
        "backend\app\core\repositories",
        "backend\app\core\services",
        "backend\app\core\middleware",
        "backend\app\core\patterns",
        "backend\app\core\utils",
        "backend\app\core\exceptions",
        "backend\app\modules",
        "backend\app\modules\maintenance",
        "backend\app\modules\maintenance\models",
        "backend\app\modules\maintenance\repositories",
        "backend\app\modules\maintenance\services",
        "backend\app\modules\maintenance\controllers",
        "backend\app\modules\maintenance\schemas",
        "backend\app\modules\maintenance\patterns",
        "backend\app\modules\education",
        "backend\app\modules\education\models",
        "backend\app\modules\education\repositories",
        "backend\app\modules\education\services",
        "backend\app\modules\education\controllers",
        "backend\app\modules\education\schemas",
        "backend\app\modules\education\patterns",
        "backend\app\modules\hr",
        "backend\app\modules\hr\models",
        "backend\app\modules\hr\repositories",
        "backend\app\modules\hr\services",
        "backend\app\modules\hr\controllers",
        "backend\app\modules\hr\schemas",
        "backend\app\modules\hr\patterns",
        "backend\app\modules\finance",
        "backend\app\modules\finance\models",
        "backend\app\modules\finance\repositories",
        "backend\app\modules\finance\services",
        "backend\app\modules\finance\controllers",
        "backend\app\modules\finance\schemas",
        "backend\app\modules\finance\patterns",
        "backend\app\modules\compliance",
        "backend\app\modules\compliance\models",
        "backend\app\modules\compliance\repositories",
        "backend\app\modules\compliance\services",
        "backend\app\modules\compliance\controllers",
        "backend\app\modules\compliance\schemas",
        "backend\app\modules\compliance\patterns",
        "backend\app\modules\healthcare",
        "backend\app\modules\healthcare\models",
        "backend\app\modules\healthcare\repositories",
        "backend\app\modules\healthcare\services",
        "backend\app\modules\healthcare\controllers",
        "backend\app\modules\healthcare\schemas",
        "backend\app\modules\healthcare\patterns",
        "backend\app\modules\inventory",
        "backend\app\modules\inventory\models",
        "backend\app\modules\inventory\repositories",
        "backend\app\modules\inventory\services",
        "backend\app\modules\inventory\controllers",
        "backend\app\modules\inventory\schemas",
        "backend\app\modules\inventory\patterns",
        "backend\app\modules\security",
        "backend\app\modules\security\models",
        "backend\app\modules\security\repositories",
        "backend\app\modules\security\services",
        "backend\app\modules\security\controllers",
        "backend\app\modules\security\schemas",
        "backend\app\modules\security\patterns",
        "backend\app\modules\transport",
        "backend\app\modules\transport\models",
        "backend\app\modules\transport\repositories",
        "backend\app\modules\transport\services",
        "backend\app\modules\transport\controllers",
        "backend\app\modules\transport\schemas",
        "backend\app\modules\transport\patterns",
        "backend\app\modules\projects",
        "backend\app\modules\projects\models",
        "backend\app\modules\projects\repositories",
        "backend\app\modules\projects\services",
        "backend\app\modules\projects\controllers",
        "backend\app\modules\projects\schemas",
        "backend\app\modules\projects\patterns",
        "backend\app\routes",
        "backend\database",
        "backend\database\migrations",
        "backend\database\migrations\versions",
        "backend\database\seeds",
        "backend\tests",
        "backend\tests\unit",
        "backend\tests\unit\core",
        "backend\tests\unit\maintenance",
        "backend\tests\unit\education",
        "backend\tests\integration",
        "backend\tests\e2e",
        "backend\logs",
        "backend\scripts"
    )
    
    foreach ($dir in $backendDirs) {
        New-Item -ItemType Directory -Path "$root\$dir" -Force | Out-Null
    }
    
    # Create backend files
    $backendFiles = @(
        "backend\app\__init__.py",
        "backend\app\config.py",
        "backend\app\core\__init__.py",
        "backend\app\core\models\__init__.py",
        "backend\app\core\models\base_model.py",
        "backend\app\core\models\tenant.py",
        "backend\app\core\models\user.py",
        "backend\app\core\models\role.py",
        "backend\app\core\models\permission.py",
        "backend\app\core\models\audit_log.py",
        "backend\app\core\models\notification.py",
        "backend\app\core\models\file_upload.py",
        "backend\app\core\repositories\__init__.py",
        "backend\app\core\repositories\base_repository.py",
        "backend\app\core\repositories\tenant_repository.py",
        "backend\app\core\repositories\user_repository.py",
        "backend\app\core\repositories\role_repository.py",
        "backend\app\core\repositories\audit_repository.py",
        "backend\app\core\services\__init__.py",
        "backend\app\core\services\auth_service.py",
        "backend\app\core\services\tenant_service.py",
        "backend\app\core\services\user_service.py",
        "backend\app\core\services\notification_service.py",
        "backend\app\core\services\audit_service.py",
        "backend\app\core\services\file_service.py",
        "backend\app\core\services\email_service.py",
        "backend\app\core\middleware\__init__.py",
        "backend\app\core\middleware\tenant_middleware.py",
        "backend\app\core\middleware\auth_middleware.py",
        "backend\app\core\middleware\logging_middleware.py",
        "backend\app\core\middleware\cors_middleware.py",
        "backend\app\core\patterns\__init__.py",
        "backend\app\core\patterns\factory.py",
        "backend\app\core\patterns\observer.py",
        "backend\app\core\patterns\strategy.py",
        "backend\app\core\patterns\singleton.py",
        "backend\app\core\patterns\decorator.py",
        "backend\app\core\patterns\chain_of_responsibility.py",
        "backend\app\core\utils\__init__.py",
        "backend\app\core\utils\validators.py",
        "backend\app\core\utils\formatters.py",
        "backend\app\core\utils\encryption.py",
        "backend\app\core\utils\date_utils.py",
        "backend\app\core\utils\constants.py",
        "backend\app\core\exceptions\__init__.py",
        "backend\app\core\exceptions\tenant_exceptions.py",
        "backend\app\core\exceptions\auth_exceptions.py",
        "backend\app\core\exceptions\validation_exceptions.py"
    )
    
    # Add module files for all 10 modules
    $modules = @("maintenance", "education", "hr", "finance", "compliance", "healthcare", "inventory", "security", "transport", "projects")
    
    foreach ($module in $modules) {
        $backendFiles += @(
            "backend\app\modules\$module\__init__.py",
            "backend\app\modules\$module\models\__init__.py",
            "backend\app\modules\$module\repositories\__init__.py",
            "backend\app\modules\$module\services\__init__.py",
            "backend\app\modules\$module\controllers\__init__.py",
            "backend\app\modules\$module\schemas\__init__.py",
            "backend\app\modules\$module\patterns\__init__.py"
        )
        
        # Add specific files based on module
        switch ($module) {
            "maintenance" {
                $backendFiles += @(
                    "backend\app\modules\$module\models\asset.py",
                    "backend\app\modules\$module\models\request.py",
                    "backend\app\modules\$module\models\work_order.py",
                    "backend\app\modules\$module\models\category.py",
                    "backend\app\modules\$module\repositories\asset_repository.py",
                    "backend\app\modules\$module\repositories\request_repository.py",
                    "backend\app\modules\$module\repositories\work_order_repository.py",
                    "backend\app\modules\$module\services\maintenance_service.py",
                    "backend\app\modules\$module\services\asset_service.py",
                    "backend\app\modules\$module\services\assignment_service.py",
                    "backend\app\modules\$module\controllers\request_controller.py",
                    "backend\app\modules\$module\controllers\asset_controller.py",
                    "backend\app\modules\$module\controllers\work_order_controller.py",
                    "backend\app\modules\$module\schemas\request_schema.py",
                    "backend\app\modules\$module\schemas\asset_schema.py",
                    "backend\app\modules\$module\patterns\request_factory.py",
                    "backend\app\modules\$module\patterns\status_observer.py"
                )
            }
            "education" {
                $backendFiles += @(
                    "backend\app\modules\$module\models\student.py",
                    "backend\app\modules\$module\models\staff.py",
                    "backend\app\modules\$module\models\class.py",
                    "backend\app\modules\$module\models\subject.py",
                    "backend\app\modules\$module\models\enrollment.py",
                    "backend\app\modules\$module\models\attendance.py",
                    "backend\app\modules\$module\models\grade.py",
                    "backend\app\modules\$module\models\incident.py",
                    "backend\app\modules\$module\models\parent.py",
                    "backend\app\modules\$module\models\timetable.py",
                    "backend\app\modules\$module\repositories\student_repository.py",
                    "backend\app\modules\$module\repositories\staff_repository.py",
                    "backend\app\modules\$module\repositories\class_repository.py",
                    "backend\app\modules\$module\repositories\enrollment_repository.py",
                    "backend\app\modules\$module\repositories\attendance_repository.py",
                    "backend\app\modules\$module\repositories\grade_repository.py",
                    "backend\app\modules\$module\services\enrollment_service.py",
                    "backend\app\modules\$module\services\attendance_service.py",
                    "backend\app\modules\$module\services\grading_service.py",
                    "backend\app\modules\$module\services\communication_service.py",
                    "backend\app\modules\$module\services\timetable_service.py",
                    "backend\app\modules\$module\controllers\student_controller.py",
                    "backend\app\modules\$module\controllers\staff_controller.py",
                    "backend\app\modules\$module\controllers\class_controller.py",
                    "backend\app\modules\$module\controllers\attendance_controller.py",
                    "backend\app\modules\$module\controllers\grade_controller.py",
                    "backend\app\modules\$module\schemas\student_schema.py",
                    "backend\app\modules\$module\schemas\enrollment_schema.py",
                    "backend\app\modules\$module\schemas\attendance_schema.py",
                    "backend\app\modules\$module\patterns\enrollment_factory.py",
                    "backend\app\modules\$module\patterns\grading_strategy.py",
                    "backend\app\modules\$module\patterns\attendance_observer.py"
                )
            }
            # Add other modules similarly...
            default {
                # Generic files for other modules
                $backendFiles += @(
                    "backend\app\modules\$module\models\$module.py",
                    "backend\app\modules\$module\repositories\${module}_repository.py",
                    "backend\app\modules\$module\services\${module}_service.py",
                    "backend\app\modules\$module\controllers\${module}_controller.py",
                    "backend\app\modules\$module\schemas\${module}_schema.py",
                    "backend\app\modules\$module\patterns\${module}_factory.py"
                )
            }
        }
    }
    
    # Add routes and other backend files
    $backendFiles += @(
        "backend\app\routes\__init__.py",
        "backend\app\routes\api.py",
        "backend\app\routes\health.py",
        "backend\database\__init__.py",
        "backend\database\connection.py",
        "backend\database\migrations\env.py",
        "backend\database\migrations\script.py.mako",
        "backend\database\migrations\versions\001_initial_schema.py",
        "backend\database\migrations\versions\002_add_maintenance_module.py",
        "backend\database\migrations\versions\003_add_education_module.py",
        "backend\database\seeds\seed_tenants.py",
        "backend\database\seeds\seed_users.py",
        "backend\database\seeds\seed_demo_data.py",
        "backend\tests\__init__.py",
        "backend\tests\conftest.py",
        "backend\tests\unit\__init__.py",
        "backend\tests\unit\core\test_auth_service.py",
        "backend\tests\unit\core\test_tenant_service.py",
        "backend\tests\unit\core\test_notification_service.py",
        "backend\tests\unit\core\test_repositories.py",
        "backend\tests\unit\maintenance\test_request_service.py",
        "backend\tests\unit\maintenance\test_asset_service.py",
        "backend\tests\unit\maintenance\test_request_factory.py",
        "backend\tests\unit\education\test_enrollment_service.py",
        "backend\tests\unit\education\test_attendance_service.py",
        "backend\tests\unit\education\test_grading_service.py",
        "backend\tests\integration\__init__.py",
        "backend\tests\integration\test_maintenance_api.py",
        "backend\tests\integration\test_education_api.py",
        "backend\tests\integration\test_cross_module_integration.py",
        "backend\tests\integration\test_multi_tenant_isolation.py",
        "backend\tests\e2e\__init__.py",
        "backend\tests\e2e\test_complete_workflows.py",
        "backend\logs\app.log",
        "backend\logs\error.log",
        "backend\logs\audit.log",
        "backend\scripts\create_tenant.py",
        "backend\scripts\backup_database.py",
        "backend\scripts\restore_database.py",
        "backend\scripts\generate_reports.py",
        "backend\requirements.txt",
        "backend\requirements-dev.txt",
        "backend\.env.example",
        "backend\.env",
        "backend\.gitignore",
        "backend\pytest.ini",
        "backend\run.py"
    )
    
    Create-Files -root $root -files $backendFiles
}

function Create-FrontendStructure {
    param($root)
    
    $frontendDirs = @(
        "frontend\SmartEnterprise.Blazor",
        "frontend\SmartEnterprise.Blazor\wwwroot",
        "frontend\SmartEnterprise.Blazor\wwwroot\css",
        "frontend\SmartEnterprise.Blazor\wwwroot\js",
        "frontend\SmartEnterprise.Blazor\wwwroot\images",
        "frontend\SmartEnterprise.Blazor\wwwroot\images\icons",
        "frontend\SmartEnterprise.Blazor\Pages",
        "frontend\SmartEnterprise.Blazor\Pages\Maintenance",
        "frontend\SmartEnterprise.Blazor\Pages\Education",
        "frontend\SmartEnterprise.Blazor\Pages\HR",
        "frontend\SmartEnterprise.Blazor\Pages\Finance",
        "frontend\SmartEnterprise.Blazor\Pages\Compliance",
        "frontend\SmartEnterprise.Blazor\Pages\Healthcare",
        "frontend\SmartEnterprise.Blazor\Pages\Inventory",
        "frontend\SmartEnterprise.Blazor\Pages\Security",
        "frontend\SmartEnterprise.Blazor\Pages\Transport",
        "frontend\SmartEnterprise.Blazor\Pages\Projects",
        "frontend\SmartEnterprise.Blazor\Components",
        "frontend\SmartEnterprise.Blazor\Components\Shared",
        "frontend\SmartEnterprise.Blazor\Components\Charts",
        "frontend\SmartEnterprise.Blazor\Components\Forms",
        "frontend\SmartEnterprise.Blazor\Components\Maintenance",
        "frontend\SmartEnterprise.Blazor\Components\Education",
        "frontend\SmartEnterprise.Blazor\Services",
        "frontend\SmartEnterprise.Blazor\Services\Core",
        "frontend\SmartEnterprise.Blazor\Models",
        "frontend\SmartEnterprise.Blazor\Models\Core",
        "frontend\SmartEnterprise.Blazor\Models\Maintenance",
        "frontend\SmartEnterprise.Blazor\Models\Education",
        "frontend\SmartEnterprise.Blazor\State",
        "frontend\SmartEnterprise.Blazor\Utilities"
    )
    
    foreach ($dir in $frontendDirs) {
        New-Item -ItemType Directory -Path "$root\$dir" -Force | Out-Null
    }
    
    # Create frontend files
    $frontendFiles = @(
        "frontend\SmartEnterprise.Blazor\SmartEnterprise.Blazor.csproj",
        "frontend\SmartEnterprise.Blazor\Program.cs",
        "frontend\SmartEnterprise.Blazor\App.razor",
        "frontend\SmartEnterprise.Blazor\_Imports.razor",
        "frontend\SmartEnterprise.Blazor\wwwroot\index.html",
        "frontend\SmartEnterprise.Blazor\wwwroot\favicon.ico",
        "frontend\SmartEnterprise.Blazor\wwwroot\css\app.css",
        "frontend\SmartEnterprise.Blazor\wwwroot\css\bootstrap.min.css",
        "frontend\SmartEnterprise.Blazor\wwwroot\css\custom.css",
        "frontend\SmartEnterprise.Blazor\wwwroot\js\app.js",
        "frontend\SmartEnterprise.Blazor\wwwroot\js\interop.js",
        "frontend\SmartEnterprise.Blazor\wwwroot\images\logo.png",
        "frontend\SmartEnterprise.Blazor\Pages\Index.razor",
        "frontend\SmartEnterprise.Blazor\Pages\Login.razor",
        "frontend\SmartEnterprise.Blazor\Pages\Register.razor",
        "frontend\SmartEnterprise.Blazor\Pages\TenantSelector.razor",
        "frontend\SmartEnterprise.Blazor\Pages\Dashboard.razor",
        "frontend\SmartEnterprise.Blazor\Pages\Profile.razor",
        "frontend\SmartEnterprise.Blazor\Pages\Settings.razor"
    )
    
    # Add module pages
    $modules = @{
        "Maintenance" = @("RequestList", "RequestCreate", "RequestDetail", "AssetList", "AssetDetail", "MaintenanceDashboard")
        "Education" = @("StudentList", "StudentDetail", "StudentEnrollment", "AttendanceTracker", "GradeEntry", "ClassList", "Timetable", "ParentPortal", "EducationDashboard")
        "HR" = @("EmployeeList", "EmployeeDetail", "LeaveRequest", "LeaveApproval", "PerformanceReview", "Payroll", "HRDashboard")
        "Finance" = @("InvoiceList", "InvoiceCreate", "PaymentList", "ExpenseTracker", "BudgetPlanning", "FinancialReports", "FinanceDashboard")
        "Compliance" = @("AuditList", "AuditDetail", "DocumentLibrary", "ChecklistManager", "ComplianceReports", "ComplianceDashboard")
        "Healthcare" = @("PatientList", "PatientRecord", "AppointmentScheduler", "PrescriptionManager", "VaccinationTracker", "HealthcareDashboard")
        "Inventory" = @("ItemList", "ItemDetail", "StockLevels", "PurchaseOrders", "SupplierManagement", "StockMovements", "InventoryDashboard")
        "Security" = @("VisitorLog", "VisitorCheckIn", "AccessLogs", "IncidentReports", "PatrolSchedule", "SecurityDashboard")
        "Transport" = @("VehicleList", "VehicleDetail", "DriverManagement", "RouteManager", "TripTracker", "MaintenanceSchedule", "TransportDashboard")
        "Projects" = @("ProjectList", "ProjectDetail", "TaskBoard", "GanttChart", "ResourceAllocation", "Timesheets", "ProjectDashboard")
    }
    
    foreach ($module in $modules.Keys) {
        foreach ($page in $modules[$module]) {
            $frontendFiles += "frontend\SmartEnterprise.Blazor\Pages\$module\$page.razor"
        }
    }
    
    # Add components
    $sharedComponents = @(
        "NavMenu", "MainLayout", "LoginDisplay", "NotificationPanel", "SearchBar", 
        "Pagination", "DataTable", "Modal", "ConfirmDialog", "LoadingSpinner", 
        "ErrorBoundary", "BreadcrumbNavigation"
    )
    
    foreach ($component in $sharedComponents) {
        $frontendFiles += "frontend\SmartEnterprise.Blazor\Components\Shared\$component.razor"
    }
    
    $frontendFiles += @(
        "frontend\SmartEnterprise.Blazor\Components\Charts\BarChart.razor",
        "frontend\SmartEnterprise.Blazor\Components\Charts\LineChart.razor",
        "frontend\SmartEnterprise.Blazor\Components\Charts\PieChart.razor",
        "frontend\SmartEnterprise.Blazor\Components\Charts\GaugeChart.razor",
        "frontend\SmartEnterprise.Blazor\Components\Forms\TextInput.razor",
        "frontend\SmartEnterprise.Blazor\Components\Forms\SelectInput.razor",
        "frontend\SmartEnterprise.Blazor\Components\Forms\DatePicker.razor",
        "frontend\SmartEnterprise.Blazor\Components\Forms\FileUpload.razor",
        "frontend\SmartEnterprise.Blazor\Components\Forms\RichTextEditor.razor",
        "frontend\SmartEnterprise.Blazor\Components\Maintenance\RequestCard.razor",
        "frontend\SmartEnterprise.Blazor\Components\Maintenance\AssetCard.razor",
        "frontend\SmartEnterprise.Blazor\Components\Maintenance\StatusBadge.razor",
        "frontend\SmartEnterprise.Blazor\Components\Education\StudentCard.razor",
        "frontend\SmartEnterprise.Blazor\Components\Education\AttendanceWidget.razor",
        "frontend\SmartEnterprise.Blazor\Components\Education\GradeInput.razor"
    )
    
    # Add services
    $frontendFiles += @(
        "frontend\SmartEnterprise.Blazor\Services\Core\ApiService.cs",
        "frontend\SmartEnterprise.Blazor\Services\Core\AuthService.cs",
        "frontend\SmartEnterprise.Blazor\Services\Core\TenantService.cs",
        "frontend\SmartEnterprise.Blazor\Services\Core\NotificationService.cs",
        "frontend\SmartEnterprise.Blazor\Services\Core\LocalStorageService.cs",
        "frontend\SmartEnterprise.Blazor\Services\MaintenanceApiService.cs",
        "frontend\SmartEnterprise.Blazor\Services\EducationApiService.cs",
        "frontend\SmartEnterprise.Blazor\Services\HRApiService.cs",
        "frontend\SmartEnterprise.Blazor\Services\FinanceApiService.cs",
        "frontend\SmartEnterprise.Blazor\Services\ComplianceApiService.cs",
        "frontend\SmartEnterprise.Blazor\Services\HealthcareApiService.cs",
        "frontend\SmartEnterprise.Blazor\Services\InventoryApiService.cs",
        "frontend\SmartEnterprise.Blazor\Services\SecurityApiService.cs",
        "frontend\SmartEnterprise.Blazor\Services\TransportApiService.cs",
        "frontend\SmartEnterprise.Blazor\Services\ProjectsApiService.cs"
    )
    
    # Add models
    $frontendFiles += @(
        "frontend\SmartEnterprise.Blazor\Models\Core\User.cs",
        "frontend\SmartEnterprise.Blazor\Models\Core\Tenant.cs",
        "frontend\SmartEnterprise.Blazor\Models\Core\Role.cs",
        "frontend\SmartEnterprise.Blazor\Models\Core\Notification.cs",
        "frontend\SmartEnterprise.Blazor\Models\Maintenance\Asset.cs",
        "frontend\SmartEnterprise.Blazor\Models\Maintenance\MaintenanceRequest.cs",
        "frontend\SmartEnterprise.Blazor\Models\Maintenance\WorkOrder.cs",
        "frontend\SmartEnterprise.Blazor\Models\Education\Student.cs",
        "frontend\SmartEnterprise.Blazor\Models\Education\Staff.cs",
        "frontend\SmartEnterprise.Blazor\Models\Education\Class.cs",
        "frontend\SmartEnterprise.Blazor\Models\Education\Attendance.cs",
        "frontend\SmartEnterprise.Blazor\Models\Education\Grade.cs"
    )
    
    # Add state and utilities
    $frontendFiles += @(
        "frontend\SmartEnterprise.Blazor\State\AppState.cs",
        "frontend\SmartEnterprise.Blazor\State\UserState.cs",
        "frontend\SmartEnterprise.Blazor\State\TenantState.cs",
        "frontend\SmartEnterprise.Blazor\Utilities\Validators.cs",
        "frontend\SmartEnterprise.Blazor\Utilities\Formatters.cs",
        "frontend\SmartEnterprise.Blazor\Utilities\Constants.cs",
        "frontend\SmartEnterprise.Blazor\appsettings.json"
    )
    
    $frontendFiles += @(
        "frontend\.gitignore",
        "frontend\README.md"
    )
    
    Create-Files -root $root -files $frontendFiles
}

function Create-DatabaseStructure {
    param($root)
    
    $databaseFiles = @(
        "database\development.db",
        "database\test.db",
        "database\schema.sql"
    )
    
    Create-Files -root $root -files $databaseFiles
}

function Create-DocsStructure {
    param($root)
    
    $docsDirs = @(
        "docs\api",
        "docs\architecture",
        "docs\user_guides",
        "docs\developer_guides",
        "docs\diagrams",
        "docs\diagrams\class_diagrams",
        "docs\diagrams\sequence_diagrams"
    )
    
    foreach ($dir in $docsDirs) {
        New-Item -ItemType Directory -Path "$root\$dir" -Force | Out-Null
    }
    
    $docsFiles = @(
        "docs\api\README.md",
        "docs\api\authentication.md",
        "docs\api\maintenance_endpoints.md",
        "docs\api\education_endpoints.md",
        "docs\architecture\overview.md",
        "docs\architecture\multi_tenancy.md",
        "docs\architecture\design_patterns.md",
        "docs\architecture\database_schema.md",
        "docs\architecture\security.md",
        "docs\user_guides\getting_started.md",
        "docs\user_guides\maintenance_module.md",
        "docs\user_guides\education_module.md",
        "docs\developer_guides\setup.md",
        "docs\developer_guides\creating_new_module.md",
        "docs\developer_guides\testing.md",
        "docs\developer_guides\deployment.md",
        "docs\diagrams\architecture.png",
        "docs\diagrams\erd.png"
    )
    
    Create-Files -root $root -files $docsFiles
}

function Create-DeploymentStructure {
    param($root)
    
    $deploymentDirs = @(
        "deployment\docker",
        "deployment\kubernetes",
        "deployment\azure",
        "deployment\nginx",
        "deployment\scripts"
    )
    
    foreach ($dir in $deploymentDirs) {
        New-Item -ItemType Directory -Path "$root\$dir" -Force | Out-Null
    }
    
    $deploymentFiles = @(
        "deployment\docker\Dockerfile.backend",
        "deployment\docker\Dockerfile.frontend",
        "deployment\docker\docker-compose.yml",
        "deployment\kubernetes\backend-deployment.yaml",
        "deployment\kubernetes\frontend-deployment.yaml",
        "deployment\kubernetes\database-statefulset.yaml",
        "deployment\kubernetes\ingress.yaml",
        "deployment\azure\backend-appservice.json",
        "deployment\azure\frontend-appservice.json",
        "deployment\nginx\nginx.conf",
        "deployment\scripts\deploy.sh",
        "deployment\scripts\rollback.sh",
        "deployment\scripts\health_check.sh"
    )
    
    Create-Files -root $root -files $deploymentFiles
}

function Create-ConfigFiles {
    param($root)
    
    $configFiles = @(
        "config\development.py",
        "config\production.py",
        "config\testing.py",
        "config\logging.conf"
    )
    
    Create-Files -root $root -files $configFiles
}

function Create-MonitoringFiles {
    param($root)
    
    $monitoringFiles = @(
        "monitoring\prometheus.yml",
        "monitoring\grafana-dashboard.json",
        "monitoring\alerting-rules.yml"
    )
    
    Create-Files -root $root -files $monitoringFiles
}

function Create-SecurityFiles {
    param($root)
    
    $securityFiles = @(
        "security\cors_policy.json",
        "security\rate_limiting.json"
    )
    
    Create-Files -root $root -files $securityFiles
    
    # Create SSL certificates directory
    New-Item -ItemType Directory -Path "$root\security\ssl_certificates" -Force | Out-Null
}

function Create-RootFiles {
    param($root)
    
    $rootFiles = @(
        ".gitignore",
        ".env.example",
        "README.md",
        "LICENSE",
        "CONTRIBUTING.md",
        "CHANGELOG.md",
        "Makefile",
        "pyproject.toml"
    )
    
    Create-Files -root $root -files $rootFiles
}

function Create-Files {
    param($root, $files)
    
    foreach ($file in $files) {
        $fullPath = "$root\$file"
        $directory = Split-Path $fullPath -Parent
        
        # Create directory if it doesn't exist
        if (!(Test-Path $directory)) {
            New-Item -ItemType Directory -Path $directory -Force | Out-Null
        }
        
        # Create file with basic content
        $content = Get-FileContent -filePath $file
        Set-Content -Path $fullPath -Value $content -Force
        
        # Count created files
        $script:fileCount++
        
        Write-Host "Created: $file" -ForegroundColor Gray
    }
}

function Get-FileContent {
    param($filePath)
    
    $fileName = Split-Path $filePath -Leaf
    
    switch ($fileName) {
        { $_.EndsWith('.py') } {
            return "# $fileName - Smart Enterprise Management System`n# Auto-generated placeholder file`n`n"
        }
        { $_.EndsWith('.cs') } {
            return "// $fileName - Smart Enterprise Management System`n// Auto-generated placeholder file`n`n"
        }
        { $_.EndsWith('.razor') } {
            return @"
<!-- $fileName - Smart Enterprise Management System -->
<!-- Auto-generated placeholder file -->

<h3>$fileName</h3>
<p>Component placeholder - to be implemented</p>
"@
        }
        { $_.EndsWith('.md') } {
            return "# $fileName`n`nDocumentation placeholder - to be written`n"
        }
        { $_.EndsWith('.json') } {
            return "{}"
        }
        { $_.EndsWith('.txt') -or $_.EndsWith('requirements.txt') } {
            return "# Dependencies placeholder`n"
        }
        { $_.EndsWith('.sql') } {
            return "-- SQL schema placeholder`n"
        }
        { $_.EndsWith('.conf') -or $_.EndsWith('.ini') } {
            return "# Configuration placeholder`n"
        }
        { $_.EndsWith('.yml') -or $_.EndsWith('.yaml') } {
            return "# YAML configuration placeholder`n"
        }
        { $_.EndsWith('.html') } {
            return "<!-- HTML placeholder -->`n"
        }
        { $_.EndsWith('.css') } {
            return "/* CSS placeholder */`n"
        }
        { $_.EndsWith('.js') } {
            return "// JavaScript placeholder`n"
        }
        { $_.EndsWith('.csproj') } {
            return "<Project Sdk=`"Microsoft.NET.Sdk.BlazorWebAssembly`">`n`n  <PropertyGroup>`n    <TargetFramework>net8.0</TargetFramework>`n  </PropertyGroup>`n`n</Project>"
        }
        default {
            return "Placeholder content for $fileName`n"
        }
    }
}

# Initialize file counter
$script:fileCount = 0

# Execute the creation
try {
    Create-FolderStructure
    Write-Host "`nProject generation completed successfully!" -ForegroundColor Green
    Write-Host "Location: $(Resolve-Path $ProjectRoot)" -ForegroundColor Cyan
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Navigate to the project directory" -ForegroundColor White
    Write-Host "2. Set up Python virtual environment for backend" -ForegroundColor White
    Write-Host "3. Install dependencies from requirements.txt" -ForegroundColor White
    Write-Host "4. Set up .NET SDK for frontend development" -ForegroundColor White
    Write-Host "5. Configure environment variables in .env files" -ForegroundColor White
}
catch {
    Write-Host "Error creating project structure: $_" -ForegroundColor Red
}