

class Bundle {
  Map<String, dynamic> _map = {};

  _setValue(var k, var v) => _map[k] = v;

  _getValue(String k) {
    if (!_map.containsKey(k)) {
      throw Exception("你使用的$k\在payload不存在,请检查你的key名字是否正确,或者确定key是否存在payload");
    }
    return _map[k];
  }


  putString(String k, String v) => _setValue(k, v);

  putBool(String k, bool v) => _setValue(k, v);

  putList<V>(String k, List<V> v) => _setValue(k, v);

  putMap<K, V>(String k, Map<K, V> v) => _setValue(k, v);

  int getInt(String k) => _getValue(k) as int;

  String getString(String k) => _getValue(k) as String;

  bool getBool(String k) => _getValue(k) as bool;

  Map getMap(String k) => _getValue(k) as Map;

  @override
  String toString() {
    return _map.toString();
  }
}

