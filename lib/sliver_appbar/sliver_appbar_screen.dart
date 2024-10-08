import 'package:flutter/material.dart';

class SliverAppbarScreen extends StatelessWidget {
  const SliverAppbarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange[100],
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            expandedHeight: 350,
            centerTitle: true,
            pinned: true,
            stretch: true,
            floating: true,
            backgroundColor: Colors.blue,
            // title: Text("Sliver App Bar"),
              
            // leading: Icon(Icons.menu),
            // bottom: PreferredSize(
            //   preferredSize: Size.fromHeight(0),
            //   child: Text("Sliver App Bar"),
            // ),

            flexibleSpace:
              FlexibleSpaceBar(
                centerTitle: true,
                title: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.person),
                    Text("Sliver App Bar"),
                    Icon(Icons.filter_list_rounded),
                
                  ],
                ),
              ),

          ),
          SliverList(
              delegate: SliverChildListDelegate(List.generate(50, (index) {
            return Container(
                margin: const EdgeInsets.all(15),
                alignment: Alignment.center,
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: Text((index + 1).toString()));
          }))),
        ],
      ),
    );
  }
}
