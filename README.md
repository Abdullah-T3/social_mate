# Social Mate

Social Mate is a Flutter-based social media management application that focuses on content moderation and report handling. The application provides features for both users and administrators to manage social media content effectively.

## Features

### User Features
- Post creation and management
- Comment system
- Content reporting system
- Interactive user interface with animations
- Real-time updates

### Admin Features
- Report management dashboard
- Content moderation tools
- Report filtering system
- Detailed report analytics
- Status tracking (Pending, Approved, Cascaded Approval, Rejected)

## Technology Stack

- **Frontend**: Flutter
- **State Management**: Flutter Bloc
- **Dependency Injection**: GetIt
- **Environment Configuration**: flutter_dotenv
- **UI Components**: Custom widgets with responsive design

## Project Structure

```plaintext
lib/
├── core/
│   ├── Responsive/         # Responsive design components
│   ├── di/                 # Dependency injection setup
│   ├── helper/             # Helper utilities
│   ├── routing/            # App routing configuration
│   ├── shared/            # Shared widgets and components
│   └── theming/           # App theming and styling
├── features/
│   ├── admin/             # Admin-related features
│   ├── authentication/    # User authentication
│   ├── filtering/         # Content filtering
│   ├── posts/            # Post management
│   └── splash_screen/    # App splash screen
└── main.dart             # Application entry point
```

## Getting Started

1. Clone the repository: `https://github.com/Abdullah-T3/social_mate.git`
2. Install dependencies: `flutter pub get`
3. Set up environment variables:
   - Create a `.env` file in the root directory.
   - Add the required environment variables (e.g., API keys, database URLs).
4. Run the application: `flutter run`

## Architecture
The application follows a clean architecture pattern with the following layers:

- Presentation Layer : Contains UI components and BLoC state management
- Domain Layer : Houses business logic and entities
- Data Layer : Manages data sources and repositories
### Key Components
- BLoC Pattern : Implements business logic components for state management
- Repository Pattern : Abstracts data sources
- Clean Architecture : Ensures separation of concerns
- Responsive Design : Adapts to different screen sizes

## Development Guidelines
1. Code Style
   - Follow Flutter's official style guide
   - Use meaningful variable and function names
   - Write comments for complex logic
2. State Management
   - Use BLoC for complex state management
   - Keep UI components stateless when possible
   - Implement proper error handling
3. Testing
   - Write unit tests for business logic
   - Implement widget tests for UI components
   - Perform integration testing for critical features