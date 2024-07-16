import 'package:flutter/material.dart';
import 'package:logic_app/controllers/user_controller.dart';
import 'package:logic_app/models/cart_item.dart';
import 'package:url_launcher/url_launcher.dart';

class CartPage extends StatefulWidget {
  final List<CartItem> cartList;
  final ValueNotifier<int> cartQtd;

  const CartPage({super.key, required this.cartList, required this.cartQtd});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final qtdByItem = ValueNotifier<int>(0);
  var totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _sumTotal();
  }

  void _sumTotal() {
    totalPrice = 0.0;

    setState(() {
      widget.cartList.forEach((element) {
        totalPrice += element.finalPrice;
      });
    });
  }

  String _buildText(List<CartItem> items) {
    String text = "Meu pedido no Sofhi's Burguer 😋🧑‍🍳:\n\n-------🍟-------🍔---------🥤\n";

    items.forEach((item) {
      text += item.showItem();
    });

    text += "\nTotal para pagar: R\$ ${totalPrice.toStringAsFixed(2)}\n\nObrigado pela preferência 🫶! \n";
    text += "Volte sempre Sr(a) ${UserController.user?.displayName} 🤝❤!\n\nClique para enviar o pedido para confirmar... ➤";
    return text;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meu carrinho',
          textAlign: TextAlign.center,
        ),
        leading: IconButton(
          onPressed: () async {
            if (mounted) {
              Navigator.pop(context);
            }
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        children: widget.cartList.isNotEmpty
            ? widget.cartList
                .map(
                  (element) => Card(
                    child: ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(element.lunch.urlImage),
                        ),
                        subtitle: Text(
                          element.lunch.descricao,
                          style: const TextStyle(fontSize: 10),
                        ),
                        title: Text(
                          "${element.lunch.nome} - R\$ ${element.finalPrice.toStringAsFixed(2)}",
                        ),
                        trailing: SizedBox(
                          width: 130,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (element.quantity == 1) {
                                    setState(() {
                                      widget.cartList.remove(element);
                                      widget.cartQtd.value--;
                                      _sumTotal();
                                    });
                                  } else {
                                    setState(() {
                                      element.quantity--;
                                      element.finalPrice = element.quantity *
                                          element.lunch.preco;
                                      _sumTotal();
                                    });
                                  }
                                },
                                icon: element.quantity == 1
                                    ? const Icon(Icons.delete)
                                    : const Icon(Icons.remove),
                                style: const ButtonStyle(
                                    iconColor:
                                        MaterialStatePropertyAll(Colors.red)),
                              ),
                              Text(element.quantity.toString()),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    element.quantity++;
                                    element.finalPrice =
                                        element.quantity * element.lunch.preco;
                                    _sumTotal();
                                  });
                                },
                                icon: const Icon(Icons.add),
                                style: const ButtonStyle(
                                    iconColor:
                                        MaterialStatePropertyAll(Colors.red)),
                              ),
                            ],
                          ),
                        )),
                  ),
                )
                .toList()
            : [
                const Center(
                  child: Text(
                    'Seu carrinho está vazio',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                ),
                const Icon(Icons.remove_shopping_cart),
              ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          widget.cartList.isNotEmpty
              ? Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.deepOrange,
                        width: 0.4,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(
                          'Total: R\$ ${totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          var phone = '+5516988720562';
                          String text = _buildText(widget.cartList);

                          // Uri uri = Uri.parse('https://whatsapp://send?phone=$phone&text=hello');
                          final url = Uri.parse(
                              Uri.encodeFull('https://wa.me/$phone?text=$text'));

                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('Erro ao enviar pedido!'),
                            ));
                          }
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.mobile_screen_share),
                            Text('Enviar Pedido')
                          ],
                        ),
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(10),
                            side: const MaterialStatePropertyAll(
                              BorderSide(style: BorderStyle.solid),
                            ),
                            backgroundColor: const MaterialStatePropertyAll(
                                Color.fromARGB(255, 255, 244, 227))),
                      ),
                    ],
                  ),
                )
              : const Text(''),
        ],
      ),
    );
  }
}
