import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/wardrobe.dart';
import '../../shared/enums/size_information.dart';

class AddClothesForm extends StatefulWidget {
  final Function(Wardrobe) onAddClothes;

  const AddClothesForm({required this.onAddClothes});

  @override
  _AddClothesFormState createState() => _AddClothesFormState();
}

class _AddClothesFormState extends State<AddClothesForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _imageUrlController = TextEditingController();
  SizeInformation _selectedSize = SizeInformation.XL; // Default selected size

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFFEEF5DB),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Clothes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _typeController,
              decoration: const InputDecoration(labelText: 'Type of Clothes'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the type of clothes';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'Image URL'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the image URL';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ToggleButtons(
              isSelected: List.generate(SizeInformation.values.length, (index) {
                return SizeInformation.values[index] == _selectedSize;
              }),
              onPressed: (int index) {
                setState(() {
                  _selectedSize = SizeInformation.values[index];
                });
              },
              children: SizeInformation.values
                  .map((size) => Text(size.toString().split('.').last))
                  .toList(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newClothes = Wardrobe(
                    name: _nameController.text,
                    typeClothes: _typeController.text,
                    imageUrl: _imageUrlController.text,
                    size: _selectedSize.toString(),
                  );
                  widget.onAddClothes(newClothes);
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F6367),
              ),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
