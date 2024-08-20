<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/github/license/gzaber/ForexViewer" alt="license MIT"></a>

# Deadline Manager

Web application for managing deadlines.  
It is designed to manage deadlines in a small company.
It can be used to manage sample deadlines:
cars insurance,
cars technical inspection,
employees medical examination, etc.

[<img alt="responsive" src=".graphics/rec1.gif" />](.graphics/rec1.gif)  
[<img alt="desktop" src=".graphics/rec2.gif" />](.graphics/rec2.gif)  
[<img alt="mobile" width="250px" src=".graphics/rec3.gif" />](.graphics/rec3.gif)

## Features

- list of all deadlines
- list of categories
- list of deadlines for each category
- list of reading permissions
- manage categories
- manage deadlines
- manage permissions
- sign up / sign in with email and password
- delete account

## Packages

- firebase_ui_auth, firebase_auth
- cloud_firestore
- bloc, flutter_bloc
- go_router

## Architecture

&nbsp;
[<img alt="architecture" src=".graphics/architecture.png" />](.graphics/architecture.png)

## Run

### Firebase

1. Create your Firebase project using Firebase console.
2. Enable email authentication provider.

### Web

1. Use the FlutterFire CLI to configure the application to connect to Firebase.
2. From the Flutter project directory, run the following command to generate the configuration:
   `flutterfire configure`

3. Run the application: `flutter run`
