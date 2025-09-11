import 'package:flutter/material.dart';
import 'package:flutter_demo/collection_table.dart';
import 'package:flutter_demo/common_grid.dart/common_data_grid.dart';

class CommonGridColumnGenerate {
  static List<GridColumnConfig<CollectionItem>> generateGridColumnsForCollectionTable() {
    return [
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
    ];
  }
}
