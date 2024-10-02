class Orders {
  final int orderId;
  final String orderDate;
  String orderPhone;
  String orderStatus;
  final double orderTotal;
  final String itemId;
  final String custId;
  final int quantity;
  final String paymentStatus;

  Orders({
    required this.orderId,
    required this.orderDate,
    required this.orderPhone,
    required this.orderStatus,
    required this.orderTotal,
    required this.itemId,
    required this.custId,
    required this.quantity,
    required this.paymentStatus,
  });

  @override
  String toString() {
    return 'Order(orderId: $orderId, orderDate: $orderDate, orderStatus: $orderStatus, orderTotal: $orderTotal, itemId: $itemId, custId: $custId, quantity: $quantity)';
  }
}
