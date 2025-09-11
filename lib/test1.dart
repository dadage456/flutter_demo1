import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_demo/common_grid.dart/common_data_grid.dart';
import 'package:flutter_demo/common_grid.dart/grid_bloc.dart';
import 'package:flutter_demo/common_grid.dart/grid_event.dart';
import 'package:flutter_demo/common_grid.dart/grid_state.dart';

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

  late final CommonDataGridBloc<CollectionItem> _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = CommonDataGridBloc<CollectionItem>(
      dataLoader: (pageIndex) async {
        await Future.delayed(const Duration(seconds: 1));
        return List.generate(
          150,
          (i) => CollectionItem(
            materialCode: '1000650$i',
            location: 'C1PR56020$i',
            taskQuantity: 100 + i,
            collectedQuantity: i,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child:
          BlocBuilder<
            CommonDataGridBloc<CollectionItem>,
            CommonDataGridState<CollectionItem>
          >(
            builder: (context, state) {
              debugPrint('------------------构建表格 ------------------');
              print(
                '--------rows: ${state.status}  ${state.errorMessage ?? ''}',
              );
              debugPrint('--------selected rows: ${state.selectedRows}');
              return CommonDataGrid<CollectionItem>(
                columns: _generateGridColumns(),
                currentPage: state.currentPage,
                totalPages: state.totalPages,
                onLoadData: (pageIndex) async {
                  _currentPage = pageIndex;
                  debugPrint('load page data $pageIndex');
                  await Future.delayed(const Duration(microseconds: 1));

                  _bloc.add(LoadDataEvent(pageIndex));
                },

                selectedRows: state.selectedRows,
                onSelectionChanged: (list) {
                  debugPrint('selectedRows: $list');
                  _bloc.add(ChangeSelectedRowsEvent(list));
                },
                datas: state.data,
                allowPager: true,
                allowSelect: true,
              );
            },
          ),
    );
  }

  List<GridColumnConfig<CollectionItem>> _generateGridColumns() {
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
