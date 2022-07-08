
enum ImageType {
  png,
  jpeg,
  jpg,
  gif,
  svg,
}

final _imageTypes = <ImageType, String?>{
  ImageType.png: 'png',
  ImageType.jpeg: 'jpeg',
  ImageType.jpg: 'jpg',
  ImageType.gif: 'gif',
  ImageType.svg: 'svg',
};

extension ImageExtension on ImageType {

  String get extension =>  _imageTypes[this]!;


}
