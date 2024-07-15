import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_tabbar/dynamic_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:logic_app/models/cart_item.dart';
import 'package:logic_app/models/lunch.dart';
import 'package:logic_app/pages/cart_page.dart';
import 'package:logic_app/pages/login_page.dart';
import 'package:logic_app/widgets/custom_list_tile.dart';
import 'package:badges/badges.dart' as badges;

import '../controllers/user_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  static List<String> list = List.empty(growable: true);
  FirebaseFirestore db = FirebaseFirestore.instance;
  final List<CartItem> _cartList = [];
  final cartItemQtd = ValueNotifier<int>(0);

  List<TabData> tabs = [
    TabData(
      index: 1,
      title: const Tab(
        child: Text('Carregando menu...'),
      ),
      content: const Center(child: Text('Carregando cardápio...')),
    ),
  ];

  Future<void> _buildMenus() async {
    final menus = await db.collection('menus').get();
    tabs.removeLast();

    for (var i = 0; i < menus.size; i++) {
      final List<Lunch> lunchList = List.empty(growable: true);
      final data = menus.docs.elementAt(i).data();
      list.add(data['nome']);

      if (data.isNotEmpty) {
        final menuByData = await db.collection('/menus/$i/lanches').get();
        if (menuByData.docs.isNotEmpty) {
          menuByData.docs.forEach((ln) {
            Lunch lunch = Lunch(
              ln['nome'],
              ln['descricao'],
              ln['url_image'],
              ln['preco'],
            );
            lunchList.add(lunch);
          });
        }
      }

      final newTab = TabData(
        index: tabs.length + 1,
        title: Tab(
          child: Text("${data['nome']}"),
        ),
        content: CustomListTile(
          listLunch: lunchList,
          cartList: _cartList,
          cartItemQtd: cartItemQtd,
        ),
      );
      tabs.add(newTab);
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this);

    _buildMenus().whenComplete(() {
      setState(() {
        _tabController = TabController(length: 0, vsync: this);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 0,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () async {
              await UserController.signOut();

              if (mounted) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ));
              }
            },
            icon: const Icon(Icons.logout_sharp),
          ),
          actions: [
            badges.Badge(
              badgeContent: ValueListenableBuilder(
                valueListenable: cartItemQtd,
                builder: (context, value, widget) {
                  print('list: ${_cartList.length}');
                  return Text(
                    _cartList.length.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  );
                },
              ),
              position: badges.BadgePosition.custom(start: 30, bottom: 30),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartPage(cartList: _cartList, cartQtd: cartItemQtd,),
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_cart),
              ),
            ),
            CircleAvatar(
              foregroundImage:
                  NetworkImage(UserController.user?.photoURL ?? ''),
            )
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: DynamicTabBarWidget(
                tabAlignment: TabAlignment.start,
                dynamicTabs: tabs,
                isScrollable: true,
                onTabControllerUpdated: (controller) {},
                onTabChanged: (index) {},
                onAddTabMoveTo: MoveToTab.idol,
                showBackIcon: true,
                showNextIcon: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
