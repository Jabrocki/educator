//Models
import '../models/image_model.dart';
import 'package:educator/models/subject_model.dart';

//External packges
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//Internal packages
import 'dart:io';

class DatabaseService {
  //Singleton
  static final DatabaseService instance = DatabaseService._constructor();
  DatabaseService._constructor();

  //Database instance
  static Database? _db;

  //Getter for database
  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  //Databasename
  final String _databaseName = "database.db";

  //Init Sql Commands

  //Subjects
  static const String _subjectsTableName = "subjects";
  static const String _subjectsIdCollumn = "subjectId";
  static const String _subjectsUserIdCollumn = "userId";
  static const String _subjectNameCollumn = "subjectName";
  static const String _subjectImgIdCollumn = "imgId";

  final String _initSubjects = """
  CREATE TABLE $_subjectsTableName (
    $_subjectsIdCollumn INTEGER PRIMARY KEY AUTOINCREMENT,
    $_subjectsUserIdCollumn INTEGER NOT NULL,
    $_subjectNameCollumn TEXT NOT NULL,
    $_subjectImgIdCollumn INTEGER
  )
  """;

  //Images
  static const String _imagesTableName = "images";
  static const String _imagesIdCollumn = "imgId";
  static const String _imagesFilePathCollumn = "imgFilePath";

  final String _initImages = """
  CREATE TABLE $_imagesTableName (
    $_imagesIdCollumn INTEGER PRIMARY KEY AUTOINCREMENT,
    $_imagesFilePathCollumn TEXT NOT NULL
  )
  """;

  //Users
  static const String _usersTableName = "users";
  static const String _userIdCollumn = "userId";
  static const String _userNameCollumn = "userName";
  static const String _userPasswordCollumn = "userPassword";

  final String _initUsers = """
  CREATE TABLE $_usersTableName (
    $_userIdCollumn INTEGER PRIMARY KEY AUTOINCREMENT,
    $_userNameCollumn TEXT NOT NULL,
    $_userPasswordCollumn TEXT NOT NULL
  )
  """;

  //Drops all tables in the database
  Future<void> clearDatabase() async {
    final database = await instance.db;
    await database.execute("DROP TABLE IF EXISTS $_subjectsTableName");
    await database.execute("DROP TABLE IF EXISTS $_imagesTableName");
    await database.execute("DROP TABLE IF EXISTS $_usersTableName");
  }

  //Init database
  Future<Database> initDb() async {
    //Database path
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, _databaseName);

    final database = await openDatabase(
      databasePath,
      version: 25,
      onCreate: (db, version) {
        db.execute(_initSubjects);
        db.execute(_initImages);
        db.execute(_initUsers);
      },
      onUpgrade: (db, oldVersion, newVersion) {
      clearDatabase();
        db.execute(_initSubjects);
        db.execute(_initImages);
        db.execute(_initUsers);
      },
      onDowngrade: (db, oldVersion, newVersion) {
        clearDatabase();
        db.execute(_initSubjects);
        db.execute(_initImages);
        db.execute(_initUsers);
      }
      ,
    );

    return database;
  }

  //Subjects
  Future<int> insertSubject({
    required int userId,
    required String subjectName,
    int? imgId,
  }) async {
    final database = await db;
    final subjectId = await database.insert(_subjectsTableName, {
      _subjectsUserIdCollumn: userId,
      _subjectNameCollumn: subjectName,
      _subjectImgIdCollumn: imgId
    });

    return subjectId;
  }

  Future<List<SubjectModel>> getSubjects({required int userId}) async {
    final database = await db;
    final data = await database.query(_subjectsTableName,
        where: "$_subjectsUserIdCollumn = ?", whereArgs: [userId]);
    return data.map((e) => SubjectModel.fromMap(e)).toList();
  }

  Future<void> deleteSubject(SubjectModel subject) async {
    final database = await db;

    await database.delete(_subjectsTableName,
        where: '$_subjectsIdCollumn = ?', whereArgs: [subject.subjectId]);

    if (subject.imgId != null) {
      ImageModel subjectImg = ImageModel(
          imgId: subject.imgId!, imgFileName: (await subject.imgPath)!);
      await deleteImage(subjectImg);
    }
  }

  Future<void> editSubject(SubjectModel subject) async {
    final database = await db;

    database.update(
        _subjectsTableName,
        {
          _subjectNameCollumn: subject.subjectName,
          _subjectImgIdCollumn: subject.imgId
        },
        where: "$_subjectsIdCollumn = ?",
        whereArgs: [subject.subjectId]);
  }

  //Images
  Future<int> insertImage(String imgFileName) async {
    Database database = await db;
    return await database.insert(_imagesTableName, {
      _imagesFilePathCollumn: imgFileName,
    });
  }

  Future<int> saveAndInsertImage(File imgFile) async {
    //We need to acces application documents directory
    final String path = (await getApplicationDocumentsDirectory()).path;
    final String imgFileName = DateTime.now().toString();
    final String imgFilePath = "$path/$imgFileName.png";

    //Save img File
    await imgFile.copy(imgFilePath);

    //Returns ID of the file
    return insertImage(imgFilePath);
  }

  Future<String> getImagePath(int imgId) async {
    Database database = await db;
    final data = await database.query(_imagesTableName,
        where: '$_imagesIdCollumn = ?', whereArgs: [imgId]);
    return data[0][_imagesFilePathCollumn]! as String;
  }

  Future<void> deleteImage(ImageModel image) async {
    //Delete image from file system
    Database database = await db;

    //Move to file and user input handler

    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    File answerImgFile = File(join(appDocumentsDir.path, image.imgFileName));
    answerImgFile.delete();

    //Delete image from database
    await database
        .delete('images', where: 'imgId = ?', whereArgs: [image.imgId]);
  }

  //Users
  Future<bool> registerUser(String userName, String userPassword) async {
    Database database = await db;
    final userListWithSameUserName = await database.query(_usersTableName,
        where: '$_userNameCollumn = ?', whereArgs: [userName]);

    if (userListWithSameUserName.isNotEmpty) {
      return false;
    }

    await database.insert(_usersTableName, {
      _userNameCollumn: userName,
      _userPasswordCollumn: userPassword,
    });

    return true;
  }

  Future<int> logInUser(String userName, String userPassword) async {
    Database database = await db;

    final userListWithSameUserName = await database.query(_usersTableName,
        where: '$_userNameCollumn = ? AND $_userPasswordCollumn = ?',
        whereArgs: [userName, userPassword]);
    if (userListWithSameUserName.isEmpty) {
      return -1;
    }
    return userListWithSameUserName[0][_userIdCollumn] as int;
  }
}
