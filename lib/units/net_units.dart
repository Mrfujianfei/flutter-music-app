import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class NetUnits {
  //创建一个单例
  static NetUnits _instance;

  static NetUnits getInstance() {
    if (_instance == null) {
      _instance = NetUnits();
    }
    return _instance;
  }

  Dio dio = new Dio();

  NetUnits() {
    // 默认配置
    dio.options.headers = {
      // 'accept-language': 'zh-cn',
      // 'content-type': 'application/json',
    };
    dio.options.baseUrl = "http://192.168.18.186:3300/";
    // dio.options.connectTimeout = 30000;
    // cookie管理
    var cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));
    // 请求拦截
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options) async {
          // 在请求被发送之前做一些事情
          return options; //continue
          // 如果你想完成请求并返回一些自定义数据，可以返回一个`Response`对象或返回`dio.resolve(data)`。
          // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义数据data.
          //
          // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象，或返回`dio.reject(errMsg)`，
          // 这样请求将被中止并触发异常，上层catchError会被调用。
        },
        onResponse: (Response response) async {
          // 在返回响应数据之前做一些预处理
          return response; // continue
        },
        onError: (DioError e) async {
          // 当请求失败时做一些预处理
          return e; //continue
        },
      ),
    );
  }

  //get请求
  get(String url,Map<String, dynamic> params) async {
    Response response = await dio.get(url,queryParameters: params);
    return response;
  }

   //post请求
  post(String url,Map<String, dynamic> params) async {
     Response response = await dio.post(url,data: params);
     return response;
  }
}
