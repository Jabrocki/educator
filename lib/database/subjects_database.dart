part of 'main_database.dart';

extension SubjectsDatabase on DatabaseService {
  //Subjects
  Future<int> insertSubject({
    required int userId,
    required String subjectName,
    int? imgId,
  }) async {
    return await db.insert(DatabaseConfig.subjectsTableName, {
      DatabaseConfig.subjectsUserIdColumn: userId,
      DatabaseConfig.subjectNameColumn: subjectName,
      DatabaseConfig.subjectImgIdColumn: imgId
    });
  }

  Future<List<SubjectModel>> getSubjects({required int userId}) async {
    //User id collumn
    String subjectsUserIdColumn = DatabaseConfig.subjectsUserIdColumn;

    final data = await db.query(DatabaseConfig.subjectsTableName,
        where: "$subjectsUserIdColumn = ?", whereArgs: [userId]);
    return data.map((e) => SubjectModel.fromMap(e)).toList();
  }

  Future<void> deleteSubject(SubjectModel subject) async {
    //Subjects id collumn
    String subjectsIdColumn = DatabaseConfig.subjectsIdColumn;

    await db.delete(DatabaseConfig.subjectsTableName,
        where: '$subjectsIdColumn = ?', whereArgs: [subject.subjectId]);
    if (subject.imgId != null) {
      ImageModel subjectImg = ImageModel(
          imgId: subject.imgId!, imgFileName: (await subject.imgPath)!);
      await deleteImage(subjectImg);
    }
  }

  Future<void> editSubject(SubjectModel subject) async {

    //Subjects id collumn
    String subjectsIdColumn = DatabaseConfig.subjectsIdColumn;

    db.update(
        DatabaseConfig.subjectsTableName,
        {
          DatabaseConfig.subjectNameColumn: subject.subjectName,
          DatabaseConfig.subjectImgIdColumn: subject.imgId
        },
        where: "$subjectsIdColumn = ?",
        whereArgs: [subject.subjectId]);
  }
}
