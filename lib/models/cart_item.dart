import 'package:logic_app/models/lunch.dart';

class CartItem{
  final Lunch lunch;
  final String descricao;
  int quantity;
  double finalPrice;

  CartItem(this.lunch, this.descricao, this.quantity, this.finalPrice);

  String showItem(){
    /** 
     * ---------
     * {nome} - {quantidade}
     * {obs}
     * ---------
    */
    return "${lunch.nome} - $quantity\n$descricao\n---------\n";
  }
}