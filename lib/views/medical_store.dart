import 'package:flutter/material.dart';

class MedicalStorePage extends StatefulWidget {
  @override
  _MedicalStorePageState createState() => _MedicalStorePageState();
}

class _MedicalStorePageState extends State<MedicalStorePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Medical Store',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Icon(Icons.sort),
                SizedBox(width: 5),
                Text('Sort'),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Homecare Consumable'),
              Tab(text: 'Point of Care Testing'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildProductGrid(),
                buildProductGrid(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProductGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      itemCount: 10, // Dummy data count
      itemBuilder: (context, index) {
        return buildProductCard();
      },
    );
  }

  Widget buildProductCard() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/icons/ilu_therapy.png', // Asset product image
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(Icons.favorite_border),
                  onPressed: () {
                    // Handle favorite action
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text('\$100'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
