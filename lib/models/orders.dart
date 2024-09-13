class Order {
  final int orderId;
  final String orderDate;
  String orderStatus;
  final double orderTotal;
  final int itemId;
  final String custId;
  final int quantity;

  Order(
      {required this.orderId,
      required this.orderDate,
      required this.orderStatus,
      required this.orderTotal,
      required this.itemId,
      required this.custId,
      required this.quantity});

  @override
  String toString() {
    return 'Order(orderId: $orderId, orderDate: $orderDate, orderStatus: $orderStatus, orderTotal: $orderTotal, itemId: $itemId, custId: $custId, quantity: $quantity)';
  }
}
