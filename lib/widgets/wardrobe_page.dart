import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/wardrobe.dart';
import '../services/wardrobe_service.dart';
import '../shared/enums/size_information.dart';
import '../shared/enums/size_information_extension.dart';

class WardrobePage extends StatefulWidget {
  const WardrobePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WardrobePageState createState() => _WardrobePageState();
}

class _WardrobePageState extends State<WardrobePage> {
  late int _currentIndex;
  late WardrobeService _wardrobeService;
  List<Wardrobe> _wardrobes = [];

  @override
  void initState() {
    super.initState();
    _currentIndex = 1;
    _wardrobeService = WardrobeService();
    _fetchClothes();
  }

  Future<void> _fetchClothes() async {
    try {
      final clothes = await _wardrobeService.findClothes();
      setState(() {
        _wardrobes = clothes;
      });
    } catch (error) {
      // Handle error
    }
  }

  Future<void> _addClothes(Wardrobe wardrobe) async {
    try {
      final addedClothes = await _wardrobeService.addClothes(wardrobe);
      setState(() {
        _wardrobes.add(addedClothes);
      });
    } catch (error) {
      // Handle error
    }
  }

  Future<void> _deleteClothes(int? id) async {
    if (id != null) {
      try {
        await _wardrobeService.deleteClothes(id);
        setState(() {
          _wardrobes.removeWhere((wardrobe) => wardrobe.id == id);
        });
      } catch (error) {
        // Handle error
      }
    }
  }

  Future<void> _editClothes(Wardrobe editedWardrobe) async {
    try {
      final updatedClothes =
          await _wardrobeService.updateClothes(editedWardrobe);
      setState(() {
        final index = _wardrobes
            .indexWhere((wardrobe) => wardrobe.id == updatedClothes.id);
        if (index != -1) {
          _wardrobes[index] = updatedClothes;
        }
      });
    } catch (error) {
      // Handle error
    }
  }

  void _handleEdit(Wardrobe wardrobe) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return EditClothesForm(
          wardrobe: wardrobe,
          onEditClothes: _editClothes,
        );
      },
    );
  }

  void _handleTabChange(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _wardrobes.length,
                itemBuilder: (BuildContext context, int index) {
                  final wardrobe = _wardrobes[index];
                  return ListTile(
                    title: Text(wardrobe.name),
                    subtitle: Text(wardrobe.typeClothes),
                    leading: wardrobe.imageUrl.isNotEmpty
                        ? Image.network(wardrobe.imageUrl)
                        : const Icon(Icons.checkroom),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _handleEdit(wardrobe);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _deleteClothes(wardrobe.id);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  backgroundColor: Colors.deepPurple.shade800,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return AddClothesForm(
                          onAddClothes: _addClothes,
                        );
                      },
                    );
                  },
                  child: const Icon(
                    Icons.add,
                    size: 32.0,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

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
                backgroundColor: Colors.deepPurple.shade800,
              ),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditClothesForm extends StatefulWidget {
  final Wardrobe wardrobe;
  final Function(Wardrobe) onEditClothes;

  const EditClothesForm({
    required this.wardrobe,
    required this.onEditClothes,
  });

  @override
  _EditClothesFormState createState() => _EditClothesFormState();
}

class _EditClothesFormState extends State<EditClothesForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _imageUrlController = TextEditingController();
  SizeInformation _selectedSize = SizeInformation.XL;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.wardrobe.name;
    _typeController.text = widget.wardrobe.typeClothes;
    _imageUrlController.text = widget.wardrobe.imageUrl;
    _selectedSize = SizeInformationExtension.fromString(widget.wardrobe.size);
  }

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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit Clothes',
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
                  final editedClothes = Wardrobe(
                    id: widget.wardrobe.id,
                    name: _nameController.text,
                    typeClothes: _typeController.text,
                    imageUrl: _imageUrlController.text,
                    size: _selectedSize.toString(),
                  );
                  widget.onEditClothes(editedClothes);
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple.shade800,
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
