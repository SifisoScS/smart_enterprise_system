from datetime import datetime
from werkzeug.security import generate_password_hash, check_password_hash
from database.connection import db
from .base_model import BaseModel

class User(BaseModel):
    """User model for authentication and authorization"""
    __tablename__ = 'users'
    
    email = db.Column(db.String(255), unique=True, nullable=False)
    password_hash = db.Column(db.String(255), nullable=False)
    first_name = db.Column(db.String(100), nullable=False)
    last_name = db.Column(db.String(100), nullable=False)
    phone = db.Column(db.String(50))
    last_login = db.Column(db.DateTime)
    
    # Foreign keys
    tenant_id = db.Column(db.Integer, db.ForeignKey('tenants.id'), nullable=False)
    
    # Relationships
    roles = db.relationship('Role', secondary='user_roles', backref=db.backref('users', lazy=True))
    
    def set_password(self, password):
        """Set password hash"""
        self.password_hash = generate_password_hash(password)
    
    def check_password(self, password):
        """Check password against hash"""
        return check_password_hash(self.password_hash, password)
    
    def update_last_login(self):
        """Update last login timestamp"""
        self.last_login = datetime.utcnow()
        db.session.commit()
    
    def to_dict(self):
        """Convert user to dictionary (excluding sensitive data)"""
        base_dict = super().to_dict()
        base_dict.update({
            'email': self.email,
            'first_name': self.first_name,
            'last_name': self.last_name,
            'phone': self.phone,
            'last_login': self.last_login.isoformat() if self.last_login else None,
            'tenant_id': self.tenant_id,
            'roles': [role.name for role in self.roles]
        })
        return base_dict
    
    def __repr__(self):
        return f'<User {self.email}>'