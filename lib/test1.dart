import 'package:flutter/material.dart';
import 'package:flutter_demo/common_data_grid.dart';

class CollectionItem {
  final String materialCode;
  final String location;
  final int taskQuantity;
  final int collectedQuantity;

  CollectionItem({
    required this.materialCode,
    required this.location,
    required this.taskQuantity,
    required this.collectedQuantity,
  });
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  int _currentPage = 0;
  int _totalPages = 10;
  List<CollectionItem> _rows = [];
  List<CollectionItem> _selected = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('通用表格 Demo')),
      body: CommonDataGrid<CollectionItem>(
        columns: [
          GridColumnConfig(
            name: 'materialCode',
            headerText: '物料编码',
            valueGetter: (item) => item.materialCode,
          ),
          GridColumnConfig(
            name: 'location',
            headerText: '库位',
            valueGetter: (item) => item.location,
          ),
          GridColumnConfig(
            name: 'taskQuantity',
            headerText: '任务数量',
            valueGetter: (item) => item.taskQuantity,
            cellBuilder: (row, _, value) =>
                Text('$value', style: const TextStyle(color: Colors.blue)),
          ),
          GridColumnConfig(
            name: 'collectedQuantity',
            headerText: '采集数量',
            valueGetter: (item) => item.collectedQuantity,
          ),
        ],
        currentPage: _currentPage,
        totalPages: _totalPages,
        onLoadData: (pageIndex) async {
          _currentPage = pageIndex;
          debugPrint('load page $pageIndex');
          await Future.delayed(const Duration(microseconds: 1));
          setState(() {
            if (pageIndex == 0) {
              _rows = List.generate(
                150,
                (i) => CollectionItem(
                  materialCode: '1000650$i',
                  location: 'C1PR56020$i',
                  taskQuantity: 100 + i,
                  collectedQuantity: i,
                ),
              );
            } else {
              _totalPages = 5;
              _rows = List.generate(
                1500,
                (i) => CollectionItem(
                  materialCode: '1000650$i',
                  location: 'C1PR56020$i',
                  taskQuantity: 10 + i,
                  collectedQuantity: i + i,
                ),
              );
            }
          });
        },

        selectedRows: _selected,
        onSelectionChanged: (list) => setState(() => _selected = list),
        datas: _rows,
        allowPager: true,
        allowSelect: true,
      ),
    );
  }
}
