import 'dart:convert' show json;

class ChartResult {

int cancelled;
int completed;
int processed;
int timeout;
int total;
ChartResult.fromParams({this.cancelled, this.completed, this.processed, this.timeout, this.total});

factory ChartResult(jsonStr) => jsonStr == null ? null : jsonStr is String ? new ChartResult.fromJson(json.decode(jsonStr)) : new ChartResult.fromJson(jsonStr);

ChartResult.fromJson(jsonRes) {
cancelled = jsonRes['cancelled'];
completed = jsonRes['completed'];
processed = jsonRes['processed'];
timeout = jsonRes['timeout'];
total = jsonRes['total'];
}

@override
String toString() {
return '{"cancelled": $cancelled,"completed": $completed,"processed": $processed,"timeout": $timeout,"total": $total}';
}
}

