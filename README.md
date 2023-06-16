# Google ML Vision Face Recognition Completed Flutter App for both iOS and Android

This is the realtime face recognition flutter app using both Google ML Vision and TensorFlow Lite running well on both Android and iOS to utilize both ways in order to recognize face as fast as real-time. Tflite Model is being used in this app is "mobilefacenet.tflite".


## Steps

### Face detection

Used Firebase Google ML Vision to detect faces. This is the **ON-DEVICE** ML vision tool of Google which means we either don't need any corresponding project on Firebase or JSON files.

### Face Recognition

Use mobilefacenet.tflite pretrained model along with tflite_flutter widget for this purpose.

## Installing

**Step 1:** Download or clone this repo:

```
git clone https://github.com/ngtrphuong/facerecognition.git
```

**Step 2:** Go to project root and execute the following command in console to get the required dependencies: 

```
flutter pub get 
```

**Step 3:** Add/update library to ensure flutter app works well with iOS devvices

Firstly, we can always create flutter iOS cache via command " ** flutter precache --ios ** " in root directory of Flutter app

Secondly, go into ios directory via **cd ios** and perform command **pod install** to install all necessary libraries for iOS app

The last, as usual, open Runner.xcworkplace and configure required fields, parameters prior to running in either on Android Studio or in terminal as normal

**Step 4:** Install flutter app

```
flutter run 
```

