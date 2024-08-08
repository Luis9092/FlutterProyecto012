import 'package:flutter/material.dart';
import 'package:pro_graduacion/widget/button_widget.dart';
import 'package:pro_graduacion/widget/navigation_drawe.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isDrawerOpen = false;
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       
      drawer: const NavigationDrawerWidget(),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            setState(() {
              _isDrawerOpen = !_isDrawerOpen; // Cambia el estado al abrir/cerrar
            });
            if (_isDrawerOpen) {
              Scaffold.of(context).openDrawer(); // Abre el Drawer
            } else {
              Navigator.pop(context); // Cierra el Drawer
            }
          }
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Builder(
              builder: (context) => Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: ButtonWidget(
                  icon: Icons.open_in_new,
                  text: 'Abrir Menu',
                  onClicked: () {
                    Scaffold.of(context).openDrawer();
                    // Scaffold.of(context).openEndDrawer();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class Home extends StatelessWidget {
//   const Home({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: const   NavigationDrawerWidget(),
//       // endDrawer: const NavigationDrawerWidget(),
//       backgroundColor: Theme.of(context).colorScheme.primaryContainer,
//       appBar: AppBar(
//         title: const Text("Home"),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Builder(
//               builder: (context) => Container(
//                 alignment: Alignment.center,
//                 padding: const EdgeInsets.symmetric(horizontal: 32),
//                 child: ButtonWidget(
//                   icon: Icons.open_in_new,
//                   text: 'Abrir Menu',
//                   onClicked: () {
//                     Scaffold.of(context).openDrawer();
//                     // Scaffold.of(context).openEndDrawer();
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
