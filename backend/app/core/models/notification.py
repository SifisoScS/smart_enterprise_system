from database.connection import db
from .base_model import BaseModel

class Notification(BaseModel):
    """Notification model for user notifications"""
    __tablename__ = 'notifications'
    
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    title = db.Column(db.String(255), nullable=False)
    message = db.Column(db.Text, nullable=False)
    notification_type = db.Column(db.String(50))  # e.g., 'info', 'warning', 'success'
    is_read = db.Column(db.Boolean, default=False)
    read_at = db.Column(db.DateTime)
    
    # Relationship
    user = db.relationship('User', backref=db.backref('notifications', lazy=True))
    
    def mark_as_read(self):
        """Mark notification as read"""
        from datetime import datetime
        self.is_read = True
        self.read_at = datetime.utcnow()
        db.session.commit()
    
    def to_dict(self):
        """Convert notification to dictionary"""
        base_dict = super().to_dict()
        base_dict.update({
            'user_id': self.user_id,
            'title': self.title,
            'message': self.message,
            'notification_type': self.notification_type,
            'is_read': self.is_read,
            'read_at': self.read_at.isoformat() if self.read_at else None
        })
        return base_dict