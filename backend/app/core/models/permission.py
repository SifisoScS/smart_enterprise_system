from database.connection import db
from .base_model import BaseModel

class Permission(BaseModel):
    """Permission model for granular access control"""
    __tablename__ = 'permissions'
    
    name = db.Column(db.String(100), unique=True, nullable=False)
    description = db.Column(db.Text)
    module = db.Column(db.String(50))  # e.g., 'maintenance', 'education'
    action = db.Column(db.String(50))  # e.g., 'read', 'write', 'delete'
    
    def to_dict(self):
        """Convert permission to dictionary"""
        base_dict = super().to_dict()
        base_dict.update({
            'name': self.name,
            'description': self.description,
            'module': self.module,
            'action': self.action
        })
        return base_dict