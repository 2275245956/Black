import 'dart:convert' show json;

class PageDto {
  int sort;
  int number;
  int numberOfElements;
  int size;
  int totalElements;
  int totalPages;
  bool first;
  bool last;
  List<dynamic> content;
  String message;

  PageDto.fromParams(
      {this.sort,
      this.number,
      this.numberOfElements,
      this.size,
      this.totalElements,
      this.totalPages,
      this.first,
      this.last,
      this.content,
      this.message});

  factory PageDto(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new PageDto.fromJson(json.decode(jsonStr))
          : new PageDto.fromJson(jsonStr);

  PageDto.fromJson(jsonRes) {
    sort = jsonRes['sort'];
    number = jsonRes['number'];
    numberOfElements = jsonRes['numberOfElements'];
    size = jsonRes['size'];
    totalElements = jsonRes['totalElements'];
    totalPages = jsonRes['totalPages'];
    first = jsonRes['first'];
    last = jsonRes['last'];
    content = jsonRes['content'] == null ? null : [];
    message = jsonRes['message'];

    for (var contentItem in content == null ? [] : jsonRes['content']) {
      content.add(contentItem);
    }
  }

  PageDto.offlinefromJson() {
    sort = 1; //jsonRes['sort'];
    number = 1; //jsonRes['number'];
    numberOfElements = 1; //jsonRes['numberOfElements'];
    size = 10000; //jsonRes['size'];
    totalElements = 1; //jsonRes['totalElements'];
    totalPages = 1; //jsonRes['totalPages'];
    first = true; //jsonRes['first'];
    last = true; //jsonRes['last'];
    content = [];
  }

  @override
  String toString() {
    return '{"sort": $sort,"number": $number,"numberOfElements": $numberOfElements,"size": $size,"totalElements": $totalElements,"totalPages": $totalPages,"first": $first,"last": $last,"content": $content}';
  }
}
