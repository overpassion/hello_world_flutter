import 'package:flutter/material.dart';

class FeatureDescription extends StatelessWidget {
  const FeatureDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Device API 기능을 이용하여 모바일 디바이스의 메타 데이터 정보를 조회하고 조회된 정보를 서버에 전송, 조회, 삭제 할 수 있는 기능을 제공합니다.',
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(2),
                },
                border: TableBorder(
                  horizontalInside: BorderSide(color: Colors.grey[300]!),
                  verticalInside: BorderSide(color: Colors.grey[300]!),
                ),
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          '구분',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          '내용',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'Local 디바이스 개발 환경',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'Xcode 8.0 (8A218a), Cordova 6.4.0',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          '서버 사이드 개발 환경',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          '전자정부표준프레임워크 개발환경3.6',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'Mash up Open API 연계',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'N/A',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          '테스트 디바이스',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'iPhone 6, iPad Air',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          '테스트 플랫폼',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'iOS 9.3, iOS 10.0',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          '추가 라이브러리 적용',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          '스토리지 정보 조회를 위한 추가 플러그인 적용',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 