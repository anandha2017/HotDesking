# Hot Desking App

A SwiftUI-based iOS application for managing hot desk bookings in office environments.

## Features

- **User Authentication**: Login and registration system with local storage
- **Office Management**: Browse multiple office locations
- **Floor Navigation**: View different floors within each office
- **Desk Booking**: Book available desks with real-time status updates
- **Booking Management**: View and cancel your current bookings
- **User Profile**: Manage user information and logout

## Architecture

- **SwiftUI**: Modern declarative UI framework
- **Core Data**: Local data persistence with CloudKit integration
- **MVVM Pattern**: Clean separation of concerns with ViewModels
- **Combine**: Reactive programming for data flow

## Data Models

- **User**: User accounts with email, name, and role
- **Office**: Office locations with coordinates
- **Floor**: Floor layouts within offices
- **Desk**: Individual desks with position and amenities
- **Booking**: Desk reservations with time slots

## Key Components

### Views
- `LoginView`: User authentication interface
- `MainTabView`: Tab-based navigation
- `OfficeListView`: Office selection
- `FloorListView`: Floor navigation
- `DeskListView`: Desk booking interface
- `BookingsListView`: User booking management
- `ProfileView`: User profile and logout

### Services
- `AuthService`: User authentication and session management
- `BookingService`: Desk booking operations
- `DataSeedingService`: Sample data generation
- `CoreDataStack`: Core Data setup and CloudKit integration

### ViewModels
- `LoginViewModel`: Authentication state management
- `BookingViewModel`: User booking management
- `DeskBookingViewModel`: Desk booking operations

## Getting Started

1. Open `HotDesking.xcodeproj` in Xcode
2. Select a simulator or device
3. Build and run the project
4. Register a new account or login
5. Browse offices and book desks

## Sample Data

The app automatically seeds sample data including:
- London Office and New York Office
- Multiple floors with various desk configurations
- Desks with different amenities (monitors, keyboards, phones, webcams)

## Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+
