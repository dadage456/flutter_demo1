import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CollectionTable extends StatefulWidget {
  const CollectionTable({super.key});

  @override
  State<CollectionTable> createState() => _CollectionTableState();
}

class _CollectionTableState extends State<CollectionTable> {
  late CollectionDataSource _dataSource;
  late Map<String, double> columnWidths = {};

  final List<CollectionItem> items = List.generate(
    10,
    (index) => CollectionItem(
      materialCode: '10006503',
      location: 'C1PR560206',
      taskQuantity: 100,
      collectedQuantity: 0,
    ),
  );

  @override
  initState() {
    super.initState();
    _dataSource = CollectionDataSource(items);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SfDataGrid(
        source: _dataSource,
        allowSorting: true,
        allowColumnsResizing: true,
        onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
          setState(() {
            columnWidths[details.column.columnName] = details.width;
          });
          return true;
        },
        columnWidthMode: ColumnWidthMode.auto,
        // defaultColumnWidth: 100,
        gridLinesVisibility: GridLinesVisibility.both,
        headerGridLinesVisibility: GridLinesVisibility.both,
        showCheckboxColumn: true,
        selectionMode: SelectionMode.multiple,
        checkboxColumnSettings: DataGridCheckboxColumnSettings(
          // Customize the checkbox column here
          // For example, you can set the width or other properties
          width: 50,
          // backgroundColor: Colors.blue,
        ),
        headerRowHeight: 32,
        rowHeight: 32,
        columns: [
          GridColumn(
            columnName: 'materialCode',
            width: columnWidths['materialCode'] ?? double.nan,
            autoFitPadding: const EdgeInsets.symmetric(horizontal: 8),
            label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.centerLeft,
              child: const Text(
                '物料编码',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),
          GridColumn(
            columnName: 'location',
            width: columnWidths['location'] ?? double.nan,
            autoFitPadding: const EdgeInsets.symmetric(horizontal: 8),
            label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.centerLeft,
              child: const Text(
                '库位',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),
          GridColumn(
            columnName: 'taskQuantity',
            width: columnWidths['taskQuantity'] ?? double.nan,
            autoFitPadding: const EdgeInsets.symmetric(horizontal: 8),
            label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.centerLeft,
              child: const Text(
                '任务数量',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),
          GridColumn(
            columnName: 'collectedQuantity',
            width: columnWidths['collectedQuantity'] ?? double.nan,
            autoFitPadding: const EdgeInsets.symmetric(horizontal: 8),
            label: Container(
              width: 80,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.centerLeft,
              child: const Text(
                '采集数量',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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

class CollectionDataSource extends DataGridSource {
  CollectionDataSource(this.items) {
    dataGridRows = items.map<DataGridRow>((item) {
      return DataGridRow(
        cells: [
          DataGridCell<String>(
            columnName: 'materialCode',
            value: item.materialCode,
          ),
          DataGridCell<String>(columnName: 'location', value: item.location),
          DataGridCell<int>(
            columnName: 'taskQuantity',
            value: item.taskQuantity,
          ),
          DataGridCell<int>(
            columnName: 'collectedQuantity',
            value: item.collectedQuantity,
          ),
        ],
      );
    }).toList();
  }

  final List<CollectionItem> items;
  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataCell) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          // decoration: BoxDecoration(color: Colors.green),
          alignment: Alignment.centerLeft,
          child: Text(
            dataCell.value.toString(),
            style: const TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
    );
  }

  void updateDataGridRow() {
    notifyListeners();
  }
}
