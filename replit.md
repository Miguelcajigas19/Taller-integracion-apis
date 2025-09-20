# Replit.md

## Overview

This is a Flutter web application project (Flutter App Taller) designed as a case study or workshop example. The application is configured to run in a web environment with Spanish language support and features a custom loading screen with animated spinner. The project appears to be a minimal Flutter setup focused on web deployment, likely used for educational or demonstration purposes.

## User Preferences

Preferred communication style: Simple, everyday language.

## System Architecture

### Frontend Architecture
- **Framework**: Flutter web application using Dart
- **Compilation**: Dart code compiled to JavaScript using dart2js compiler
- **UI Structure**: Single-page application with custom HTML wrapper
- **Styling**: CSS-based styling with gradient backgrounds and loading animations
- **Language Support**: Spanish (es) locale configured as primary language

### Web Architecture
- **Entry Point**: Custom HTML index file with embedded loading screen
- **Loading Strategy**: Progressive loading with visual feedback using CSS animations
- **Responsive Design**: Viewport meta tag configured for mobile-first approach
- **Performance**: Deferred library loading support for code splitting

### Build System
- **Package Management**: Pub package manager (version 3.8.1)
- **Configuration**: Dart language version 3.0 with minimal dependencies
- **Compilation Target**: Web platform with CSP (Content Security Policy) support
- **Output**: JavaScript bundle (main.dart.js) for browser execution

## External Dependencies

### Development Tools
- **Dart SDK**: Version 3.8.1 for compilation and build processes
- **Pub Cache**: Package management and dependency resolution
- **dart2js Compiler**: JavaScript compilation with CSP and intern-composite-values support

### Runtime Dependencies
- **Web Browser**: Modern browser support for ES6+ features
- **No External APIs**: Currently no third-party service integrations identified
- **No Database**: No persistent storage mechanisms configured
- **No Authentication**: No authentication or authorization systems present

### Build Dependencies
- **Flutter SDK**: Web-enabled Flutter framework
- **Package Config**: Minimal configuration with no external package dependencies
- **Static Assets**: Self-contained web assets with embedded styling