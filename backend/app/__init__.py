"""
Smart Enterprise Management System - Flask Application Factory
Foundation Phase with secure defaults
"""

import os
from flask import Flask, jsonify
from flask_cors import CORS
from dotenv import load_dotenv

def create_app(config=None):
    """Application factory function"""
    
    # Load environment variables
    load_dotenv()
    
    app = Flask(__name__)
    
    # Basic configuration
    app.config.from_mapping(
        # Security
        SECRET_KEY=os.getenv('SECRET_KEY', 'fallback-secret-key-change-in-production'),
        
        # Database
        SQLALCHEMY_DATABASE_URI=os.getenv('DATABASE_URL', 'sqlite:///../database/development.db'),
        SQLALCHEMY_TRACK_MODIFICATIONS=False,
        
        # JWT
        JWT_SECRET_KEY=os.getenv('JWT_SECRET_KEY', 'fallback-jwt-secret-change-in-production'),
        
        # File Uploads
        MAX_CONTENT_LENGTH=int(os.getenv('MAX_CONTENT_LENGTH', 16777216)),  # 16MB
        UPLOAD_FOLDER=os.getenv('UPLOAD_FOLDER', '../uploads'),
        
        # CORS
        CORS_ORIGINS=os.getenv('CORS_ORIGINS', 'http://localhost:5000').split(',')
    )
    
    # Override with custom config if provided
    if config is not None:
        app.config.from_mapping(config)
    
    # Initialize extensions
    initialize_extensions(app)
    
    # Register routes
    register_routes(app)
    
    # Register error handlers
    register_error_handlers(app)
    
    return app

def initialize_extensions(app):
    """Initialize Flask extensions"""
    from database.connection import db, init_db
    
    # Database
    db.init_app(app)
    init_db(app)
    
    # CORS
    CORS(app, origins=app.config['CORS_ORIGINS'])

def register_routes(app):
    """Register all routes"""
    
    # Health check endpoint
    @app.route('/api/health')
    def health_check():
        return jsonify({
            'status': 'healthy',
            'service': 'Smart Enterprise Management System',
            'version': '1.0.0',
            'environment': os.getenv('FLASK_ENV', 'development')
        })
    
    # API documentation endpoint
    @app.route('/api/docs')
    def api_docs():
        return jsonify({
            'message': 'Smart Enterprise Management System API',
            'version': '1.0.0',
            'endpoints': {
                'health': '/api/health',
                'auth': '/api/auth/* (coming soon)',
                'maintenance': '/api/maintenance/* (coming soon)',
                'education': '/api/education/* (coming soon)'
            },
            'documentation': 'API documentation will be available here'
        })
    
    # Root endpoint
    @app.route('/')
    def root():
        return jsonify({
            'message': 'Smart Enterprise Management System API',
            'version': '1.0.0',
            'endpoints': {
                'health': '/api/health',
                'docs': '/api/docs'
            }
        })

def register_error_handlers(app):
    """Register error handlers"""
    
    @app.errorhandler(404)
    def not_found(error):
        return jsonify({
            'error': 'Not Found',
            'message': 'The requested resource was not found',
            'status_code': 404
        }), 404
    
    @app.errorhandler(500)
    def internal_error(error):
        return jsonify({
            'error': 'Internal Server Error',
            'message': 'An internal server error occurred',
            'status_code': 500
        }), 500