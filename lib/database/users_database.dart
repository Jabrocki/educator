part of 'main_database.dart';

extension UsersDatabase on DatabaseService {
  Future<bool> registerUser(String userName, String userPassword) async {
    Database database = await db;
    final userListWithSameUserName = await database.query(usersTableName,
        where: '$userNameColumn = ?', whereArgs: [userName]);

    if (userListWithSameUserName.isNotEmpty) {
      return false;
    }

    await database.insert(usersTableName, {
      userNameColumn: userName,
      userPasswordColumn: userPassword,
    });

    return true;
  }

  Future<int> logInUser(String userName, String userPassword) async {
    Database database = await db;

    final userListWithSameUserName = await database.query(usersTableName,
        where: '$userNameColumn = ? AND $userPasswordColumn = ?',
        whereArgs: [userName, userPassword]);
    if (userListWithSameUserName.isEmpty) {
      return -1;
    }
    return userListWithSameUserName[0][userIdColumn] as int;
  }
}
