from database.connection import db
from .base_model import BaseModel

class Tenant(BaseModel):
    """Organization/company/school tenant model"""
    __tablename__ = 'tenants'
    
    name = db.Column(db.String(255), nullable=False)
    slug = db.Column(db.String(100), unique=True, nullable=False)
    description = db.Column(db.Text)
    contact_email = db.Column(db.String(255))
    contact_phone = db.Column(db.String(50))
    address = db.Column(db.Text)
    
    # Relationships
    users = db.relationship('User', backref='tenant', lazy=True)
    
    def to_dict(self):
        """Convert tenant to dictionary"""
        base_dict = super().to_dict()
        base_dict.update({
            'name': self.name,
            'slug': self.slug,
            'description': self.description,
            'contact_email': self.contact_email,
            'contact_phone': self.contact_phone,
            'address': self.address
        })
        return base_dict