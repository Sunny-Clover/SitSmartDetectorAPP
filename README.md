# SitSmart Detector

A SwiftUI-based iOS application that uses machine learning to detect and monitor sitting posture in real-time, helping users maintain healthy sitting habits.

> **⚠️ Important**: This application requires the [SitSmartDetector-Server](https://github.com/Sunny-Clover/SitSmartDetector-Server.git) server to be running for full functionality. Please set up and start the backend server before using this app.

## Features

### Real-time Posture Detection
- Live camera feed analysis using MoveNet pose estimation
- Monitors 5 key body parts: Head, Shoulder, Back, Waist, and Thigh
- Provides instant feedback with visual indicators (correct/incorrect/ambiguous)
- Audio and visual warnings for incorrect posture

### User Progress Tracking
- Gamification with levels and experience points
- Achievement badges for maintaining good posture
- Detailed statistics including:
  - Average posture score
  - Total detection time
  - User percentile ranking
  - Goal completion tracking

### History & Analytics
- Comprehensive detection history with time-based filtering (day/week/month/year)
- Interactive charts:
  - Pie charts showing posture distribution
  - Line charts tracking posture trends over time
- Detailed reports for each detection session

### Social Features
- Friend system with search functionality
- Friend request management (send/accept/decline)
- Compare scores and progress with friends
- WebRTC integration for sharing detection sessions

### User Profile
- Customizable avatar with photo upload
- Profile settings and personalization
- Level progress visualization

## Technical Stack

### Frameworks & Libraries
- **SwiftUI** - Modern declarative UI framework
- **TensorFlow Lite** - On-device machine learning inference
  - MoveNet model for pose estimation
  - Custom posture classification model
- **SwiftData** - Local data persistence
- **TipKit** - In-app guidance and tips
- **AVFoundation** - Camera capture and processing
- **WebRTC** - Real-time streaming capabilities
- **Custom Backend** - FastAPI-based backend server (separate repository)

### Architecture
- **MVVM Pattern** - Clean separation of concerns
- ViewModels: `DetectionViewModel`, `AuthManager`, `UserInfoViewModel`, `HistoryViewModel`, `FriendViewModel`
- Service Layer: `NetworkService`, `UserService`, `RecordService`, `FriendService`, `TokenService`
- Models: SwiftData models for User, Record, and Friend data

## Requirements

- iOS 17.0 or later
- Xcode 15.0 or later
- CocoaPods
- Camera permission for posture detection
- **Backend server running** - See [Backend Setup](#backend-setup) section
- Internet connection for backend features

## Installation

### 1. Backend Setup (Required)

**This app requires the backend server to be running first.**

Navigate to the backend project and follow the setup instructions:

```bash
cd /path/to/SitSmartDetector-Server

# Quick start with Docker (recommended)
docker-compose up --build

# Or follow the detailed instructions in the backend README:
# https://github.com/Sunny-Clover/SSD_Backend
```

The backend provides:
- FastAPI server at `http://localhost:8000`
- WebSocket server for WebRTC signaling
- MySQL database for user data and detection records
- RESTful API for authentication, friends, and detections

For detailed backend setup instructions, see the [SitSmartDetector-Server README](https://github.com/Sunny-Clover/SitSmartDetector-Server).

### 2. iOS App Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/Sunny-Clover/SitSmartDetectorAPP.git
   cd SitSmartDetectorAPP
   ```

2. Install dependencies using CocoaPods:
   ```bash
   pod install
   ```

3. Open the workspace in Xcode:
   ```bash
   open SitSmartDetection_SwiftUI.xcworkspace
   ```

4. Configure backend URL in `SitSmartDetection_SwiftUI/Config.swift`:
   ```swift
   // Update these URLs to match your backend server
   baseURL = URL(string: "http://YOUR_BACKEND_IP:8000")!
   wsBaseURL = URL(string: "ws://YOUR_BACKEND_IP:8000")!
   ```

   - For local development: `http://localhost:8000` (iOS Simulator)
   - For device testing: `http://YOUR_COMPUTER_IP:8000` (replace with your local IP)
   - For production: Use your deployed backend URL

5. Build and run the project in Xcode

> **Note**: Make sure the backend server is accessible from your iOS device/simulator. If testing on a physical device, both the device and the computer running the backend must be on the same network.

## Project Structure

```
SitSmartDetection_SwiftUI/
├── Auth/                      # Authentication views and logic
├── Detection/                 # Posture detection core functionality
│   ├── DetectionView.swift
│   ├── DetectionViewModel.swift
│   ├── CameraManager.swift
│   └── WarningManager.swift
├── Home/                      # Home screen with user statistics
├── History/                   # Detection history and analytics
├── Friend/                    # Social features and friend management
├── ProfileView/               # User profile and settings
├── Movenet/                   # MoveNet pose estimation integration
│   ├── PoseEstimator.swift
│   ├── postureClassifier.swift
│   └── Extensions/
├── Service/                   # Network and API services
├── SwiftDataModel/            # Data models
├── Utilities/                 # Helper classes and extensions
└── Config.swift              # App configuration
```

## Key Components

### Detection System
- **CameraManager**: Handles camera feed and frame capture
- **PoseEstimator**: Uses MoveNet to detect body keypoints
- **postureClassifier**: Classifies posture as correct/incorrect
- **WarningManager**: Manages alerts and notifications for incorrect posture
- **DetectionViewModel**: Orchestrates the detection pipeline

### Machine Learning Models
- **MoveNet**: Pre-trained model for human pose estimation
- **Custom Classifier**: Trained model for posture classification on 5 body parts

## Usage

1. **Sign Up/Sign In**: Create an account or log in
2. **Start Detection**:
   - Navigate to the Detection tab
   - Grant camera permission
   - Tap the play button to start monitoring
   - Adjust your position to be visible in the camera frame
3. **View Feedback**:
   - Real-time indicators show posture status for each body part
   - Listen for audio warnings when incorrect posture is detected
4. **Track Progress**:
   - Check your Home tab for statistics and achievements
   - View detailed history in the History tab
5. **Connect with Friends**:
   - Search and add friends
   - Compare scores and motivate each other

## Backend Integration

This app uses a **custom FastAPI backend** for all server-side functionality. The backend is a separate project located at `/Volumes/SSD/Desktop/專題程式/SSD_Backend`.

### Backend Features
The app communicates with the backend server for:
- **Authentication**: User registration, login, and JWT token management
- **User Management**: Profile data, avatar upload, statistics
- **Detection Records**: Store and retrieve posture detection history
- **Friend System**: Search users, send/accept friend requests, view friends list
- **WebRTC Signaling**: WebSocket-based signaling for real-time video streaming
- **Leaderboard**: User rankings based on posture scores

### Backend Technologies
- **FastAPI**: Python web framework
- **MySQL**: Database for persistent storage
- **WebSocket**: Real-time communication for WebRTC signaling
- **JWT**: Token-based authentication
- **Docker**: Containerized deployment

### API Configuration

Backend endpoints are configured in `SitSmartDetection_SwiftUI/Config.swift`:
```swift
struct Config {
    let baseURL: URL      // HTTP REST API endpoints
    let wsBaseURL: URL    // WebSocket endpoint for WebRTC signaling

    private init() {
        baseURL = URL(string: "http://192.168.8.124:8000")!
        wsBaseURL = URL(string: "ws://192.168.8.124:8000")!
    }
}
```

### Main API Endpoints Used

**Authentication**:
- `POST /auth/register` - User registration
- `POST /auth/login` - User login
- `POST /auth/refresh` - Refresh access token

**Users**:
- `GET /users/me` - Get current user profile
- `PUT /users/me` - Update user profile
- `POST /users/me/avatar` - Upload avatar image

**Detections**:
- `POST /detections/` - Create new detection record
- `GET /detections/` - Get user's detection history
- `GET /detections/{id}` - Get specific detection details

**Friends**:
- `GET /users/search?username={query}` - Search users
- `POST /friend-requests/` - Send friend request
- `GET /friend-requests/` - Get pending friend requests
- `PUT /friend-requests/{id}/accept` - Accept friend request
- `GET /friends/` - Get friends list

**WebSocket**:
- `ws://backend/ws/phone?token={jwt}` - Phone streaming endpoint
- `ws://backend/ws/viewer?token={jwt}` - Viewer receiving endpoint

For complete API documentation, run the backend and visit `http://localhost:8000/docs`.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- TensorFlow Lite for iOS machine learning capabilities
- MoveNet for pose estimation
- FastAPI for the backend framework
- The Swift and iOS development community