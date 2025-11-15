from database.connection import db
from .base_model import BaseModel

class FileUpload(BaseModel):
    """File upload model for storing file metadata"""
    __tablename__ = 'file_uploads'
    
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    filename = db.Column(db.String(255), nullable=False)
    original_filename = db.Column(db.String(255), nullable=False)
    file_path = db.Column(db.String(500), nullable=False)
    file_size = db.Column(db.Integer)  # Size in bytes
    mime_type = db.Column(db.String(100))
    description = db.Column(db.Text)
    
    # Relationship
    user = db.relationship('User', backref=db.backref('file_uploads', lazy=True))
    
    def to_dict(self):
        """Convert file upload to dictionary"""
        base_dict = super().to_dict()
        base_dict.update({
            'user_id': self.user_id,
            'filename': self.filename,
            'original_filename': self.original_filename,
            'file_path': self.file_path,
            'file_size': self.file_size,
            'mime_type': self.mime_type,
            'description': self.description
        })
        return base_dict