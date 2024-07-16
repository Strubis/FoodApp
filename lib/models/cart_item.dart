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
     * {quantidade} - {nome}
     * {obs}
     * ---------
    */
    return "${quantity}x - ${lunch.nome}\n${descricao.isNotEmpty ? "$descricao\n-------🍟-------🍔---------🥤\n" : "-------🍟-------🍔---------🥤\n"}";
  }
}