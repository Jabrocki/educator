part of 'main_database.dart';

extension SubjectsDatabase on DatabaseService {
  //Subjects
  Future<int> insertSubject({
    required int userId,
    required String subjectName,
    int? imgId,
  }) async {
    final database = await db;
    return await database.insert(subjectsTableName, {
      subjectsUserIdColumn: userId,
      subjectNameColumn: subjectName,
      subjectImgIdColumn: imgId
    });
  }

  Future<List<SubjectModel>> getSubjects({required int userId}) async {
    final database = await db;
    final data = await database.query(subjectsTableName,
        where: "$subjectsUserIdColumn = ?", whereArgs: [userId]);
    return data.map((e) => SubjectModel.fromMap(e)).toList();
  }

  Future<void> deleteSubject(SubjectModel subject) async {
    final database = await db;
    await database.delete(subjectsTableName,
        where: '$subjectsIdColumn = ?', whereArgs: [subject.subjectId]);
    if (subject.imgId != null) {
      ImageModel subjectImg = ImageModel(
          imgId: subject.imgId!, imgFileName: (await subject.imgPath)!);
      await deleteImage(subjectImg);
    }
  }

  Future<void> editSubject(SubjectModel subject) async {
    final database = await db;
    database.update(
        subjectsTableName,
        {
          subjectNameColumn: subject.subjectName,
          subjectImgIdColumn: subject.imgId
        },
        where: "$subjectsIdColumn = ?",
        whereArgs: [subject.subjectId]);
  }
}
