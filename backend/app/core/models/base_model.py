from datetime import datetime
from database.connection import db

class BaseModel(db.Model):
    """Base model with common fields for all models"""
    __abstract__ = True
    
    id = db.Column(db.Integer, primary_key=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)
    is_active = db.Column(db.Boolean, default=True, nullable=False)
    
    def save(self):
        """Save the model to the database"""
        db.session.add(self)
        db.session.commit()
    
    def delete(self):
        """Soft delete the model"""
        self.is_active = False
        self.save()
    
    def to_dict(self):
        """Convert model to dictionary"""
        return {
            'id': self.id,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None,
            'is_active': self.is_active
        }