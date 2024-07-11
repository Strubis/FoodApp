import 'package:logic_app/models/lunch.dart';

class CartItem{
  final Lunch lunch;
  final String descricao;
  final int quantity;

  const CartItem(this.lunch, this.descricao, this.quantity);
}