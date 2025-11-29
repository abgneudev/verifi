# Verifi

> **Offline P2P Payment App with AI-Powered Smart Contracts**

Verifi is a Flutter-based offline payment solution that enables peer-to-peer transactions without internet connectivity. Using AI-mediated escrow contracts and nearby device connections, Verifi ensures secure, transparent, and trustworthy payments even in low-connectivity environments.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.8.1-02569B?logo=flutter)
![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-lightgrey)

---

## ✨ Features

### 🤖 AI-Powered Contract Negotiation
- **Dynamic Contract Drafting**: AI mediates contract negotiations between buyer and seller
- **Smart Suggestions**: Context-aware recommendations for fair terms
- **Version Control**: Track all contract iterations with hash verification
- **Multi-round Negotiation**: Iterative proposals until both parties agree

### 🔐 Secure Escrow System
- **Cryptographic Hashing**: SHA-256 contract verification
- **Proof-of-Work Submission**: Image-based proof validation using on-device AI vision models
- **Consensus Mechanism**: AI analyzes proof images to determine contract fulfillment
- **Automated Release**: Funds released only when both parties and AI consensus agree

### 📡 Offline-First Architecture
- **Nearby Connections**: Bluetooth & WiFi Direct for device-to-device communication
- **Zero Internet Required**: Complete transaction flow works without network
- **Peer-to-Peer**: Direct communication between buyer and seller devices

### 🎨 Modern UI/UX
- **Glass-Pop Design System**: Combines Stripe's clean aesthetics with CRED's vibrant neo-pop style
- **Dark Mode**: Sleek void-black gradient backgrounds with glassmorphic cards
- **Haptic Feedback**: Tactile response for all interactions
- **Real-time Status**: Live connection and transaction state monitoring

---

## 🏗️ Architecture

### Tech Stack
- **Frontend**: Flutter 3.8.1 with Riverpod state management
- **AI Engine**: Cactus LM (on-device LLM) with `lfm2-vl-450m` vision model
- **Connectivity**: Google Nearby Connections API
- **Cryptography**: cryptography package for encryption, crypto for hashing
- **State Management**: flutter_riverpod with freezed for immutable models

### Key Components

#### Services Layer
- **`CactusAIService`**: On-device AI for contract mediation and proof analysis
- **`ContractService`**: Contract versioning, hashing, and validation logic
- **`CryptoService`**: Key pair generation and secure communication
- **`NearbyConnectionsService`**: P2P device discovery and connection management

#### Models (Freezed + JSON Serializable)
- **`ContractState`**: Contract drafts, versions, and approval status
- **`EscrowState`**: Funds locking, proof submission, release logic
- **`ConnectionState`**: Device discovery, connection status, role assignment
- **`AIConsensusState`**: AI analysis results and decision tracking

#### UI Widgets
- **`ConnectionButtons`**: Advertise/Discover controls with permission handling
- **`ContractDraftSection`**: Multi-round negotiation interface with AI suggestions
- **`LockFundsSection`**: Secure funds commitment interface
- **`ProofSubmissionSection`**: Image capture/selection for work completion
- **`FundsReleasedSection`**: Final transaction confirmation
- **`StatusMonitor`**: Real-time connection and transaction state display

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.8.1 or higher
- Dart 3.8.1+
- Android SDK (API 21+) or iOS 12+
- Physical devices for testing (emulators don't support Nearby Connections)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/abgneudev/verifi.git
   cd verifi/test_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run on device**
   ```bash
   flutter run
   ```

### Permissions Setup

#### Android (`android/app/src/main/AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.BLUETOOTH_ADVERTISE" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.NEARBY_WIFI_DEVICES" />
<uses-permission android:name="android.permission.CAMERA" />
```

#### iOS (`ios/Runner/Info.plist`)
```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Verifi needs Bluetooth to connect with nearby devices for secure offline payments</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Location is required for Bluetooth device discovery</string>
<key>NSCameraUsageDescription</key>
<string>Camera is needed to capture proof of work for contract verification</string>
```

---

## 📱 Usage Flow

### 1. **Connection Phase**
- **Seller**: Taps "Advertise" to broadcast their device
- **Buyer**: Taps "Discover" to find nearby sellers
- **Connection**: Buyer selects seller from discovered list

### 2. **Contract Negotiation**
- **Initial Draft**: Seller creates contract terms (description, amount, conditions)
- **AI Mediation**: Cactus AI analyzes fairness and suggests improvements
- **Counter-Proposals**: Buyer can accept, reject, or propose modifications
- **Iteration**: Both parties negotiate until consensus is reached
- **Final Approval**: Both parties cryptographically sign the agreed contract

### 3. **Escrow & Execution**
- **Lock Funds**: Buyer commits payment amount to escrow
- **Work Completion**: Seller performs agreed services/delivery
- **Proof Submission**: Seller uploads image proof of completion

### 4. **AI Consensus & Release**
- **Vision Analysis**: On-device AI analyzes proof images on both devices
- **Consensus Check**: AI models on buyer and seller devices reach agreement
- **Automated Release**: If consensus met, funds automatically released to seller
- **Dispute Handling**: Manual review if AI models disagree

---

## 🎨 Design System

Verifi uses a custom **Glass-Pop** design language:

### Color Palette
- **Void Black** (`#0E1117`): Primary background
- **Hyper Violet** (`#635BFF`): AI/active states
- **Neon Mint** (`#00D68F`): Success indicators
- **Signal Orange** (`#FF7043`): Warnings/pending
- **Electric Pink** (`#FF3366`): Action buttons

### Components
- **`GlassCard`**: Glassmorphic container with blur effects
- **`NeoPopButton`**: CRED-style elevated buttons with haptics
- **`StatusBadge`**: Color-coded state indicators
- **`AmountDisplay`**: Large financial number formatting

---

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run with coverage
flutter test --coverage
```

---

## 🛠️ Development

### Code Generation
```bash
# Watch mode for continuous generation
flutter pub run build_runner watch

# One-time generation
flutter pub run build_runner build --delete-conflicting-outputs
```

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── design_system.dart        # Theme, colors, reusable widgets
├── models/                   # Freezed data models
│   ├── contract_state.dart
│   ├── escrow_state.dart
│   ├── connection_state.dart
│   └── ai_consensus_state.dart
├── providers/                # Riverpod state providers
│   └── app_providers.dart
├── services/                 # Business logic
│   ├── cactus_ai_service.dart
│   ├── contract_service.dart
│   ├── crypto_service.dart
│   └── nearby_connections_service.dart
└── widgets/                  # UI components
    ├── connection_buttons.dart
    ├── contract_draft_section.dart
    ├── lock_funds_section.dart
    ├── proof_submission_section.dart
    ├── funds_released_section.dart
    └── status_monitor.dart
```

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **Cactus AI**: On-device LLM for contract mediation
- **Google Nearby Connections**: Offline P2P communication
- **Flutter Community**: Amazing ecosystem and packages
- **Design Inspiration**: Stripe (clean UI) + CRED (neo-pop vibrancy)

---

## 📧 Contact

**Repository**: [github.com/abgneudev/verifi](https://github.com/abgneudev/verifi)

---

## 🔮 Future Roadmap

- [ ] Multi-currency support (Bitcoin, Ethereum, stablecoins)
- [ ] Voice-based contract negotiation
- [ ] Reputation system for trusted traders
- [ ] Dispute arbitration with human mediators
- [ ] Encrypted chat between parties
- [ ] QR code payment shortcuts
- [ ] Multi-party contracts (3+ participants)
- [ ] Integration with hardware wallets

---

**Built with ❤️ for offline-first commerce**
