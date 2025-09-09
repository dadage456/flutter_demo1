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
            builder: (_) {
              debugPrint('-------${_dataSource.sortedColumns}');
              // 未排序列 → 返回空白
              if (_dataSource.sortedColumns.isEmpty)
                return (width: 16, height: 16);

              // 能走到这里，说明当前 Builder 位于“已排序列”的 Header 里
              final column = _dataSource.sortedColumns.first;
              return Icon(
                column.sortDirection == DataGridSortDirection.ascending
                    ? Icons.arrow_circle_up_rounded
                    : Icons.arrow_circle_down_rounded,
                size: 16,
              );
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
              label: Builder(
                builder: (context) {
                  final sortedColumn = _dataSource.sortedColumns
                      .where((c) => c.name == 'id')
                      .toList();

                  final icon = sortedColumn.isNotEmpty
                      ? Icon(
                          sortedColumn.first.sortDirection ==
                                  DataGridSortDirection.ascending
                              ? Icons.arrow_circle_up_rounded
                              : Icons.arrow_circle_down_rounded,
                          size: 16,
                        )
                      : const SizedBox(width: 16, height: 16);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('物料编码', style: _titleStyle),
                      const SizedBox(width: 4),
                      icon,
                    ],
                  );
                },
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
