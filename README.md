# Notes Sharing Application

A complete Python/FastAPI Notes Sharing Application with user authentication, 2FA, notes management, favorites system, file uploads, and admin panel.

## Features

### User Authentication
- User registration with email validation
- Secure login with 2FA (email OTP)
- Password reset via email verification
- Remember me functionality (30 days)
- Session management and security

### Notes Management
- Create, edit, delete notes
- Rich text content support
- File attachments (PDF, DOCX, images)
- Categorize notes
- Public/private note sharing
- Note search functionality

### Favorites System
- Add/remove notes to favorites
- Favorites page for quick access
- Favorites analytics

### Admin Panel
- Admin dashboard
- User management and statistics
- Notes administration
- Analytics and insights
- Activity monitoring

### User Experience
- Responsive Bootstrap 5 design
- Toast notifications
- Form validation
- Error handling
- Loading states

## Project Structure

```
notesharingapp_python/
├── app/                          # Main application
│   ├── __init__.py              # App factory and initialization
│   ├── models/                  # SQLAlchemy models
│   │   └── __init__.py          # User, Note, Category, etc.
│   ├── controllers/             # Flask blueprints
│   │   ├── main_controller.py   # Main routes
│   │   ├── auth_controller.py   # Authentication routes
│   │   ├── notes_controller.py  # Notes management routes
│   │   └── admin_controller.py  # Admin routes
│   ├── services/                # Business logic
│   ├── middleware/              # Custom middleware
│   ├── templates/               # Jinja2 templates
│   ├── static/                  # CSS, JS, images
│   └── uploads/                 # User file uploads
├── config.py                    # Flask configuration
├── run.py                       # Application entry point
├── requirements.txt             # Python dependencies
├── .env.example                 # Environment template
└── README.md                    # This file
```

## Test Credentials

After seeding the database:

**Admin Account:**
- Email: `admin12@gmail.com`
- Password: `admin12`

**Regular User Account:**
- Email: `testuser@gmail.com`
- Password: `password123`

## Configuration

### Environment Variables (.env)

```env
# Flask
FLASK_APP=run.py
FLASK_ENV=development
SECRET_KEY=your-secret-key

# Database
DB_HOST=127.0.0.1
DB_PORT=3306
DB_USER=root
DB_PASS=root
DB_NAME=notesharingapp_python

# Email (Gmail)
MAIL_SERVER=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your_email@gmail.com
MAIL_PASSWORD=app_specific_password

# Site
SITE_NAME=Notes Sharing App
SITE_URL=http://localhost:5000

# Security
MIN_PASSWORD_LENGTH=4
MAX_UPLOAD_SIZE=16777216  # 16MB
```

## Database Models

### User
- Full name, email, password
- Admin flag (email whitelist)
- Account status (active/inactive)
- Timestamps (created_at, updated_at)

### Note
- Title, content
- Author (foreign key to User)
- Category (foreign key)
- Public/private flag
- Deletion flag
- Timestamps

### Category
- Name, description
- Associated notes

### NoteFile
- File metadata (name, size, type)
- File path
- Associated note
- Upload timestamp

### Favorite
- User and Note references
- Unique constraint (user_id, note_id)
- Creation timestamp

### TwoFactorCode
- Associated user
- OTP code (6 digits)
- Expiration time
- Attempt tracking
- IP address logging

### RememberToken
- Associated user
- Secure token
- Expiration time
- Device info and IP tracking

## Deployment

### Development
```bash
python run.py
```

### Production (Gunicorn)
```bash
pip install gunicorn
gunicorn -w 4 -b 0.0.0.0:5000 'app:create_app()'
```

### Important: Production Settings
1. Update `.env` with `FLASK_ENV=production`
2. Generate strong `SECRET_KEY`
3. Set `SESSION_COOKIE_SECURE=True`
4. Use HTTPS/SSL certificate
5. Set up database backups
6. Configure proper email server
7. Use production database server

## Database Commands

```bash
# Initialize database (create tables)
flask init-db

# Seed with sample data
flask seed-db

# Access Flask shell
flask shell
```

## API Endpoints

### Authentication
- `POST /auth/signin` - User login
- `POST /auth/signup` - User registration
- `POST /auth/logout` - User logout
- `GET/POST /auth/verify-2fa` - 2FA verification
- `GET/POST /auth/forgot-password` - Password reset request
- `GET/POST /auth/reset-password` - Password reset

### Notes
- `GET /notes/create` - Create note form
- `POST /notes/create` - Create note
- `GET /notes/edit/<id>` - Edit note form
- `POST /notes/edit/<id>` - Update note
- `POST /notes/delete/<id>` - Delete note
- `POST /notes/favorite/<id>` - Add to favorites
- `POST /notes/unfavorite/<id>` - Remove from favorites
- `GET /notes/search` - Search notes

### Admin
- `GET /admin/dashboard` - Admin dashboard
- `GET /admin/users` - User management
- `GET /admin/notes` - Notes management
- `GET /admin/analytics` - Analytics

## Features Implementation Notes

### 2FA System
- 6-digit OTP sent via email
- 10-minute expiration
- 3 attempts before lockout
- IP address tracking
- Automatic cleanup of expired codes

### File Upload
- Secure file handling with UUID naming
- File type validation
- Size limit enforcement
- Organized storage by category
- File deletion on note removal

### Admin Access
- Email whitelist approach
- Session-based admin flag
- Decorator-based route protection
- Audit logging available

### Remember Me
- 30-day persistent tokens
- Device info tracking
- IP address verification
- Automatic token rotation

## Troubleshooting

### Database Connection Error
- Verify MySQL is running
- Check credentials in `.env`
- Ensure database exists or auto-create is enabled

### Email Not Sending
- Verify SMTP credentials
- For Gmail: Enable "Less secure app access" or use App Passwords
- Check firewall/network settings

### File Upload Issues
- Check upload folder permissions
- Verify file size limits
- Ensure file type is in whitelist

### 2FA Code Not Received
- Check email configuration
- Verify email is in allowed domain
- Check email spam folder

## Resources

- [Flask Documentation](https://flask.palletsprojects.com/)
- [SQLAlchemy Documentation](https://www.sqlalchemy.org/)
- [Flask-Login Documentation](https://flask-login.readthedocs.io/)
- [Flask-Mail Documentation](https://flask-mail.readthedocs.io/)

## License

This is a conversion of the original PHP application to Python. All original features and functionality are maintained.
