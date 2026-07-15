# ARC Driver App Documentation

## 1. Overview
The **ARC Driver** application is a dedicated platform for logistics professionals. It manages the end-to-end delivery lifecycle, from receiving ride requests to cargo loading, transit navigation, and payment collection. The app focuses on high-precision status tracking (Loading/Unloading) and secure customer verification.

---

## 2. App Structure
The application mirrors the modular architecture of the project:
- **`screens/`**: UI for each stage of the driver's journey (Login, Dashboard, Loading, Transit, etc.).
- **`widgets/`**: Reusable components like `RideRequestCard`, `CustomButton`, and `CustomTextField`.
- **`providers/`**: 
    - `AuthProvider`: Manages login session, profile data, and authentication state.
    - `RideProvider`: A complex state machine managing the `RideStatus` lifecycle.
- **`services/`**: API handlers for Auth and Profile (using Dio).
- **`models/`**: Data classes like `DriverModel`.
- **`utils/`**: Driver-specific theme (`DriverColors`) and shared constants.

---

## 3. User Flow (Logistics Lifecycle)
1.  **Authentication**: Driver logs in via mobile and password.
2.  **Dashboard**: Toggle **Online** status to start receiving requests.
3.  **Ride Acceptance**: 
    - Receive notification card with fare and distance.
    - **Accept** to initiate the pickup flow.
4.  **Pickup & Verification**:
    - Navigate to the pickup location.
    - Confirm arrival.
    - **PIN Verification**: Enter the 4-digit PIN provided by the customer to authorize loading.
5.  **Loading Module**:
    - Start Loading → Loading In Progress → Loading Completed.
6.  **Transit**:
    - Start Ride → Navigate to Destination → Confirm Arrival.
7.  **Unloading Module**:
    - Start Unloading → Unloading In Progress → Unloading Completed.
8.  **Completion & Payment**:
    - Review Trip Summary (Distance, Duration, Fare).
    - Collect Payment (Cash or QR Code Scan).
    - Payment Success → Return to Home.

---

## 4. Screen Hierarchy & Navigation Flow
### **Auth & Setup**
- `SelectionScreen` (Global)
  - → `LoginScreen` (Driver Auth)

### **Main Hub**
- **Home Tab**: Online/Offline toggle, Active Request listener.
- **History Tab**: List of past trips (Completed/Cancelled).
- **Profile Tab**: Account details, Vehicle info, Logout.

### **Ride Execution Stack (Modal/Sequential)**
- `HomeScreen` (Request) 
  - → `PickupRouteScreen` (Navigation to user)
    - → `PinVerificationScreen` (Security check)
      - → `LoadingScreen` (Status management)
        - → `RideProgressScreen` (Navigation to destination)
          - → `UnloadingScreen` (Final cargo handling)
            - → `RideCompletionScreen` (Fare summary)
              - → `PaymentScreen` (QR/Cash)
                - → `PaymentSuccessScreen` (Confirmation)

---

## 5. Module Descriptions
- **State Engine (RideProvider)**: The brain of the app. It tracks the specific state of the cargo (Idle, Loading, In-Transit, Unloading) to ensure accurate timing and status updates.
- **Verification Module**: Ensures the driver is at the right location and with the right customer via PIN entry.
- **Logistics Module**: Dedicated screens for loading and unloading to capture "Logistics Time" separately from "Driving Time".
- **Payment Module**: Handles fare presentation and captures payment confirmation.

---

## 6. High-Level API Planning

| Module | API Name | Purpose |
| :--- | :--- | :--- |
| **Auth** | Login | Authenticates driver and returns a session token. |
| | Get Profile | Fetches driver details, vehicle info, and online status. |
| | Toggle Online | Updates the driver's availability on the server. |
| **Ride** | Accept/Reject | Updates the booking status when a driver responds to a request. |
| | Update Status | Pushes state changes (Arrived, Loading, Started, etc.) to the backend. |
| | Verify PIN | Validates the customer PIN against the booking record. |
| **Tracking**| Update Location | Periodic background push of driver GPS coordinates. |
| **Payment** | Confirm Payment| Notifies server that funds have been collected. |
| **History** | Trip History | Fetches a list of completed assignments for the driver. |

**Estimated Total API Count: 10-12 APIs**

---
