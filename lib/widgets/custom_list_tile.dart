import 'package:flutter/material.dart';
import 'package:logic_app/models/cart_item.dart';
import 'package:logic_app/models/lunch.dart';
import 'package:logic_app/pages/item_description_page.dart';

class CustomListTile extends StatelessWidget {
  final List<Lunch> listLunch;
  final List<CartItem> cartList;
  final ValueNotifier cartItemQtd;

  const CustomListTile({
    required this.listLunch,
    required this.cartList,
    required this.cartItemQtd,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: listLunch
          .map(
            (element) => Card(
              child: ListTile(
                // leading: const Icon(Icons.lunch_dining_rounded),
                leading: CircleAvatar(
                  backgroundImage: AssetImage(element.urlImage),
                ),
                title: Text(
                  "${element.nome} - R\$ ${element.preco.toStringAsPrecision(4)}",
                ),
                onTap: () {
                  _navigateToDescription(context, element);
                },
              ),
            ),
          )
          .toList(),
    );
  }

  Future<void> _navigateToDescription(BuildContext context, Lunch lunch) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DescriptionItemPage(),
        fullscreenDialog: true,
        settings: RouteSettings(arguments: lunch),
      ),
    );

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto no carrinho!')),
      );

      final lunch = result as CartItem;
      cartList.add(lunch);
      cartItemQtd.value++;
    }
  }
}
