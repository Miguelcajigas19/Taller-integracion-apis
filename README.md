# README.md

## Overview

This is a Flutter web application project (Flutter App Taller) designed as a case study or workshop example. The application integrates REST and GraphQL APIs, provides local data persistence, and features a complete Spanish interface for managing posts and viewing country information. The project demonstrates modern Dart web development with secure DOM manipulation, API integration, and local storage capabilities.

## Recent Changes

**2024-09-20**: Implementación de filtrado de posts y funcionalidad de eliminación:
- Configurado filtrado de posts de API REST para mostrar solo los 4 primeros posts anteriores al post específico "sunt aut facere repellat provident..."
- Agregada funcionalidad para eliminar posts individualmente con confirmación del usuario
- Implementados botones de eliminar en la interfaz solo para posts locales/de usuario (userId >= 100)
- Mantenida persistencia segura que preserva posts del usuario entre sesiones

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