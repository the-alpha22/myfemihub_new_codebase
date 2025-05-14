class CartItemModel {
  static const ID = "id";
  static const IMAGE = "image";
  static const NAME = "name";
  static const QUANTITY = "quantity";
  static const COST = "cost";
  static const SIZE = "size";
  static const COST2 = "cost2";
  static const PRICE = "price";
  static const PRODUCT_ID = "productId";
  static const STORE = "store";
  static const BP = "bp";

  late String id;
  late String image;
  late String name;
  late String store;
  late int quantity;
  late double cost;
  late double cost2;
  late String productId;
  late String size;
  late double price;
  late double bp;

  CartItemModel({
    required this.productId,
    required this.store,
    required this.id,
    required this.image,
    required this.name,
    required this.quantity,
    required this.cost,
    required this.cost2,
    required this.bp,
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
    if (data[BP] == null || data[COST2] == null || data[SIZE] == null) {
      bp = data[PRICE].toDouble() * 0.86;
      cost2 = data[COST].toDouble() - 3000;
      size = "N/A";
    } else {
      bp = data[BP].toDouble();
      cost2 = data[COST2].toDouble();
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
        COST2: bp * quantity,
        PRICE: price,
        BP: bp,
        SIZE: size
      };
}
