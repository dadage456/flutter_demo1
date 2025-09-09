import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

const TextStyle _titleStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w600,
);
const TextStyle _infoStyle = TextStyle(
  fontSize: 14,
  // fontWeight: FontWeight.w400,
);

const Color _titleBgColor = Color(0xFFF6F6F6);
const Color _borderColor = Color(0xFFE0E6ED);
const Color _infoBgColor = Color(0xFFF6F6F6);

class CollectionTable extends StatefulWidget {
  const CollectionTable({super.key});

  @override
  State<CollectionTable> createState() => _CollectionTableState();
}

class _CollectionTableState extends State<CollectionTable> {
  late CollectionDataSource _dataSource;
  late Map<String, double> columnWidths = {};
  final _customColumnSize = CustomColumnSizer();

  final List<CollectionItem> items = List.generate(
    10,
    (index) => CollectionItem(
      materialCode: '10006503',
      location: 'C1PR560206',
      taskQuantity: 100 + index,
      collectedQuantity: 0 + index,
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
      child: SfDataGridTheme(
        data: SfDataGridThemeData(
          gridLineColor: _borderColor,
          headerColor: _titleBgColor,
          sortIcon: Builder(
            builder: (context) {
              Widget? icon;
              String columnName = '';
              context.visitAncestorElements((element) {
                if (element is GridHeaderCellElement) {
                  columnName = element.column.columnName;
                }
                return true;
              });
              var column = _dataSource.sortedColumns
                  .where((element) => element.name == columnName)
                  .firstOrNull;
              if (column != null) {
                if (column.sortDirection == DataGridSortDirection.ascending) {
                  icon = const Icon(Icons.arrow_drop_up, size: 16);
                } else if (column.sortDirection ==
                    DataGridSortDirection.descending) {
                  icon = const Icon(Icons.arrow_drop_down, size: 16);
                }
              }
              // return icon ?? const Icon(Icons.sort_outlined, size: 16);
              return icon ?? SizedBox();
            },
          ),
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
          // columnSizer: _customColumnSize,
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
                child: const Text('物料编码', style: _titleStyle),
              ),
            ),
            GridColumn(
              columnName: 'location',
              width: columnWidths['location'] ?? double.nan,
              autoFitPadding: const EdgeInsets.symmetric(horizontal: 8),
              label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.centerLeft,
                child: const Text('库位', style: _titleStyle),
              ),
            ),
            GridColumn(
              columnName: 'taskQuantity',
              width: columnWidths['taskQuantity'] ?? double.nan,
              autoFitPadding: const EdgeInsets.symmetric(horizontal: 8),
              label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.centerLeft,
                child: const Text('任务数量', style: _titleStyle),
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
                child: const Text('采集数量', style: _titleStyle),
              ),
            ),
          ],
        ),
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
    final int index = effectiveRows.indexOf(row);
    final Color rowColor = index % 2 == 0 ? Colors.white : _infoBgColor;

    return DataGridRowAdapter(
      color: rowColor,
      cells: row.getCells().map<Widget>((dataCell) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          // decoration: BoxDecoration(color: Colors.green),
          alignment: Alignment.centerLeft,
          child: Text(dataCell.value.toString(), style: _infoStyle),
        );
      }).toList(),
    );
  }

  void updateDataGridRow() {
    notifyListeners();
  }
}

class CustomColumnSizer extends ColumnSizer {
  @override
  double computeHeaderCellWidth(GridColumn column, TextStyle style) {
    return super.computeHeaderCellWidth(column, style);
  }

  @override
  double computeCellWidth(
    GridColumn column,
    DataGridRow row,
    Object? cellValue,
    TextStyle textStyle,
  ) {
    return super.computeCellWidth(column, row, cellValue, textStyle);
  }
}
