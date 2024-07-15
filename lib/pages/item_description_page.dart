import 'package:flutter/material.dart';
import 'package:logic_app/models/cart_item.dart';
import 'package:logic_app/models/lunch.dart';

class DescriptionItemPage extends StatefulWidget {
  const DescriptionItemPage({super.key});

  @override
  State<DescriptionItemPage> createState() => _DescriptionState();
}

class _DescriptionState extends State<DescriptionItemPage>
    with SingleTickerProviderStateMixin {
  final _cartItemForm = GlobalKey<FormState>();
  late AnimationController _animationController;
  var _obs = '';
  int _qtd = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
  }

  void _increaseQtd() {
    _animationController.forward();
    setState(() {
      _qtd++;
    });
  }

  void _decreaseQtd() {
    _animationController.reverse();
    setState(() {
      if (_qtd > 0) {
        _qtd--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // context = ModalRoute.of(context)!.subtreeContext!;
    final lunch = ModalRoute.of(context)?.settings.arguments as Lunch;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            if (mounted) {
              Navigator.pop(context);
              // Navigator.of(context).pushReplacement(
              //     MaterialPageRoute(builder: (context) => const HomePage()));
            }
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card.filled(
              child: Image.asset(
                lunch.urlImage,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 15, left: 5),
              child: Text(
                lunch.nome,
                textAlign: TextAlign.start,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                lunch.descricao,
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 13),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, top: 15),
              child: Text(
                'R\$ ${lunch.preco.toStringAsPrecision(4)}',
                textAlign: TextAlign.start,
                style: const TextStyle(color: Colors.green, fontSize: 13),
              ),
            ),
            Form(
              key: _cartItemForm,
              child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, top: 30),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Alguma observação?',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  maxLines: 5,
                  onChanged: (value) => {
                    setState(() {
                      _obs = value;
                    })
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: FloatingActionButton.small(
                  heroTag: null,
                  onPressed: _decreaseQtd,
                  child: const Icon(Icons.remove),
                ),
              ),
              Text(
                _qtd.toString(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: FloatingActionButton.small(
                  onPressed: _increaseQtd,
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     if (mounted) {
          //       Navigator.pop(context);
          //       // Navigator.of(context).pushReplacement(MaterialPageRoute(
          //       //     builder: (context) => const HomePage()));
          //     }
          //   },
          //   child: const Text('Cancelar'),
          // ),
          ElevatedButton(
            onPressed: () {
              if (mounted && _qtd > 0) {
                double finalPrice = _qtd * lunch.preco;

                CartItem cartItem = CartItem(lunch, _obs, _qtd, finalPrice);
                Navigator.pop(context, cartItem);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Adicione pelo menos um produto!')),
                );
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
