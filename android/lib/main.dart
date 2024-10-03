import 'package:flutter/material.dart';

void main() {
  runApp(MakananApp());
}

class MakananApp extends StatefulWidget {
  @override
  _MakananAppState createState() => _MakananAppState();
}

class _MakananAppState extends State<MakananApp> {
  bool isDarkMode = false;

  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Makanan',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: MakananList(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
    );
  }
}

class MakananList extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  MakananList({required this.toggleTheme, required this.isDarkMode});

  @override
  _MakananListState createState() => _MakananListState();
}

class _MakananListState extends State<MakananList> {
  final List<Makanan> makananList = [
    Makanan(
        'Nasi Goreng',
        'Nasi yang digoreng dengan bumbu dan bahan tambahan, biasanya disajikan dengan telur dan ayam.',
        'https://upload.wikimedia.org/wikipedia/commons/e/e1/Nasi_Goreng.jpg'),
    Makanan(
        'Sate',
        'Daging yang ditusuk dan dipanggang, biasanya disajikan dengan bumbu kacang.',
        'https://upload.wikimedia.org/wikipedia/commons/7/73/Sate_Kambing_Indonesian_Food.jpg'),
    Makanan(
        'Rendang',
        'Daging sapi yang dimasak dengan santan dan rempah-rempah hingga empuk.',
        'https://upload.wikimedia.org/wikipedia/commons/3/39/Rendang.jpg'),
    Makanan('Gado-Gado', 'Salad sayur dengan bumbu kacang yang kaya rasa.',
        'https://upload.wikimedia.org/wikipedia/commons/2/21/Gado-gado.jpg'),
    Makanan(
        'Sop Buntut',
        'Sup yang terbuat dari buntut sapi yang dimasak dengan rempah-rempah.',
        'https://upload.wikimedia.org/wikipedia/commons/a/ab/Oxtail_Soup.jpg'),
    Makanan(
        'Bakso',
        'Bola daging yang disajikan dalam kuah kaldu, biasanya dengan mie dan tahu.',
        'https://upload.wikimedia.org/wikipedia/commons/6/6b/Bakso.jpg'),
    Makanan('Mie Goreng', 'Mie yang digoreng dengan bumbu dan sayuran.',
        'https://upload.wikimedia.org/wikipedia/commons/3/3f/Mie_Goreng.jpg'),
    Makanan(
        'Pecel Lele',
        'Ikan lele yang digoreng dan disajikan dengan sambal dan nasi.',
        'https://upload.wikimedia.org/wikipedia/commons/a/ad/Pecel_Lele.jpg'),
  ];

  List<Makanan> filteredMakananList = [];
  List<Makanan> favoriteMakananList = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredMakananList = makananList; // Initialize with all foods
  }

  void filterMakanan(String query) {
    setState(() {
      searchQuery = query;
      filteredMakananList = makananList.where((makanan) {
        return makanan.nama.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void toggleFavorite(Makanan makanan) {
    setState(() {
      if (favoriteMakananList.contains(makanan)) {
        favoriteMakananList.remove(makanan);
      } else {
        favoriteMakananList.add(makanan);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Makanan'),
        actions: [
          Switch(
            value: widget.isDarkMode,
            onChanged: widget.toggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: filterMakanan,
              decoration: InputDecoration(
                labelText: 'Cari Makanan',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredMakananList.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ListTile(
                    leading: Image.network(
                      filteredMakananList[index].gambarUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(filteredMakananList[index].nama),
                    subtitle: Text(filteredMakananList[index].deskripsi),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            favoriteMakananList
                                    .contains(filteredMakananList[index])
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: favoriteMakananList
                                    .contains(filteredMakananList[index])
                                ? Colors.red
                                : null,
                          ),
                          onPressed: () =>
                              toggleFavorite(filteredMakananList[index]),
                        ),
                        ElevatedButton(
                          child: Text('Detail'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MakananDetail(
                                    makanan: filteredMakananList[index]),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Makanan {
  final String nama;
  final String deskripsi;
  final String gambarUrl;

  Makanan(this.nama, this.deskripsi, this.gambarUrl);
}

class MakananDetail extends StatelessWidget {
  final Makanan makanan;

  MakananDetail({required this.makanan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(makanan.nama),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              makanan.gambarUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
            SizedBox(height: 16),
            Text(
              makanan.deskripsi,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
