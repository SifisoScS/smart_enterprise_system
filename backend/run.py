#!/usr/bin/env python3
"""
Smart Enterprise Management System - Backend Entry Point
Foundation Phase - Secure startup with environment validation
"""

import os
import sys
import logging
from dotenv import load_dotenv

# Add the backend directory to Python path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

def setup_logging():
    """Configure application logging with Windows compatibility"""
    # Check if we're on Windows and adjust logging accordingly
    if os.name == 'nt':
        # Use basic characters for Windows console
        startup_message = "STARTING Smart Enterprise Management System Backend"
        debug_warning = "WARNING: Debug mode is enabled. Do not use in production!"
    else:
        # Use emojis for other systems
        startup_message = "🚀 Starting Smart Enterprise Management System Backend"
        debug_warning = "⚠️  Debug mode is enabled. Do not use in production!"
    
    logging.basicConfig(
        level=os.getenv('LOG_LEVEL', 'INFO'),
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
        handlers=[
            logging.StreamHandler(),
            logging.FileHandler('logs/app.log') if os.path.exists('logs') else logging.StreamHandler()
        ]
    )
    
    return startup_message, debug_warning

def validate_environment():
    """Validate that required environment variables are set"""
    required_vars = [
        'SECRET_KEY',
        'JWT_SECRET_KEY', 
        'DATABASE_URL'
    ]
    
    missing_vars = []
    for var in required_vars:
        if not os.getenv(var):
            missing_vars.append(var)
    
    if missing_vars:
        logging.error(f"Missing required environment variables: {', '.join(missing_vars)}")
        logging.error("Please check your .env file and ensure all required variables are set")
        return False
    
    # Warn about using default secrets in production
    if os.getenv('FLASK_ENV') == 'production':
        default_secrets = [
            'your-development-secret-key-change-in-production',
            'your-super-secure-jwt-secret-key-change-this-in-production',
            'dev-secret-key-2024-sems-foundation',
            'dev-jwt-secret-2024-sems-change-in-production',
            'fallback-secret-key-change-in-production',
            'fallback-jwt-secret-change-in-production'
        ]
        
        current_secret = os.getenv('SECRET_KEY')
        current_jwt_secret = os.getenv('JWT_SECRET_KEY')
        
        if current_secret in default_secrets or current_jwt_secret in default_secrets:
            logging.warning("WARNING: You are using default secret keys in production!")
            logging.warning("   Please change SECRET_KEY and JWT_SECRET_KEY in your production environment")
    
    return True

def main():
    """Main application entry point"""
    # Load environment variables
    load_dotenv()
    
    # Setup logging and get platform-appropriate messages
    startup_message, debug_warning = setup_logging()
    
    # Validate environment
    if not validate_environment():
        logging.error("Environment validation failed. Application cannot start.")
        sys.exit(1)
    
    # Import and create app after validation
    from app import create_app
    
    app = create_app()
    
    # Get configuration
    host = os.getenv('FLASK_RUN_HOST', '0.0.0.0')
    port = int(os.getenv('FLASK_RUN_PORT', 5001))
    debug = os.getenv('FLASK_DEBUG', 'False').lower() == 'true'
    
    logging.info(startup_message)
    logging.info(f"   Environment: {os.getenv('FLASK_ENV', 'development')}")
    logging.info(f"   Debug mode: {debug}")
    logging.info(f"   Server: {host}:{port}")
    logging.info(f"   Database: {os.getenv('DATABASE_URL', 'Not configured')}")
    
    if debug:
        logging.warning(debug_warning)
    
    # Start the application
    try:
        app.run(
            host=host,
            port=port,
            debug=debug,
            load_dotenv=False  # We already loaded dotenv
        )
    except Exception as e:
        logging.error(f"Failed to start application: {e}")
        sys.exit(1)

if __name__ == '__main__':
    main()