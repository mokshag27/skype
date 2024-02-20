class Log {
  final String? callerName;
  final String? callerPic;
  final String? callStatus;
  final String? receiverName;
  final String? receiverPic;
  final String? timestamp;
  final String? logId;

  Log({
    this.callerName,
    this.callerPic,
    this.callStatus,
    this.receiverName,
    this.receiverPic,
    this.timestamp,
    this.logId,
  });

  Map<String, dynamic> toMap() {
    return {
      'callerName': callerName,
      'callerPic': callerPic,
      'callStatus': callStatus,
      'receiverName': receiverName,
      'receiverPic': receiverPic,
      'timestamp': timestamp,
      'logId': logId,
    };
  }
}