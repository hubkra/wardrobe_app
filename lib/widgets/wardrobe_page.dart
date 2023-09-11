import 'package:flutter/material.dart';
import 'package:wardrobe_app/models/outfit.dart';

import '../models/wardrobe.dart';
import '../services/outfit_service.dart';
import '../services/wardrobe_service.dart';
import 'clothes/add_clothes_form.dart';
import 'clothes/edit_clothes_form.dart';
import 'outfit/add_outfit_form.dart';
import 'outfit/edit_outfit_form.dart';

class WardrobePage extends StatefulWidget {
  const WardrobePage({Key? key}) : super(key: key);

  @override
  _WardrobePageState createState() => _WardrobePageState();
}

class _WardrobePageState extends State<WardrobePage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late WardrobeService _wardrobeService;
  late OutfitService _outfitService;
  List<Wardrobe> _wardrobes = [];
  List<Wardrobe> _filteredWardrobes = [];
  List<Outfit> _outfits = [];
  List<Outfit> _filteredOutfits = [];
  final GlobalKey<AnimatedListState> _outfitsListKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _wardrobeService = WardrobeService();
    _outfitService = OutfitService();
    _tabController = TabController(length: 2, vsync: this);

    _fetchClothes().then((clothes) {
      setState(() {
        _wardrobes = clothes;
        _filteredWardrobes = List.from(_wardrobes);
      });
    });

    _fetchOutfits().then((outfits) {
      setState(() {
        _outfits = outfits;
        _filteredOutfits = List.from(_outfits);
      });
    });
  }

  Future<List<Wardrobe>> _fetchClothes() async {
    try {
      final clothes = await _wardrobeService.findClothes();
      return clothes;
    } catch (error) {
      return [];
    }
  }

  Future<List<Outfit>> _fetchOutfits() async {
    try {
      final outfits = await _outfitService.fetchOutfits();
      return outfits;
    } catch (error) {
      return [];
    }
  }

  Future<void> _deleteOutfit(int? id, int index) async {
    if (id != null) {
      try {
        print('called before. setstate');
        await _outfitService.deleteOutfit(id);
        setState(() {
          _outfits.removeAt(index);
          _filteredOutfits.removeAt(index);
          print('setState was called successfully.');
        });
      } catch (error) {
        print(error);
      }
    }
  }

  Future<void> _addClothes(Wardrobe wardrobe) async {
    try {
      final addedClothes = await _wardrobeService.addClothes(wardrobe);
      setState(() {
        _wardrobes.add(addedClothes);
        _filteredWardrobes.add(addedClothes);
      });
    } catch (error) {}
  }

  Future<void> _deleteClothes(int? id) async {
    if (id != null) {
      try {
        await _wardrobeService.deleteClothes(id);
        setState(() {
          _wardrobes.removeWhere((wardrobe) => wardrobe.id == id);
          _filteredWardrobes.removeWhere((wardrobe) => wardrobe.id == id);
        });
      } catch (error) {}
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
          _filteredWardrobes[index] = updatedClothes;
        }
      });
    } catch (error) {}
  }

  Future<void> _createOutfit(String name, List<Wardrobe> wardrobeItems) async {
    try {
      final newOutfit = await _outfitService.createOutfit(name, wardrobeItems);
      setState(() {
        _outfits.add(newOutfit);
        _filteredOutfits.add(newOutfit);
      });
    } catch (error) {
      // Handle the error
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

  void _filterWardrobes(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredWardrobes = List.from(_wardrobes);
      } else {
        _filteredWardrobes = _wardrobes
            .where((wardrobe) =>
                wardrobe.name.toLowerCase().contains(query.toLowerCase()) ||
                wardrobe.typeClothes
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _filterOutfits(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredOutfits = List.from(_outfits);
      } else {
        _filteredOutfits = _outfits.where((outfit) {
          return outfit.name?.toLowerCase().contains(query.toLowerCase()) ??
              false;
        }).toList();
      }
    });
  }

  void _handleEditOutfit(Outfit outfit) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return EditOutfitForm(
          outfit: outfit,
          wardrobeItems: _wardrobes,
          selectedWardrobeItems: outfit.wardrobeItems,
          onUpdateOutfit: (String name, List<Wardrobe> wardrobeItems) async {
            try {
              final updatedOutfit = await _outfitService.updateOutfit(
                outfit.id,
                Outfit(
                  id: outfit.id,
                  name: name,
                  wardrobeItems: wardrobeItems,
                ),
              );

              final index =
                  _outfits.indexWhere((o) => o.id == updatedOutfit.id);
              if (index != -1) {
                setState(() {
                  _outfits[index] = updatedOutfit;
                  _filteredOutfits[index] = updatedOutfit;
                });
              }
            } catch (error) {
              // Handle the error if the update fails
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Wyszukaj',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (query) {
                  if (_tabController.index == 0) {
                    _filterWardrobes(query);
                  } else {
                    _filterOutfits(query);
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.deepPurple.shade800,
                    tabs: const [
                      Tab(text: 'Clothes'),
                      Tab(text: 'Outfits'),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ListView.builder(
                    itemCount: _filteredWardrobes.length,
                    itemBuilder: (BuildContext context, int index) {
                      final wardrobe = _filteredWardrobes[index];
                      return ListTile(
                        title: Text(wardrobe.name),
                        subtitle: Text(wardrobe.typeClothes),
                        leading: wardrobe.imageUrl.isNotEmpty
                            ? Image.network(wardrobe.imageUrl)
                            : Icon(Icons.checkroom),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              color: Colors.deepPurple.shade800,
                              hoverColor: Colors.transparent,
                              onPressed: () {
                                _handleEdit(wardrobe);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              hoverColor: Colors.transparent,
                              color: Colors.red,
                              onPressed: () {
                                _deleteClothes(wardrobe.id);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Builder(builder: (BuildContext context) {
                    return ListView.builder(
                      key: _outfitsListKey,
                      itemCount: _filteredOutfits.length,
                      itemBuilder: (BuildContext context, int index) {
                        final outfit = _filteredOutfits[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              key: ValueKey(outfit.id),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Outfit: ${outfit.name.toString()}'),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.redAccent),
                                    hoverColor: Colors.transparent,
                                    onPressed: () {
                                      _deleteOutfit(outfit.id, index);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    color: Colors.blue,
                                    onPressed: () {
                                      _handleEditOutfit(outfit);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children:
                                  outfit.wardrobeItems.map((wardrobeItem) {
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  margin: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Text(wardrobeItem.name),
                                    subtitle: Text(wardrobeItem.typeClothes),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        );
                      },
                    );
                  }),
                ],
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
            ),
            const SizedBox(
              width: 16.0,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return AddOutfitForm(
                          wardrobeItems: _wardrobes,
                          onCreateOutfit: _createOutfit,
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    padding: EdgeInsets.zero,
                    elevation: 4.0,
                  ),
                  child: const Icon(
                    Icons.checkroom_rounded,
                    size: 32.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
