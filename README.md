# FarmCom 🌱

**Offline-First Mobile Platform Bridging the Rural Agriculture Extension Gap in East Africa**

[![Flutter](https://img.shields.io/badge/Flutter-3.19+-02569B?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.1+-0175C2?style=flat-square&logo=dart&logoColor=white)](https://dart.dev/)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Linux-informational?style=flat-square)](https://flutter.dev/)
[![Status](https://img.shields.io/badge/Status-Production%20Ready-brightgreen?style=flat-square)](#)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg?style=flat-square)](https://opensource.org/licenses/Apache-2.0)

---

## Problem Statement

In Uganda, **one agricultural extension worker serves over 2,500 farmers**. Critical crop diseases go undiagnosed because expert help cannot reach farms in time. Additionally, rural internet connectivity is unreliable and expensive—rendering most agricultural technology applications impractical in the field.

**Result:** Preventable crop losses, farmer poverty, and food insecurity.

---

## The Solution

**FarmCom** is a production-ready mobile application that enables reliable agricultural knowledge-sharing and expert consultation in low-connectivity environments. The platform operates entirely offline while intelligently syncing data when connectivity is available.

### How It Works

1. **Offline-First Architecture** — Farmers access the app from any location, even without internet. All data (explore guides, community discussions, diagnostic history) is stored locally.

2. **Hyper-Local Communities** — Farmers are organized into crop-specific communities (Coffee, Maize, Poultry, etc.) to ensure knowledge is contextually relevant.

3. **AI-Powered Diagnostics** — One photo of a diseased crop → instant disease identification and localized treatment recommendations via Plant.id API integration.

4. **Expert Micro-Consulting** — Farmers can escalate complex issues to verified agronomists via paid consultations, with payments handled through local mobile money (MTN MoMo, Airtel Money).

5. **Automatic Sync** — When the device connects to internet, all locally-queued community posts, diagnostic results, and transaction data automatically sync to the backend.

---

## Core Features

| Feature | Description |
|---------|-------------|
| 📱 **Phone OTP Authentication** | Simple, secure login via one-time passwords (no password fatigue for rural users) |
| 🗺️ **Crop-Niche Communities** | Peer-to-peer forums organized by crop type for hyper-relevant knowledge sharing |
| 📸 **AI Crop Diagnostics** | Real-time disease identification from camera photos with treatment recommendations |
| 📚 **Field Guide** | Offline encyclopedia of crops, diseases, growing techniques, and best practices |
| 💬 **Community Forums** | Lightweight text-first message boards for farmers to crowdsource solutions |
| 💳 **Mobile Money Payments** | Expert consultations through escrow-protected mobile money transactions |
| 🔄 **Automatic Sync** | Seamless background sync when internet becomes available (no manual user intervention) |
| 📊 **Dashboard** | Home screen with quick actions, market prices, and community highlights |

---

## Roadmap & Vision

### **Phase 1 (Current)** — Community Knowledge Platform
Farmers organize into crop communities, crowdsource solutions, and access AI diagnostics.

### **Phase 2** — Farmer-to-Buyer Direct Marketplace
Once farmers are organized into verified communities, connect them directly with bulk buyers and factories. Eliminates middlemen, ensures fair pricing.

### **Phase 3** — Credit Scoring & Lending
Farmers build a digital credit history through app activity. Banks and investors use this data to offer micro-loans and crop insurance to previously unbankable farmers.

### **Phase 4** — National Agricultural Dashboard
Aggregate anonymized data from thousands of farmers to create real-time crop health metrics for government agencies. Enables better food security planning and disease outbreak tracking.

---

## Tech Stack

| Layer | Technology | Rationale |
|-------|-----------|-----------|
| **Mobile Frontend** | Flutter 3.19+ | Cross-platform (Android/iOS/Linux), single codebase, offline-capable |
| **Application Logic** | Dart 3.1+ | Type-safe, null-safe, AOT-compilable |
| **State Management** | Riverpod 2.4+ | Reactive dependency injection, easy testing, zero boilerplate |
| **Local Database** | Isar 3.1.0+ | Fast NoSQL, offline-first, ideal for outbox pattern & sync |
| **Backend** | PostgreSQL + Supabase | Open-source, scalable, real-time capabilities, auth included |
| **Authentication** | OTP (Phone-based) | Mobile-first, accessible for rural users, secure |
| **Payments** | Flutterwave | Local mobile money (MTN, Airtel), low transaction fees |
| **Image Processing** | Plant.id API | Reliable crop disease identification via ML |

---

## Business Model

### Revenue Streams

1. **Commission on Expert Consultations** — Take a % cut of every paid consultation between farmer and agronomist
2. **B2B Advertising** — Sell targeted ad space to agro-input companies within specific crop communities
3. **Data Licensing** — Anonymized, aggregated crop health data to government agencies and NGOs (future)
4. **B2B Marketplace Fees** — Commission on transactions between farmers and bulk buyers (Phase 2)
5. **Micro-Loan Interest** — Interest income from micro-lending powered by farmer credit scores (Phase 3)

### Day-One Viability
FarmCom is designed to generate revenue from launch—not dependent on future features or external funding.

---

## Project Status

| Component | Status | Notes |
|-----------|--------|-------|
| **Frontend** | ✅ Production-Ready | All 6 features complete, 0 compilation errors, DDD architecture |
| **Backend Infrastructure** | 🔄 In Development | PostgreSQL schema design, Supabase RLS policies |
| **API Endpoints** | 🔄 In Development | RESTful spec, auth guards, rate limiting |
| **Testing Suite** | 🔄 In Development | Unit tests ready, integration tests in progress |
| **Deployment Pipeline** | 🔄 Planning | CI/CD for APK/IPA builds, app store submission prep |

---

## Getting Started

For developers: See [ARCHITECTURE.md](ARCHITECTURE.md) for complete development setup, feature documentation, and deployment instructions.

**Quick Start:**
```bash
git clone https://github.com/asiimwe-dev/FarmCom.git
cd FarmCom/frontend
flutter pub get
flutter run
```

---

## Team & Ownership

**FarmCom** is developed by a small team of full-stack engineers focused on production-quality code and sustainable impact in East African agriculture.

**Core Principles:**
- Production-ready code (no shortcuts, no tech debt)
- Clean architecture (DDD + Clean Architecture patterns)
- Offline-first design (work without connectivity)
- User-centric (built with rural users in mind)
- Open source (Apache 2.0 License)

---

## Security & Privacy

- **OTP-based authentication** (no passwords to compromise)
- **End-to-end encrypted** payment transactions via Flutterwave
- **Local-first data** (sensitive farmer data stays on device until explicitly synced)
- **Last-Write-Wins** conflict resolution with manual override capability
- **PostgreSQL Row-Level Security** (RLS) to ensure farmers see only their own data

---

## Contributing

We welcome contributions from the open-source community, particularly:
- Agricultural domain experts (disease identification, localized treatments)
- Backend engineers (Supabase/PostgreSQL optimization)
- Mobile developers (performance, battery optimization)
- Language experts (local language UI/content)

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

---

## License

**Apache License 2.0**

Copyright © 2026 FarmCom Contributors

See [LICENSE](LICENSE) file for full license text.

---

## Contact & Support

For questions, feature requests, or partnership inquiries:
- **GitHub Issues**: [Report bugs or request features](https://github.com/asiimwe-dev/FarmCom/issues)
- **Email**: [gilbertasiiimwe00@gmail.com](mailto:gilbertasiiimwe00@gmail.com)

- **Documentation**: [ARCHITECTURE.md](ARCHITECTURE.md) | [API Spec](#) (coming soon)

---

**FarmCom is building the digital infrastructure for sustainable, equitable agriculture in East Africa.** 🌾
