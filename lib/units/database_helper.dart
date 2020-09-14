
import 'package:musicapp/model/song.dart';
import 'package:musicapp/units/common_fun.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class DatabaseHelper{

  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper.internal();

  final String tableSong = 'TableSong';

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  // 初始化_db
  initDb() async{
    Directory fileDirectory = await getApplicationDocumentsDirectory();
    String path = join(fileDirectory.path,"maindb3.db");
    var maindb = await openDatabase(path,version: 1,onCreate: _onCreate);
    return maindb;
  }

  // 创建表
  _onCreate(Database db, int newVersion) async{
    await db.execute(
        'CREATE TABLE $tableSong(id TEXT PRIMARY KEY, songmid TEXT, albummid TEXT,songname TEXT,singerName TEXT,picUrl TEXT,playUrl TEXT, addTime INTEGER, duration TEXT,albumname TEXT, disabled TEXT)');
  }

  // 新增歌曲
  Future<int> insertSong(Song song) async {
    var dbClient = await db;
    // songs.forEach((song) async{
    //   print('++++');
    // });
    var a = await dbClient.insert("$tableSong", song.toJson());
  }

  // 获取歌曲列表
  Future<List<Song>> selectSongs({int limit, int offset}) async {
    var dbClient = await db;
    var result = await dbClient.query(
      tableSong,
      columns: ['id', 'songmid', 'albummid', 'songname', 'singerName', 'playUrl','addTime','duration','albumname','disabled'],
      limit: limit,
      offset: offset,
    );
    List<Song> songs = [];
    print(result);
    result.forEach((item) => songs.add(Song.fromJson(item)));
    return songs;
  }

  // 获取数据条数
  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM $tableSong'));
  }

  // 关闭数据库
  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }

}