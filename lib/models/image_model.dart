class ImageModel {
  final String ITEM_SEQ, ITEM_NAME, ITEM_IMAGE;

  ImageModel.fromjson(Map<String, dynamic> json)
    : ITEM_IMAGE = json['ITEM_IMAGE'],
      ITEM_NAME = json['ITEM_NAME'],
      ITEM_SEQ = json['ITEM_SEQ'];
}
