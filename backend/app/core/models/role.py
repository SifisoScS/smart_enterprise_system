from database.connection import db
from .base_model import BaseModel

# Association table for many-to-many relationship between users and roles
user_roles = db.Table('user_roles',
    db.Column('user_id', db.Integer, db.ForeignKey('users.id'), primary_key=True),
    db.Column('role_id', db.Integer, db.ForeignKey('roles.id'), primary_key=True),
    db.Column('assigned_at', db.DateTime, default=db.func.current_timestamp())
)

class Role(BaseModel):
    """Role model for role-based access control"""
    __tablename__ = 'roles'
    
    name = db.Column(db.String(100), unique=True, nullable=False)
    description = db.Column(db.Text)
    
    def to_dict(self):
        """Convert role to dictionary"""
        base_dict = super().to_dict()
        base_dict.update({
            'name': self.name,
            'description': self.description
        })
        return base_dict
    
    def __repr__(self):
        return f'<Role {self.name}>'