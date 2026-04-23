# FarmCom 🌱
**Empowering Ugandan Farmers through Offline-First Communities & AI Diagnostics**

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)](https://supabase.com/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg?style=for-the-badge)](https://opensource.org/licenses/Apache-2.0)

> **FarmCom** bridges the severe farmer-to-extension-worker gap in Uganda. It is an offline-first, hyper-localized community platform where farmers can crowdsource knowledge, access instant AI-driven crop diagnostics, and consult verified agricultural experts via mobile money micro-transactions.

---

##  The Problem & Our Solution
In Uganda, one extension worker often serves over 2,500 farmers. Crops are lost to disease simply because expert help cannot reach the farm in time. Furthermore, rural internet connectivity is highly unreliable, rendering most AgTech apps useless in the field.

**FarmCom solves this by:**
1. **Operating Offline-First:** Farmers can access pre-loaded field guides and queue community questions entirely offline.
2. **Niche Communities:** Grouping farmers strictly by crop (e.g., Coffee, Poultry) to ensure hyper-relevant knowledge sharing.
3. **Micro-Consulting:** Integrating local mobile money (MoMo) to facilitate instant, paid consultations between farmers and verified experts.

---

##  Core Features (MVP)

* 📶 **Offline-First Engine:** Built with Isar Database. Reads, queues, and syncs data seamlessly in the background when an internet connection is detected.
* 📸 **AI Crop Diagnostics:** Low-bandwidth image uploads processed via 3rd-party APIs to instantly identify plant diseases and suggest localized treatments.
* 💬 **Peer-to-Peer Forums:** A lightweight, text-first community board for farmers to share local input prices, weather warnings, and advice.
* 💳 **Expert Escrow Payments:** Integrated MTN MoMo/Airtel Money API. Farmers pay a small fee to escalate a severe issue to a verified agronomist.

---

##  Architecture & Data Flow

FarmCom utilizes a **Feature-First Architecture** (Domain-Driven Design) to ensure scalability and maintainability.

### Entity-Relationship (ER) Diagram
*(Note for the Developer: Insert a clear photo of your paper sketch of the ER diagram here. A hand-drawn sketch effectively demonstrates your foundational architectural planning to the hub evaluators.)*

`[Insert image of Paper Sketch ER Diagram here: e.g., ![ER Diagram](assets/images/er_sketch.jpg)]`

### The Sync Logic Layer
1. **Action:** User submits a forum post while in a zero-network zone.
2. **Local Stage:** The post is saved to the local `Isar` database and flagged with `sync_status = pending`.
3. **Listener:** A background worker monitors `ConnectivityResult`.
4. **Cloud Stage:** Upon network restoration, the pending payload is pushed to `Supabase` (PostgreSQL), and the local flag is updated to `synced`.

---

##  Tech Stack

| Domain | Technology | Purpose |
| :--- | :--- | :--- |
| **Frontend** | Flutter & Dart | Cross-platform mobile development (Android/iOS) |
| **State Management**| Riverpod | Complex state handling (Online/Offline toggling) |
| **Local Database** | Isar / Hive | High-speed, NoSQL offline caching & outbox queuing |
| **Backend & Auth** | Supabase | PostgreSQL database, Storage, and Phone/OTP Auth |
| **Payments** | Flutterwave | Handling local MTN MoMo / Airtel Money transactions |

---

##  Business Case & Monetization

This platform is designed for day-one commercial viability:
* **B2C Commission:** A percentage cut from every peer-to-expert consultation processed via mobile money.
* **B2B Advertising:** Highly targeted banner ads sold to local agro-input dealers (e.g., a fertilizer company buying ad space exclusively within the "Maize" community forum).
* **Aggregated Data:** Future potential to provide anonymized, real-time crop disease mapping to government agencies and NGOs.

---

## The Future: Where FarmCom is Heading

FarmCom is starting as a community, but it is built to become the central operating system for the country's agriculture. 

* **Phase 2: The Direct Union Marketplace**
  Once we have organized farmers into niche communities, we will open the platform to bulk buyers and factories. Buyers can negotiate directly with a community of verified farmers, cutting out middlemen and ensuring farmers get fair market prices for their produce.
* **Phase 3: Unlocking Investments & Loans**
  By using FarmCom regularly, farmers build a digital track record of their farm's health and activity. This data acts as a "credit score," allowing banks, NGOs, and private investors to safely offer micro-loans and crop insurance to farmers who were previously unbankable.
* **Phase 4: The National Agricultural Dashboard**
  With thousands of farmers reporting crop health and yields on a single platform, FarmCom will create a real-time standard showing exactly how the country's agriculture is performing. This will allow government agencies to predict food shortages, track disease outbreaks, and plan better.

---

##  Getting Started (Local Development)

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (Version 3.19+)
* [Supabase CLI](https://supabase.com/docs/guides/cli) (Optional, for local backend testing)

### Installation

1. **Clone the repository**
   ```bash
   git clone [https://github.com/asiimwe-dev/FarmCom.git](https://github.com/asiimwe-dev/FarmCom.git)
   cd FarmCom

2. **Install Dependencies**
   ```bash
   flutter pub get

3. **Configure Environment Variables**
   *Create a .env file in the root directory:*
   ```bash
   SUPABASE_URL=your_supabase_url
   SUPABASE_ANON_KEY=your_anon_key
   FLUTTERWAVE_PUBLIC_KEY=your_fw_key

4. **Run the application:**
   ```bash
   flutter run

---

## Security & Data Integrity
Sync Conflict Resolution: Implements a "Last Write Wins" strategy with manual override for community forum threads to prevent data loss during multi-device syncing.

Phone Auth: Secure OTP-based authentication via Supabase for mobile-first user onboarding.

## Contributing
We welcome contributions from the developer community, especially regarding local language NLP and agricultural data modeling. Please see CONTRIBUTING.md for details.

## License
Copyright 2026 FarmCom Authors.

Licensed under the Apache License, Version 2.0; you may not use this file except in compliance with the License. You may obtain a copy of the License at:
[http://www.apache.org/licenses/LICENSE-2.0]

   
