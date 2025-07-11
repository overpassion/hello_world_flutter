import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:math';

import '../widgets/feature_description.dart';
import '../models/device_info.dart';
import 'device_list_page.dart';

class DeviceInfoPage extends StatefulWidget {
  const DeviceInfoPage({super.key});

  @override
  State<DeviceInfoPage> createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends State<DeviceInfoPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic> deviceInfo = {};
  String connectionType = 'Unknown';
  String flutterVersion = 'Unknown';
  int contactsCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _getDeviceInfo();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _getDeviceInfo() async {
    try {
      DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        deviceInfo = {
          'OS': 'Android ${androidInfo.version.release}',
          'UUID': androidInfo.id,
          'Model': androidInfo.model,
          'Brand': androidInfo.brand,
          'Device': androidInfo.device,
        };
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        deviceInfo = {
          'OS': 'iOS ${iosInfo.systemVersion}',
          'UUID': iosInfo.identifierForVendor ?? 'Unknown',
          'Model': iosInfo.model,
          'Name': iosInfo.name,
          'SystemName': iosInfo.systemName,
        };
      }
      
      // Get package info (Flutter app version)
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      flutterVersion = '${packageInfo.version}+${packageInfo.buildNumber}';
      
      // Get connectivity info
      final List<ConnectivityResult> connectivityResult = 
          await (Connectivity().checkConnectivity());
      
      if (connectivityResult.contains(ConnectivityResult.wifi)) {
        connectionType = 'WiFi connection';
      } else if (connectivityResult.contains(ConnectivityResult.mobile)) {
        connectionType = 'Mobile connection';
      } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
        connectionType = 'Ethernet connection';
      } else {
        connectionType = 'No connection';
      }
      
      // Get contacts count
      await _getContactsCount();
      
    } catch (e) {
      print('Error getting device info: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _getContactsCount() async {
    try {
      PermissionStatus permission = await Permission.contacts.status;
      if (permission != PermissionStatus.granted) {
        permission = await Permission.contacts.request();
      }
      
      if (permission == PermissionStatus.granted) {
        Iterable<Contact> contacts = await ContactsService.getContacts();
        contactsCount = contacts.length;
      }
    } catch (e) {
      print('Error getting contacts: $e');
      contactsCount = 0;
    }
  }

  Future<void> _uploadDeviceInfo() async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("정보 업로드 중..."),
              ],
            ),
          );
        },
      );

      // Generate random serial number
      final random = Random();
      final sn = random.nextInt(999) + 1;
      
      // Prepare network info
      String networkInfo = connectionType;
      if (connectionType == 'WiFi connection') {
        networkInfo = 'WiFi,5G';
      } else if (connectionType == 'Mobile connection') {
        networkInfo = 'Mobile,4G';
      }

      // API URL with query parameters
      final uri = Uri.parse('http://192.168.100.60:8080/Template-DeviceAPI-Total_Web/dvc/addDeviceInfo.do').replace(
        queryParameters: {
          'sn': sn.toString(),
          'uuid': deviceInfo['UUID'] ?? 'Unknown',
          'os': deviceInfo['OS'] ?? 'Unknown',
          'strgInfo': 'total:128GB, free:64GB', // Default storage info
          'ntwrkDeviceInfo': networkInfo,
          'pgVer': flutterVersion,
          'deviceNm': deviceInfo['Model'] ?? 'Unknown',
          'useYn': 'Y',
        },
      );

      print('API Request URL: $uri');

      // Make HTTP GET request
      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      
      // Close loading dialog
      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        // Parse JSON response
        final jsonResponse = json.decode(response.body);
        final resultState = jsonResponse['resultState'];
        
        if (resultState == 'OK') {
          _showSuccessDialog('정보 업로드가 성공적으로 완료되었습니다.');
        } else {
          _showErrorDialog('서버에서 오류가 발생했습니다.\n상태: $resultState');
        }
      } else {
        _showErrorDialog('서버 연결 실패\n상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      // Close loading dialog if it's still open
      Navigator.of(context).pop();
      _showErrorDialog('오류가 발생했습니다:\n$e');
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('성공'),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 8),
              Text('오류'),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToServerList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeviceListPage(uuid: deviceInfo['UUID'] ?? ''),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.cyan[600],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'DeviceInfo API',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: '기능설명'),
            Tab(text: '주요기능'),
            Tab(text: '라이선스'),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.black,
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Device API 기능을 이용하여 모바일 디바이스의 메타 데이터 정보를 조회하고 조회된 정보를 서버에 전송, 조회, 삭제 할 수 있는 기능을 제공합니다.',
              style: TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 기능설명 탭
                const FeatureDescription(),
                // 주요기능 탭
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildInfoRow('OS', deviceInfo['OS'] ?? 'Unknown'),
                            _buildInfoRow('UUID', deviceInfo['UUID'] ?? 'Unknown'),
                            _buildInfoRow('Flutter Version', flutterVersion),
                            _buildInfoRow('Contacts', '총 ${contactsCount}개의 연락처'),
                            _buildInfoRow('Connection Type', connectionType),
                            _buildInfoRow('Device Model', deviceInfo['Model'] ?? 'Unknown'),
                          ],
                        ),
                      ),
                // 라이선스 탭
                const Center(
                  child: Text(
                    '라이선스 정보',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.grey[800],
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _navigateToServerList,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: const Column(
                        children: [
                          Icon(Icons.apps, color: Colors.white),
                          SizedBox(height: 4),
                          Text('서버목록조회', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: _uploadDeviceInfo,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: const Column(
                        children: [
                          Icon(Icons.settings, color: Colors.white),
                          SizedBox(height: 4),
                          Text('정보 업로드', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
} 