# SmartSit Flutter UI Prototype

This is the responsive Flutter/Dart UI prototype created from the supplied React/Vite SmartSit frontend and the screenshots provided for the FYP. Backend APIs, database access, live sensor streaming and machine-learning predictions are not included.

## Included screens

### Authentication
- User Sign In
- Separate Admin / Owner Sign In
- Sign Up
- Forgot Password
- OTP Verification
- Set New Password

### User panel
- Overview dashboard
- Live Monitoring
- Posture History
- Reports UI draft
- Relief Exercises and Correct Postures
- User Settings / Account Information / Logout

### Admin panel
- User Management
- Product Catalog / Inventory
- Customer Support tickets
- Admin Settings: Profile, Security, Notifications and System Preferences

## Demo roles and access

The app now has distinct User and Admin/Owner sign-in screens:

- **User sign in** opens only the User panel. The profile menu does not contain an Admin-panel switch.
- **Admin / Owner sign in** opens the Admin panel. An admin session can switch to the User panel and switch back to Admin.
- The local demo owner account is `owner@smartsit.local` with password `SmartSitOwner2026!`.
- User sign in is a UI preview and opens the User panel without validating the entered credentials. Sign-up and password-reset flows only navigate between sample screens.

**Security limitation:** The admin credential check is hardcoded solely to demonstrate different UI access paths. It is not real security, and it must not be used for a deployed or real-user app. Real permissions must later be validated by a trusted backend. A person who can inspect the source can discover any hardcoded demo credential.

## Run on Windows / Android Studio

1. Extract the ZIP.
2. Open the extracted `smartsit_flutter_ui` folder in VS Code or Android Studio.
3. Open a terminal in that folder.
4. Run `flutter doctor` and fix any missing Flutter/Android SDK setup.
5. This archive contains Dart source code and assets but not generated Android/Web platform folders. In the project root, run this once:

   ```powershell
   flutter create --platforms=android,web --no-pub .
   ```

6. Then run:

   ```powershell
   flutter pub get
   flutter devices
   flutter run -d emulator-5554
   ```

   Replace `emulator-5554` with the device ID shown by `flutter devices` if yours is different.

## Responsive UI work in this version

- Typographic SmartSit wordmark matches the web sidebar more closely.
- Page headings adapt to narrow screens; action controls move below the heading when space is limited.
- Navigation uses a desktop sidebar and mobile drawer / bottom navigation.
- User and Admin panels have separate menu structures and profile-menu permissions within this UI prototype.
- Overview metrics, monitoring rows and heatmap treatment were adjusted toward the supplied reference screenshots.
- History uses the website-like asymmetric chart/event grid on wide screens and stacks cards on phones.
- Exercise cards use bundled images and expand to four columns on wide layouts, then stack on mobile.
- Admin user management uses a table on wider screens and cards on phones.
- Product Catalog, support queue/conversation and Admin Settings use responsive layouts closer to the supplied web screenshots.
- User Settings now includes a profile header, account status/role, information rows and a logout section.

## UI-only limitations

Scores, charts, sessions, tickets, users and products use sample values. No live cushion connection, database/API integration, PDF generation, real email/OTP delivery or persistent profile changes are implemented. A few illustrations and profile/product images load from the same external image URLs as the web source; when the device has no internet, fallback visuals are shown.

The original React Reports page contained placeholder text, so the Flutter Reports page remains a styled UI draft rather than a pixel-identical recreation of an implemented web page.
