from datetime import datetime
from database.connection import db
from .base_model import BaseModel

class AuditLog(BaseModel):
    """Audit log for tracking user actions"""
    __tablename__ = 'audit_logs'
    
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    action = db.Column(db.String(100), nullable=False)  # e.g., 'login', 'create', 'update'
    resource_type = db.Column(db.String(100))  # e.g., 'User', 'MaintenanceRequest'
    resource_id = db.Column(db.Integer)  # ID of the affected resource
    description = db.Column(db.Text)
    ip_address = db.Column(db.String(45))  # IPv6 compatible
    user_agent = db.Column(db.Text)
    
    # Relationship
    user = db.relationship('User', backref=db.backref('audit_logs', lazy=True))
    
    def to_dict(self):
        """Convert audit log to dictionary"""
        base_dict = super().to_dict()
        base_dict.update({
            'user_id': self.user_id,
            'action': self.action,
            'resource_type': self.resource_type,
            'resource_id': self.resource_id,
            'description': self.description,
            'ip_address': self.ip_address,
            'user_agent': self.user_agent,
            'user_email': self.user.email if self.user else None
        })
        return base_dict