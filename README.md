# Device Info API Flutter App

Flutter를 사용한 모바일 디바이스 정보 조회 및 관리 애플리케이션입니다.

## ■ 주요 기능

### 기기 정보 조회
- OS 버전 (Android/iOS)
- 기기 UUID
- Flutter 앱 버전 (앱의 버전 넘버로 대체)
- 연락처 개수 (미확인)
- 네트워크 연결 타입
- 기기 모델명

### 서버 연동
- 기기 정보 서버 업로드
- 서버에 저장된 기기 목록 조회
- REST API 통신

### 기능 설명
- 개발 환경 정보 표 제공
- 탭 기반 UI (기능설명/주요기능/라이선스)

## ■ 중요: 서버 URL 설정

**이 프로젝트를 사용하기 전에 반드시 서버 URL을 수정해야 합니다!**

현재 코드에 하드코딩된 서버 URL을 사용자 환경에 맞게 수정하세요:

### 수정해야 할 파일들

#### 1. `lib/screens/device_info_page.dart`
```dart
// 148번째 줄 근처
final uri = Uri.parse('http://192.168.100.60:8080/Template-DeviceAPI-Total_Web/dvc/addDeviceInfo.do')
```

#### 2. `lib/screens/device_list_page.dart`
```dart
// 35번째 줄 근처  
final uri = Uri.parse('http://192.168.100.60:8080/Template-DeviceAPI-Total_Web/dvc/deviceInfoList.do')
```

### URL 수정 방법

1. **개발 서버 URL로 변경**:
   ```
   http://localhost:8080 또는 http://127.0.0.1:8080
   ```

2. **실제 서버 URL로 변경**:
   ```
   https://your-domain.com 또는 http://your-server-ip:port
   ```

3. **API 엔드포인트 확인**:
   - 업로드: `/Template-DeviceAPI-Total_Web/dvc/addDeviceInfo.do`
   - 목록조회: `/Template-DeviceAPI-Total_Web/dvc/deviceInfoList.do`

## ■ 설치 및 실행

### 1. 필수 요구사항
- Flutter SDK 3.8.1 이상
- Android Studio 또는 VS Code
- iOS: Xcode (iOS 빌드 시)
- Android: Android SDK

### 2. 프로젝트 설정
```bash
# 프로젝트 클론
git clone <repository-url>
cd hello_world_flutter

# 패키지 설치
flutter pub get

# 서버 URL 수정 (위의 안내 참조)
# lib/screens/device_info_page.dart
# lib/screens/device_list_page.dart
```

### 3. 실행
```bash
# Android
flutter run

# iOS
flutter run -d ios

# 특정 디바이스
flutter devices
flutter run -d <device-id>
```

## ■ 사용된 패키지

```yaml
dependencies:
  device_info_plus: ^10.1.2      # 기기 정보 조회
  connectivity_plus: ^6.0.5      # 네트워크 연결 상태
  permission_handler: ^11.3.1    # 권한 관리
  contacts_service: ^0.6.3       # 연락처 접근
  package_info_plus: ^8.0.2      # 앱 정보
  http: ^1.2.2                   # HTTP 통신
```

## ■ 프로젝트 구조

```
lib/
├── main.dart                          # 메인 앱과 홈 화면
├── models/
│   └── device_info.dart               # 기기 정보 데이터 모델
├── screens/
│   ├── device_info_page.dart          # 기기 정보 화면
│   └── device_list_page.dart          # 기기 목록 화면
└── widgets/
    └── feature_description.dart       # 공통 기능 설명 위젯
```

## ■ 권한 설정

### Android (`android/app/src/main/AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.READ_CONTACTS" />
<uses-permission android:name="android.permission.INTERNET" />
```

### iOS (`ios/Runner/Info.plist`)
```xml
<key>NSContactsUsageDescription</key>
<string>이 앱은 연락처 개수를 확인하기 위해 연락처에 접근합니다.</string>
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

## ■ 사용 방법

1. **앱 실행**: 홈 화면에서 "기기정보보기" 버튼 클릭
2. **기기 정보 확인**: "주요기능" 탭에서 현재 기기 정보 조회
3. **서버 업로드**: 하단 "정보 업로드" 버튼으로 서버에 정보 전송
4. **목록 조회**: 하단 "서버목록조회" 버튼으로 저장된 정보 확인
5. **기능 설명**: "기능설명" 탭에서 개발 환경 정보 확인

## ■ 문제 해결

### 연락처 권한 오류
- Android: 설정 > 앱 > 권한에서 연락처 권한 허용
- iOS: 설정 > 개인정보 보호 > 연락처에서 앱 권한 허용

### 서버 연결 오류
- 서버 URL이 올바른지 확인
- 네트워크 연결 상태 확인
- 서버가 실행 중인지 확인

### 빌드 오류
```bash
# 패키지 재설치
flutter clean
flutter pub get

# iOS 빌드 오류 시
cd ios && pod install && cd ..
```

## ■ 개발 환경

- **Local 디바이스**: Xcode 8.0 (8A218a), Cordova 6.4.0
- **서버**: 전자정부표준프레임워크 개발환경3.6
- **테스트 디바이스**: iPhone 6, iPad Air
- **테스트 플랫폼**: iOS 9.3, iOS 10.0

## ■ 라이선스

이 프로젝트는 MIT 라이선스하에 배포됩니다.

---

**⚠️ 중요 : 프로젝트 사용 전 반드시 서버 URL을 수정하세요!**
