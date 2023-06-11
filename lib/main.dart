// ignore_for_file: library_private_types_in_public_api, constant_identifier_names

import 'package:flutter/material.dart';

void main() {
  runApp(const RiskManagerApp());
}

class RiskManagerApp extends StatelessWidget {
  const RiskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Risk Manager',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        scaffoldBackgroundColor: Colors.green[100],
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Risk Manager'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'Images/riskmeter.png',
              width: 250,
            ),
            const Text(
              'Risk Yönetim Uygulamasına Hoşgeldiniz!',
              style: TextStyle(fontSize: 20),
            ),
            const Text(
              'Risk ve önlem ekleyip, silip, onları yönettiğiniz yer...',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RiskListPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
              ),
              child: const Text('Risklere bak'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PrecautionPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[700],
              ),
              child: const Text('Önlemlere bak'),
            ),
          ],
        ),
      ),
    );
  }
}

class RiskListPage extends StatefulWidget {
  const RiskListPage({super.key});

  @override
  _RiskListPageState createState() => _RiskListPageState();
}

class _RiskListPageState extends State<RiskListPage> {
  static List<RiskItem> riskItems = [
    RiskItem('1. derece deprem bölgesi', RiskPriority.Yuksek),
    RiskItem('Kolonların durumu', RiskPriority.Orta),
    RiskItem('Kitaplık sabit değil', RiskPriority.Dusuk),
  ];
  final myController = TextEditingController();
  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Risk Listesi'),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                SizedBox(width: 80),
                Text(
                  'Risk',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 80),
                Text(
                  'Öncelik',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'Sil',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.black,
            height: 1,
            thickness: 1,
            indent: 16.0,
            endIndent: 16.0,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: riskItems.length,
              itemBuilder: (BuildContext context, int index) {
                final riskItem = riskItems[index];
                return ListTile(
                  leading: Icon(Icons.warning,
                      color: _getRiskColor(riskItem.priority)),
                  title: Text(riskItem.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButton<RiskPriority>(
                        value: riskItem.priority,
                        icon: const Icon(Icons.arrow_drop_down_rounded),
                        onChanged: (RiskPriority? newValue) {
                          setState(() {
                            if (newValue != null) {
                              riskItem.priority = newValue;
                            }
                          });
                        },
                        items: RiskPriority.values
                            .map<DropdownMenuItem<RiskPriority>>(
                                (RiskPriority value) {
                          return DropdownMenuItem<RiskPriority>(
                            value: value,
                            child: Text(value.toString().split('.').last),
                          );
                        }).toList(),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_forever_outlined),
                        onPressed: () {
                          setState(() {
                            riskItems.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddRiskDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddRiskDialog() {
    String? riskName;
    RiskPriority? selectedPriority;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              scrollable: true,
              title: const Text('Risk Ekle'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Risk giriniz',
                    ),
                    onChanged: (value) {
                      riskName = value;
                    },
                  ),
                  ...RiskPriority.values.map((priority) {
                    return RadioListTile<RiskPriority>(
                      title: Text(priority.toString().split('.').last),
                      value: priority,
                      groupValue: selectedPriority,
                      onChanged: (RiskPriority? value) {
                        setState(() {
                          selectedPriority = value;
                        });
                      },
                    );
                  }).toList(),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('İptal'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      riskItems.add(
                        RiskItem(riskName!, selectedPriority!),
                      );
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ekle'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

Color _getRiskColor(RiskPriority priority) {
  switch (priority) {
    case RiskPriority.Yuksek:
      return Colors.red;
    case RiskPriority.Orta:
      return Colors.orange;
    case RiskPriority.Dusuk:
      return Colors.green;
    default:
      return Colors.black;
  }
}

enum RiskPriority {
  Yuksek,
  Orta,
  Dusuk,
}

class RiskItem {
  String name;
  RiskPriority priority;

  RiskItem(this.name, this.priority);
}

class PrecautionPage extends StatefulWidget {
  const PrecautionPage({super.key});

  @override
  _PrecautionPageState createState() => _PrecautionPageState();
}

class _PrecautionPageState extends State<PrecautionPage> {
  List<PrecautionItem> precautionItems = [
    PrecautionItem("Taşınmak için yeni ev araştırılacak",
        _RiskListPageState.riskItems[0].name),
    PrecautionItem(
        "Kolon testi yapılacak", _RiskListPageState.riskItems[1].name)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Önlemler'),
      ),
      body: ListView.builder(
        itemCount: precautionItems.length,
        itemBuilder: (BuildContext context, int index) {
          final precautionItem = precautionItems[index];
          return ListTile(
            title: Text(precautionItem.name),
            subtitle: Text(precautionItem.riskItem),
            trailing: IconButton(
              icon: const Icon(Icons.delete_forever_outlined),
              onPressed: () {
                setState(() {
                  precautionItems.removeAt(index);
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPrecautionDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddPrecautionDialog() {
    String precautionName = '';
    RiskItem? selectedRiskItemNull;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Önlem Ekle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Önlem giriniz',
                ),
                onChanged: (value) {
                  precautionName = value;
                },
              ),
              DropdownButton<RiskItem>(
                hint: const Text('Risk seçiniz'),
                onChanged: (RiskItem? newValue) {
                  setState(() {
                    selectedRiskItemNull = newValue;
                  });
                },
                items: _RiskListPageState.riskItems
                    .map<DropdownMenuItem<RiskItem>>((RiskItem risk) {
                  return DropdownMenuItem<RiskItem>(
                    value: risk,
                    child: Text(risk.name),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                if (precautionName.isNotEmpty && selectedRiskItemNull != null) {
                  RiskItem selectedRiskItem = RiskItem(
                      selectedRiskItemNull!.name,
                      selectedRiskItemNull!.priority);
                  setState(() {
                    precautionItems.add(
                      PrecautionItem(precautionName, selectedRiskItem.name),
                    );
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Ekle'),
            ),
          ],
        );
      },
    );
  }
}

class PrecautionItem {
  String name;
  String riskItem;

  PrecautionItem(this.name, this.riskItem);
}
