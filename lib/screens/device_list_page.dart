import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/feature_description.dart';
import '../models/device_info.dart';

class DeviceListPage extends StatefulWidget {
  final String uuid;
  
  const DeviceListPage({super.key, required this.uuid});

  @override
  State<DeviceListPage> createState() => _DeviceListPageState();
}

class _DeviceListPageState extends State<DeviceListPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<DeviceInfo> deviceList = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _fetchDeviceList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchDeviceList() async {
    try {
      final uri = Uri.parse('http://192.168.100.60:8080/Template-DeviceAPI-Total_Web/dvc/deviceInfoList.do').replace(
        queryParameters: {'uuid': widget.uuid},
      );

      print('Fetching device list from: $uri');

      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        
        if (jsonResponse['resultState'] == 'OK') {
          final List<dynamic> deviceInfoList = jsonResponse['deviceInfoList'] ?? [];
          
          setState(() {
            deviceList = deviceInfoList.map((item) => DeviceInfo.fromJson(item)).toList();
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = '서버에서 오류가 발생했습니다.';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = '서버 연결 실패 (상태 코드: ${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = '오류가 발생했습니다: $e';
        isLoading = false;
      });
    }
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
          onTap: (index) {
            if (index == 1) {
              // "주요기능" 탭 선택 시 처음 화면으로 돌아가기
              Navigator.pop(context);
            } else {
              // 다른 탭은 정상적으로 표시
              _tabController.animateTo(index);
            }
          },
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
              '서버에 저장된 모바일 디바이스의 메타 데이터 정보들의 리스트를 조회 합니다.',
              style: TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 기능설명 탭
                const FeatureDescription(),
                // 주요기능 탭
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage.isNotEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error, size: 64, color: Colors.red),
                                const SizedBox(height: 16),
                                Text(
                                  errorMessage,
                                  style: const TextStyle(fontSize: 16, color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isLoading = true;
                                      errorMessage = '';
                                    });
                                    _fetchDeviceList();
                                  },
                                  child: const Text('다시 시도'),
                                ),
                              ],
                            ),
                          )
                        : deviceList.isEmpty
                            ? const Center(
                                child: Text(
                                  '저장된 기기 정보가 없습니다.',
                                  style: TextStyle(fontSize: 16, color: Colors.grey),
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: _fetchDeviceList,
                                child: ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: deviceList.length,
                                  itemBuilder: (context, index) {
                                    final device = deviceList[index];
                                    return _buildDeviceCard(device);
                                  },
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
        ],
      ),
    );
  }

  Widget _buildDeviceCard(DeviceInfo device) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'UUID : ${device.uuid.length > 25 ? '${device.uuid.substring(0, 25)}...' : device.uuid}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Network Connection Type : ${device.ntwrkDeviceInfo}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'OS : ${device.os}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
            size: 16,
          ),
        ],
      ),
    );
  }
} 