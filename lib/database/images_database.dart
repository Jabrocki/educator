part of 'main_database.dart';

extension ImagesDatabase on DatabaseService {
  //Images
  Future<int> insertImage(String imgFileName) async {
    return await db.insert(DatabaseConfig.imagesTableName, {
      DatabaseConfig.imagesFilePathColumn: imgFileName,
    });
  }

  Future<int> saveAndInsertImage(File imgFile) async {

    final String path = configDb.imageFileFolder;

    final String imgFileName = DateTime.now().toString();
    final String imgFilePath = "$path/$imgFileName.png";

    await imgFile.copy(imgFilePath);
    return insertImage(imgFilePath);
  }

  Future<String> getImagePath(int imgId) async {
    //Images id
    String imagesIdColumn = DatabaseConfig.imagesIdColumn;
    final data = await db.query(DatabaseConfig.imagesTableName,
        where: '$imagesIdColumn = ?', whereArgs: [imgId]);
    return data[0][DatabaseConfig.imagesFilePathColumn]! as String;
  }

  Future<void> deleteImage(ImageModel image) async {
    File answerImgFile = File(image.imgFileName);
    answerImgFile.delete();
    //Image id
    String imagesIdColumn = DatabaseConfig.imagesIdColumn;
    await db
        .delete(DatabaseConfig.decksTableName, where: '$imagesIdColumn = ?', whereArgs: [image.imgId]);
  }
}
