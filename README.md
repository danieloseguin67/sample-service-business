# Service Business - Angular Template

A professional Angular 17 template website for service industry businesses with multi-language support and database connectivity.

## Features

- ✅ **Multi-language Support**: Available in English, French, and Spanish
- ✅ **Responsive Design**: Mobile-friendly layout
- ✅ **Modern UI**: Clean and professional interface
- ✅ **Database Ready**: SQL Server integration setup
- ✅ **Routing**: Multi-page application with navigation
- ✅ **Internationalization**: Complete i18n implementation using ngx-translate

## Project Structure

```
service-business/
├── src/
│   ├── app/
│   │   ├── components/
│   │   │   ├── header/              # Navigation header with language switcher
│   │   │   ├── footer/              # Footer component
│   │   │   └── language-switcher/   # Language selection component
│   │   ├── pages/
│   │   │   ├── home/                # Homepage with service highlights
│   │   │   ├── services/            # Services listing page
│   │   │   └── contact/             # Contact information page
│   │   ├── services/
│   │   │   └── database.service.ts  # Database service for backend API
│   │   ├── app.routes.ts            # Route configuration
│   │   └── app.component.ts         # Main app component
│   └── assets/
│       └── i18n/                    # Translation files (en, fr, es)
├── server.js                        # Backend server example (SQL Server)
└── DATABASE_SETUP.md                # Database setup instructions
```

## Quick Start

### 1. Install Dependencies

```bash
npm install
```

### 2. Run Development Server

```bash
ng serve
```

Navigate to `http://localhost:4200/`. The application will automatically reload if you change any of the source files.

### 3. Build for Production

```bash
ng build
```

The build artifacts will be stored in the `dist/` directory.

## Multi-Language Support

The application supports three languages:
- **English** (en) - Default
- **French** (fr)
- **Spanish** (es)

### Using the Language Switcher

Click the language buttons in the header to switch between languages. The application will remember your language preference.

### Translation Files

Translation files are located in `src/assets/i18n/`:
- `en.json` - English translations
- `fr.json` - French translations
- `es.json` - Spanish translations

To add more languages:
1. Create a new JSON file in `src/assets/i18n/`
2. Add the language to the `languages` array in `language-switcher.component.ts`
3. Update the `supportedLangs` array in `app.component.ts`

## Database Connection

The application is configured to connect to SQL Server:

- **Server**: localhost
- **User**: developer
- **Password**: Storedindotenv
- **Database**: service_business

⚠️ **Security Note**: Direct database connections from the frontend are not recommended. Please see `DATABASE_SETUP.md` for proper backend setup instructions.

### Backend Setup

1. **Install backend dependencies**:
   ```bash
   npm install express mssql cors
   ```

2. **Start the backend server**:
   ```bash
   node server.js
   ```

3. **See full setup instructions**: Refer to `DATABASE_SETUP.md`

## Contact Information

The contact page displays:
- **Address**: 7227 Newman Boulevard, Unit 1504, Montreal, Quebec, H8N 0H7
- **Phone**: (514) 555-0123
- **Email**: info@servicebusiness.com

## Running Tests

Run `ng test` to execute the unit tests via [Karma](https://karma-runner.github.io).

## Technology Stack

- **Angular**: 17.3.0
- **TypeScript**: 5.4.2
- **ngx-translate**: 15.0.0 (for internationalization)
- **MSSQL**: Latest (for SQL Server connectivity)
- **SCSS**: For styling

## Further Development

### Code Scaffolding

Run `ng generate component component-name` to generate a new component. You can also use `ng generate directive|pipe|service|class|guard|interface|enum|module`.

### Customization

- Update company information in translation files (`src/assets/i18n/*.json`)
- Modify colors and styles in component SCSS files
- Add new pages by creating components in `src/app/pages/`
- Configure database connection in `src/app/services/database.service.ts`

## Support

For more help on Angular CLI, use `ng help` or check out the [Angular CLI Documentation](https://angular.io/cli).

## License

This project is a template and can be freely used and modified for your business needs.
