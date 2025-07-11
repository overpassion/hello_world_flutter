class DeviceInfo {
  final int sn;
  final String uuid;
  final String os;
  final String ntwrkDeviceInfo;
  final String pgVer;
  final String deviceNm;
  final String useyn;

  DeviceInfo({
    required this.sn,
    required this.uuid,
    required this.os,
    required this.ntwrkDeviceInfo,
    required this.pgVer,
    required this.deviceNm,
    required this.useyn,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      sn: json['sn'] ?? 0,
      uuid: json['uuid'] ?? '',
      os: json['os'] ?? 'Unknown',
      ntwrkDeviceInfo: json['ntwrkDeviceInfo'] ?? 'Unknown',
      pgVer: json['pgVer'] ?? 'Unknown',
      deviceNm: json['deviceNm'] ?? 'Unknown',
      useyn: json['useyn'] ?? 'N',
    );
  }
} 