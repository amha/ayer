# Ayer - Air Quality Monitoring App

A Flutter application that provides real-time air quality information and environmental data visualization.

## Features

- Real-time air quality monitoring
- Interactive data visualization
- Location-based air quality information
- Environmental impact tracking
- Beautiful UI with animations and visual feedback

## Prerequisites

- Flutter SDK (version >=3.4.4)
- Dart SDK
- Android Studio / Xcode (for platform-specific development)
- Git

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/ayer.git
cd ayer
```

2. Install dependencies:
```bash
flutter pub get
```

3. Set up environment variables:
   - Copy `.env.example` to `.env`
   - Fill in your API credentials in the `.env` file:
     ```
     AIR_QUALITY_API_TOKEN=your_api_token_here
     AIR_QUALITY_API_URL=https://api.waqi.info/feed/
     DEFAULT_CITY=newyorkcity
     ```

## Running the App

### Development
```bash
flutter run
```

### Build
```bash
# For Android
flutter build apk

# For iOS
flutter build ios
```

## Project Structure

```
ayer/
├── lib/              # Main application code
├── assets/           # Images, animations, and other static files
├── test/             # Test files
├── android/          # Android-specific files
├── ios/              # iOS-specific files
└── web/              # Web-specific files
```

## Dependencies

- http: ^1.1.0
- flutter_dotenv: ^5.0.2
- provider: ^6.1.2
- path_provider: ^2.1.2
- url_launcher: ^6.3.1
- rive: ^0.13.20
- lottie: ^3.3.1

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Flutter](https://flutter.dev/) - The framework used
- [World Air Quality Index](https://waqi.info/) - Air quality data provider
