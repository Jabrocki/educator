part of 'main_database.dart';

extension ImagesDatabase on DatabaseService {
  //Images
  Future<int> insertImage(String imgFileName) async {
    Database database = await db;
    return await database.insert(imagesTableName, {
      imagesFilePathColumn: imgFileName,
    });
  }

  Future<int> saveAndInsertImage(File imgFile) async {
    final String path = (await getApplicationDocumentsDirectory()).path;
    final String imgFileName = DateTime.now().toString();
    final String imgFilePath = "$path/$imgFileName.png";

    await imgFile.copy(imgFilePath);
    return insertImage(imgFilePath);
  }

  Future<String> getImagePath(int imgId) async {
    Database database = await db;
    final data = await database.query(imagesTableName,
        where: '$imagesIdColumn = ?', whereArgs: [imgId]);
    return data[0][imagesFilePathColumn]! as String;
  }

  Future<void> deleteImage(ImageModel image) async {
    Database database = await db;
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    File answerImgFile = File(join(appDocumentsDir.path, image.imgFileName));
    answerImgFile.delete();
    await database
        .delete(imagesTableName, where: 'imgId = ?', whereArgs: [image.imgId]);
  }
}
