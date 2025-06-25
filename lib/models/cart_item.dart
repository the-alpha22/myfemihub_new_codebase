class CartItemModel {
  static const ID = "id";
  static const IMAGE = "image";
  static const NAME = "name";
  static const QUANTITY = "quantity";
  static const COST = "cost";
  static const SIZE = "size";
  static const PRICE = "price";
  static const PRODUCT_ID = "productId";

  late String id;
  late String image;
  late String name;
  late int quantity;
  late double cost;
  late String productId;
  late String size;
  late double price;

  CartItemModel({
    required this.productId,
    required this.id,
    required this.image,
    required this.name,
    required this.quantity,
    required this.cost,
    required this.size,
  });

  CartItemModel.fromMap(Map<String, dynamic> data) {
    id = data[ID];
    image = data[IMAGE];
    name = data[NAME];
    quantity = data[QUANTITY];
    cost = data[COST].toDouble();

    productId = data[PRODUCT_ID];
    price = data[PRICE].toDouble();
    if (data[SIZE] == null) {
      size = "N/A";
    } else {
      size = data[SIZE];
    }
  }

  Map toJson() => {
    ID: id,
    PRODUCT_ID: productId,
    IMAGE: image,
    NAME: name,
    QUANTITY: quantity,
    COST: price * quantity,
    PRICE: price,
    SIZE: size,
  };
}
