part of 'main_database.dart';

extension UsersDatabase on DatabaseService {
  Future<bool> registerUser(String userName, String userPassword) async {
    //User info
    String userNameColumn = DatabaseConfig.userNameColumn;
    final userListWithSameUserName = await db.query(DatabaseConfig.usersTableName,
        where: '$userNameColumn = ?', whereArgs: [userName]);

    if (userListWithSameUserName.isNotEmpty) {
      return false;
    }

    await db.insert(DatabaseConfig.usersTableName, {
      DatabaseConfig.userNameColumn: userName,
      DatabaseConfig.userPasswordColumn: userPassword,
    });

    return true;
  }

  Future<int> logInUser(String userName, String userPassword) async {
    //User info
    String userNameColumn = DatabaseConfig.userNameColumn;
    String userPasswordColumn = DatabaseConfig.userPasswordColumn;

    final userListWithSameUserName = await db.query(DatabaseConfig.usersTableName,
        where: '$userNameColumn = ? AND $userPasswordColumn = ?',
        whereArgs: [userName, userPassword]);
    if (userListWithSameUserName.isEmpty) {
      return -1;
    }
    return userListWithSameUserName[0][DatabaseConfig.userIdColumn] as int;
  }
}
