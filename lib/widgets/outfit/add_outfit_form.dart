import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/wardrobe.dart';

class AddOutfitForm extends StatefulWidget {
  final List<Wardrobe> wardrobeItems;
  final Function(List<Wardrobe>) onCreateOutfit;

  const AddOutfitForm({
    super.key,
    required this.wardrobeItems,
    required this.onCreateOutfit,
  });

  @override
  _AddOutfitFormState createState() => _AddOutfitFormState();
}

class _AddOutfitFormState extends State<AddOutfitForm> {
  List<Wardrobe> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dodaj Stroj',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.wardrobeItems.length,
              itemBuilder: (BuildContext context, int index) {
                final wardrobeItem = widget.wardrobeItems[index];
                final isSelected = selectedItems.contains(wardrobeItem);

                return ListTile(
                  leading: Checkbox(
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value != null && value) {
                          selectedItems.add(wardrobeItem);
                        } else {
                          selectedItems.remove(wardrobeItem);
                        }
                      });
                    },
                  ),
                  title: Text(wardrobeItem.name),
                  subtitle: Text(wardrobeItem.typeClothes),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onCreateOutfit(selectedItems);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple.shade800,
            ),
            child: const Text('Dodaj Stroj'),
          ),
        ],
      ),
    );
  }
}
