class RecommendList {
  int result;

  RecommendList.fromJson(Map<String, dynamic> map)
      : result = map['result'];
}
