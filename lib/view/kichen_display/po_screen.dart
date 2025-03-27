import 'package:flutter/material.dart';
import 'package:get/get.dart';

  class ItemListScreen extends StatelessWidget {

  final List<Map<String, dynamic>> 

  items = [


    {'name': 'cake', 'poQty': 10, 'recQty': 5},
    {'name': 'milk', 'poQty': 20, 'recQty': 0},
    {'name': 'pizza', 'poQty': 15, 'recQty': 10},
    {'name': 'Burger', 'poQty': 18, 'recQty': 16},
  

   ];
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios)),
          title: Text('Purchase List')),
          body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      //title: Text(item['name']),
                      title: Text('Item : ${item['name']}'),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('PO Qty: ${item['poQty']}'),
                          
                          Text('Rec Qty: ${item['recQty']}'),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () => Get.to(() => ItemDetailScreen(item: item)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemDetailScreen extends StatelessWidget {
  final Map<String, dynamic> item;
  ItemDetailScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios)),
        title: Text(item['name'])),
        body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Item: ${item['name']}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Qty',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Get.back(),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




