"""
Database connection and initialization
Foundation Phase - Secure database setup
"""

from flask_sqlalchemy import SQLAlchemy
import os

db = SQLAlchemy()

def init_db(app):
    """Initialize database with application context"""
    with app.app_context():
        # Import all models here to ensure they are registered with SQLAlchemy
        from app.core.models import base_model, tenant, user, role, permission, audit_log, notification, file_upload
        
        # Create all tables
        db.create_all()
        
        # Create initial data if in development
        if os.getenv('FLASK_ENV') == 'development':
            create_initial_data()

def create_initial_data():
    """Create initial development data"""
    from app.core.models.tenant import Tenant
    from app.core.models.user import User
    from app.core.models.role import Role
    
    # Check if we already have data
    if Tenant.query.first() is None:
        print("Creating initial development data...")
        
        # Create default tenant
        default_tenant = Tenant(
            name="Default Organization",
            slug="default",
            description="Default organization for development",
            contact_email="admin@example.com",
            is_active=True
        )
        db.session.add(default_tenant)
        db.session.flush()  # Get the tenant ID
        
        # Create default roles
        admin_role = Role(name="Administrator", description="System administrator")
        user_role = Role(name="User", description="Regular user")
        manager_role = Role(name="Manager", description="Department manager")
        db.session.add_all([admin_role, user_role, manager_role])
        
        # Create default admin user
        admin_user = User(
            email="admin@example.com",
            first_name="System",
            last_name="Administrator",
            is_active=True,
            tenant_id=default_tenant.id
        )
        admin_user.set_password("admin123")  # Change in production!
        admin_user.roles.append(admin_role)
        
        db.session.add(admin_user)
        db.session.commit()
        
        print("✅ Initial development data created")
        print("   Default admin: admin@example.com / admin123")
        print("   ⚠️  Change default credentials in production!")
    else:
        print("ℹ️  Database already has data, skipping initial data creation")