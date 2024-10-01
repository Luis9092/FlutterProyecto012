import 'package:flutter/material.dart';
import 'package:pro_graduacion/Components/colors.dart';
import 'package:pro_graduacion/widget/navigation_drawe.dart';

class Resultados extends StatefulWidget {
  const Resultados({super.key});

  @override
  State<Resultados> createState() => _ResultadosState();
}

class _ResultadosState extends State<Resultados> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resultados"),
        backgroundColor: ccolor2,
        centerTitle: true,
      ),
      drawer: const NavigationDrawerWidget(),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).colorScheme.background,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              const SizedBox(
                height: 1,
              ),
              GridImage(),
            ],
          ),
        ),
      ),
    );
  }
}

class GridImage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GridImageState();
  }
}

class GridImageState extends State<GridImage> {
   final List<Map<String, dynamic>> gridMap = [
  
    {"tittle": "tea", "price": "10", "image": "assets/images/arb.png"},
    {"tittle": "tea", "price": "10", "image": "assets/images/arb.png"},
    {"tittle": "tea", "price": "10", "image": "assets/images/arb.png"},
    {"tittle": "tea", "price": "10", "image": "assets/images/arb.png"},
    {"tittle": "tea", "price": "10", "image": "assets/images/arb.png"},
    {"tittle": "tea", "price": "10", "image": "assets/images/arb.png"},
    {"tittle": "tea", "price": "10", "image": "assets/images/arb.png"},
    {"tittle": "tea", "price": "10", "image": "assets/images/arb.png"}
  ];

  

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          '${gridMap.length} archivos',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
        ),
        Row(
          children: [
            Checkbox(
              value: true,
              onChanged: (value) {},
              activeColor: ccolor2,
            ),
            const Icon(
              Icons.more_vert,
              color: ccolor2,
            )
          ],
        ),
      ]),
      GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: gridMap.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          mainAxisExtent: 200,
        ),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image(
                image: AssetImage(
                  "${gridMap.elementAt(index)['image']}",
                ),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      )
    ]);
  }
}
