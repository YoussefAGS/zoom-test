// import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
//
// import '../../../../core/Resources/auth_method.dart';
// import 'firestore_methods.dart';
//
// class JitsiMeetMethods {
//   final AuthMethods _authMethods = AuthMethods();
//   final FirestoreMethods _firestoreMethods = FirestoreMethods();
//   void createMeeting({
//     required String roomName,
//     required bool isAudioMuted,
//     required bool isVideoMuted,
//     String username = 'ddd',
//   }) async {
//     try {
//       String name;
//       if (username.isEmpty) {
//         FeatureFlag featureFlag = FeatureFlag();
//         featureFlag.welcomePageEnabled = false;
//         featureFlag.resolution = FeatureFlagVideoResolution
//             .MD_RESOLUTION; // Limit video resolution to 360p
//         name = _authMethods.user.displayName!;
//       } else {
//         name = username;
//       }
//
//       var options = JitsiMeetingOptions(
//         roomNameOrUrl: roomName,
//         userDisplayName: name, // Directly set userDisplayName in the constructor
//         userEmail: _authMethods.user.email,
//         userAvatarUrl: _authMethods.user.photoURL,
//         isAudioMuted: isAudioMuted,
//         isVideoMuted: isVideoMuted,
//
//       );
//       // Assuming _firestoreMethods is an instance of FirestoreMethods
//       _firestoreMethods.addToMeetingHistory(roomName);
//
//       await JitsiMeetWrapper.joinMeeting( options: options,
//           listener: JitsiMeetingListener(
//           onConferenceWillJoin: (url) => print("onConferenceWillJoin: url: $url"),
//     onConferenceJoined: (url) => print("onConferenceJoined: url: $url"),
//     onConferenceTerminated: (url, error) => print("onConferenceTerminated: url: $url, error: $error"),
//     ),);
//     } catch (error) {
//       print("error: $error");
//     }
//   }
// }
// class FeatureFlag {
//   bool welcomePageEnabled = true;
//   FeatureFlagVideoResolution resolution = FeatureFlagVideoResolution.HD_RESOLUTION; // Default to HD resolution
// }
//
// enum FeatureFlagVideoResolution {
//   MD_RESOLUTION, // 360p
//   HD_RESOLUTION, // 720p
//   FHD_RESOLUTION, // 1080p
// }
// import 'package:flutter/cupertino.dart';
// import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
//
// import '../../../../core/Resources/auth_method.dart';
// import 'feature_flage.dart';
//
//
// class JitsiMeetMethod {
//   final AuthMethods _authMethods = AuthMethods();
//   // final FirestoreMethods _firestoreMethods = FirestoreMethods();
//
//   final serverText = TextEditingController();
//   final roomText = TextEditingController(text: "jitsi-meet-wrapper-test-room");
//   final subjectText = TextEditingController(text: "My Plugin Test Meeting");
//   final tokenText = TextEditingController();
//
//   bool isAudioMuted = true;
//   bool isAudioOnly = false;
//   bool isVideoMuted = true;
//
//   void createMeeting({
//     required String roomName,
//     required bool isAudioMuted,
//     required bool isVideoMuted,
//     String username = '',
//   }) async {
//     try {
//       String? serverUrl =
//       serverText.text.trim().isEmpty ? null : serverText.text;
//
//       Map<FeatureFlag, Object> featureFlags = {
//         // FeatureFlag.isWelcomePageEnabled,
//         // FeatureFlag.resolution,
//       } ;
//
//
//
//       String name;
//       if (username.isEmpty) {
//         name = _authMethods.user.displayName!;
//       } else {
//         name = username;
//       }
//
//       // Define meetings options here
//       var options = JitsiMeetingOptions(
//         // roomNameOrUrl: roomName
//         roomNameOrUrl: roomText.text,
//         serverUrl: serverUrl,
//         subject: subjectText.text,
//         token: tokenText.text,
//         isAudioMuted: isAudioMuted,
//         isAudioOnly: isAudioOnly,
//         isVideoMuted: isVideoMuted,
//         userDisplayName: _authMethods.user.displayName,
//         userEmail: _authMethods.user.email,
//         featureFlags: featureFlags,
//       );
//
//       // await JitsiMeetWrapper.joinMeeting(
//       //   options: options,
//       //   listener: JitsiMeetingListener(
//       //     onConferenceWillJoin: (url) => print("onConferenceWillJoin: url: $url"),
//       //     onConferenceJoined: (url) => print("onConferenceJoined: url: $url"),
//       //     onConferenceTerminated: (url, error) => print("onConferenceTerminated: url: $url, error: $error"),
//       //   ),
//       // );
//
//       debugPrint("JitsiMeetingOptions: $options");
//       await JitsiMeetWrapper.joinMeeting(
//         options: options,
//         listener: JitsiMeetingListener(
//           onOpened: () => debugPrint("onOpened"),
//           onConferenceWillJoin: (url) {
//             debugPrint("onConferenceWillJoin: url: $url");
//           },
//           onConferenceJoined: (url) {
//             debugPrint("onConferenceJoined: url: $url");
//           },
//           onConferenceTerminated: (url, error) {
//             debugPrint("onConferenceTerminated: url: $url, error: $error");
//           },
//           onAudioMutedChanged: (isMuted) {
//             debugPrint("onAudioMutedChanged: isMuted: $isMuted");
//           },
//           onVideoMutedChanged: (isMuted) {
//             debugPrint("onVideoMutedChanged: isMuted: $isMuted");
//           },
//           onScreenShareToggled: (participantId, isSharing) {
//             debugPrint(
//               "onScreenShareToggled: participantId: $participantId, "
//                   "isSharing: $isSharing",
//             );
//           },
//           onParticipantJoined: (email, name, role, participantId) {
//             debugPrint(
//               "onParticipantJoined: email: $email, name: $name, role: $role, "
//                   "participantId: $participantId",
//             );
//           },
//           onParticipantLeft: (participantId) {
//             debugPrint("onParticipantLeft: participantId: $participantId");
//           },
//           onParticipantsInfoRetrieved: (participantsInfo, requestId) {
//             debugPrint(
//               "onParticipantsInfoRetrieved: participantsInfo: $participantsInfo, "
//                   "requestId: $requestId",
//             );
//           },
//           onChatMessageReceived: (senderId, message, isPrivate) {
//             debugPrint(
//               "onChatMessageReceived: senderId: $senderId, message: $message, "
//                   "isPrivate: $isPrivate",
//             );
//           },
//           onChatToggled: (isOpen) =>
//               debugPrint("onChatToggled: isOpen: $isOpen"),
//           onClosed: () => debugPrint("onClosed"),
//         ),
//       );
//
//       // _firestoreMethods.addToMeetingHistory(roomName);
//       // await JitsiMeet.joinMeeting(options);
//     } catch (error) {
//       print("error: $error");
//     }
//   }
// }
import 'package:flutter/foundation.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';

import '../../../../core/Resources/auth_method.dart';
import 'firestore_methods.dart';

class JitsiMeetMethod {
  final AuthMethods _authMethods = AuthMethods();
  final FirestoreMethods _fireStoreMethods = FirestoreMethods();

  void createMeeting({
    required String roomName,
    required bool isAudioMuted,
    required bool isVideoMuted,
    String username = '',
  }) async {
    try {
      Map<FeatureFlag, Object> featureFlags = {
        FeatureFlag.isWelcomePageEnabled: false,
      };
      String name;
      if (username.isEmpty) {
        name = _authMethods.user.displayName!;
      } else {
        name = username;
      }
      var options = JitsiMeetingOptions(
          roomNameOrUrl: roomName,
          userDisplayName: name,
          userEmail: _authMethods.user.email,
          isAudioMuted: isAudioMuted,
          userAvatarUrl: _authMethods.user.photoURL,
          isVideoMuted: isVideoMuted,
          featureFlags: featureFlags
      );

      _fireStoreMethods.addToMeetingHistory(roomName);
      await JitsiMeetWrapper.joinMeeting(
        options: options,
      );
    } catch (error) {
      if (kDebugMode) {
        print("error: $error");
      }
    }
  }
}