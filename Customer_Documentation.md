# ARC Customer App Documentation

## 1. Overview
The **ARC Customer** application is a premium ride-booking and logistics platform. It enables users to request vehicles for various needs, providing real-time tracking, transparent fare estimation, and a streamlined multi-step authentication process.

---

## 2. App Structure
The application follows a modular, feature-based architecture:
- **`screens/`**: UI implementations for authentication, booking, and tracking.
- **`widgets/`**: Reusable components such as `CustomTextField`, `VehicleSelectionSheet`, and `BottomSheetContainer`.
- **`providers/`**: 
    - `ProfileProvider`: Manages user profile fetching and updates.
    - `BookingProvider` (Planned): To manage active booking state.
- **`services/`**: 
    - `AuthService`: Handles OTP sending, verification, and registration via HTTP.
    - `PreferenceService`: Manages persistent local storage (Tokens, User data).
- **`utils/`**: Theme constants, validation logic, and responsive UI helpers.

---

## 3. User Flow
1.  **Selection**: Choose "Customer" mode on the Selection Screen (sets temporary app mode).
2.  **Authentication**:
    - **Login**: Enter mobile number to receive a 6-digit OTP.
    - **OTP Verification**: Enter the code received via SMS.
    - **Registration**: For new users, collect Name, Email, and Gender.
3.  **App Activation**: Upon successful login/registration, the app mode is saved permanently, and the user enters the Home Dashboard.
4.  **Booking Journey**:
    - **Location**: Set Pickup (defaults to current GPS) and Drop-off locations using Google Maps/Places.
    - **Vehicle Selection**: Select from available vehicle types with estimated fares.
    - **Matching**: Driver is assigned to the booking.
5.  **Ride Phase**:
    - Track driver arrival.
    - Live tracking during the trip.
    - Verify completion and view final summary.

---

## 4. Screen Hierarchy & Navigation Flow
### **Onboarding & Auth**
- `SelectionScreen` (Temporary Mode)
  - → `LoginScreen` (OTP Request)
    - → `OTPScreen` (Verification)
      - → `RegistrationScreen` (First-time users)

### **Main Application (Bottom Nav)**
- **Home Screen**: 
    - Map View
    - `LocationSelectionScreen`
    - `VehicleSelectionScreen` (Bottom Sheet)
- **History Screen**: List of previous bookings.
- **Profile Screen**: 
    - `EditProfileScreen`
    - Settings & Support
    - Logout (Restarts app to Selection Screen)

### **Ride Workflow**
- `BookingConfirmationScreen` → `DriverAssignedScreen` → `LiveTrackingScreen` → `RideCompleteScreen`

---

## 5. Module Descriptions
- **Auth Module**: Implements a secure OTP-based flow. It differentiates between login and registration based on user existence in the backend.
- **Map & Location**: Utilizes `google_maps_flutter` and `geolocator`. It handles address selection via a dedicated search interface.
- **Profile Module**: Synchronizes server-side user data with local `SharedPreferences` for offline access and performance.
- **Session Management**: Implements a "Double-Verification" mode where the app mode is only locked after successful authentication.

---

## 6. High-Level API Planning

| Module | API Name | Purpose |
| :--- | :--- | :--- |
| **Auth** | Send OTP | Initiates the authentication process. |
| | Verify OTP | Validates code; returns user status (new/existing) and token. |
| | Register | Completes profile for new users. |
| **Profile** | Get Profile | Retrieves full user details. |
| | Update Profile | Updates name, email, or gender. |
| **Booking** | Fare Calculation| Estimates costs based on distance and vehicle type. |
| | Create Booking | Places the ride request in the system. |
| | Cancel Ride | Aborts a pending or accepted request. |
| **History** | Get History | Retrieves list of past transactions. |
| **Tracking**| Stream Driver | Webhook or polling for live driver coordinates. |

**Estimated Total API Count: 12-14 APIs**

---
