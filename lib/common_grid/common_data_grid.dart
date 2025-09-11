import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

typedef Future<List<T>> LoadFunction<T>(int pageIndex);
typedef Future<void> LoadDataFunction(int pageIndex);

/* ------------------ 样式常量（沿用你已有的） ------------------ */
const TextStyle _titleStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w600,
);
const TextStyle _infoStyle = TextStyle(fontSize: 14);

const Color _titleBgColor = Color(0xFFF6F6F6);
const Color _borderColor = Color(0xFFE0E6ED);
const Color _infoBgColor = Color(0xFFF6F6F6);

/* ------------------ 通用表格组件 ------------------ */
typedef CellBuilder<T> =
    Widget? Function(T rowData, String columnName, dynamic cellValue);

typedef HeaderBuilder = Widget? Function(String columnName, String headerText);

class CommonDataGrid<T> extends StatefulWidget {
  /* 列配置 */
  final List<GridColumnConfig<T>> columns;

  /* 行数据 */
  final List<T> datas;

  /* 分页信息 */
  final int currentPage;
  final int totalPages;

  final LoadDataFunction onLoadData;

  /* 选中控制 */
  final List<int> selectedRows;
  final ValueChanged<List<int>>? onSelectionChanged;

  /* 显隐控制 */
  final bool allowPager;
  final bool allowSelect;

  /* 外部控制器（可选） */
  final DataGridController? dataGridController;
  final DataPagerController? dataPagerController;

  /* 高度 */
  final double? height;

  const CommonDataGrid({
    super.key,
    required this.columns,
    required this.datas,
    this.currentPage = 0,
    this.totalPages = 1,
    required this.onLoadData,
    this.selectedRows = const [],
    this.onSelectionChanged,
    this.allowPager = false,
    this.allowSelect = false,
    this.dataGridController,
    this.dataPagerController,
    this.height,
  });

  @override
  State<CommonDataGrid<T>> createState() => _CommonDataGridState<T>();
}

class _CommonDataGridState<T> extends State<CommonDataGrid<T>> {
  Map<String, double> columnWidths = {};
  late _CommonDataSource<T> _source;
  late DataGridController _controller;
  late DataPagerController _dataPagerController;
  Set<int> _selectedIndexInPage = {};

  @override
  void initState() {
    super.initState();
    _controller = widget.dataGridController ?? DataGridController();
    _dataPagerController = widget.dataPagerController ?? DataPagerController();

    _source = _CommonDataSource<T>(
      datas: widget.datas,
      columns: widget.columns,
      onLoadData: widget.onLoadData,
    );

    // 加载数据
    widget.onLoadData(widget.currentPage);
    debugPrint('INIT currentPage: ${widget.currentPage}');
  }

  @override
  void didUpdateWidget(covariant CommonDataGrid<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.datas != widget.datas ||
        oldWidget.currentPage != widget.currentPage) {
      _source = _CommonDataSource<T>(
        datas: widget.datas,
        columns: widget.columns,
        onLoadData: widget.onLoadData,
      );
      // _dataPagerController.selectedPageIndex = widget.currentPage;

      _selectedIndexInPage.clear(); // 数据变了就清空
      debugPrint(
        '----- table didUpdateWidget currentPage: ${widget.currentPage}',
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _dataPagerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pagerHeight = widget.allowPager ? 64.0 : 0.0;
    final bodyHeight = widget.height != null
        ? widget.height! - pagerHeight
        : double.infinity;

    return LayoutBuilder(
      builder: (_, constraints) {
        final maxHeight = bodyHeight == double.infinity
            ? constraints.maxHeight
            : bodyHeight;
        return Column(
          children: [
            /* 表格 */
            Expanded(
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
                      var column = _source.sortedColumns
                          .where((element) => element.name == columnName)
                          .firstOrNull;
                      if (column != null) {
                        if (column.sortDirection ==
                            DataGridSortDirection.ascending) {
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
                  controller: _controller,
                  source: _source,
                  allowSorting: true,
                  allowColumnsResizing: true,
                  columnWidthMode: ColumnWidthMode.auto,
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  onSelectionChanged: _handleSelectionChanged,

                  onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
                    setState(() {
                      columnWidths[details.column.columnName] = details.width;
                    });
                    return true;
                  },
                  showCheckboxColumn: widget.allowSelect,
                  selectionMode: widget.allowSelect
                      ? SelectionMode.multiple
                      : SelectionMode.none,
                  checkboxColumnSettings: const DataGridCheckboxColumnSettings(
                    width: 50,
                  ),
                  headerRowHeight: 32,
                  rowHeight: 32,
                  columns: widget.columns
                      .map((e) => _buildGridColumn(e))
                      .toList(),
                ),
              ),
            ),
            /* 分页 */
            if (widget.allowPager) _buildPager(),
          ],
        );
      },
    );
  }

  Widget _buildPager() {
    return Container(
      height: 64,
      decoration: const BoxDecoration(color: Colors.white),
      child: SfDataPagerTheme(
        data: SfDataPagerThemeData(
          itemBorderWidth: 0.5,
          itemBorderColor: Colors.grey[200],
          itemBorderRadius: BorderRadius.circular(4),
          selectedItemColor: Colors.blue,
          selectedItemTextStyle: TextStyle(color: Colors.white),
        ),
        child: SfDataPager(
          controller: _dataPagerController,
          delegate: _source,
          pageCount: widget.totalPages.toDouble(),
          visibleItemsCount: 6,
          itemWidth: 40,
          itemHeight: 40,
          navigationItemWidth: 66,
          navigationItemHeight: 40,
          firstPageItemVisible: false,
          lastPageItemVisible: false,
        ),
      ),
    );
  }

  GridColumn _buildGridColumn(GridColumnConfig cfg) {
    final effectiveWidth = columnWidths[cfg.name] ?? cfg.width ?? double.nan;

    return GridColumn(
      columnName: cfg.name,
      width: effectiveWidth.isNaN ? double.nan : effectiveWidth,
      autoFitPadding: const EdgeInsets.symmetric(horizontal: 8),
      label: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.centerLeft,
        child:
            cfg.headerBuilder?.call(cfg.name, cfg.headerText) ??
            Text(cfg.headerText, style: _titleStyle),
      ),
    );
  }

  void _handleSelectionChanged(
    List<DataGridRow> added,
    List<DataGridRow> removed,
  ) {
    // 1. 把 DataGridRow 转成它在当前页里的索引
    void addIndex(DataGridRow r) {
      final idx = _source.rows.indexOf(r);
      if (idx >= 0) _selectedIndexInPage.add(idx);
    }

    void removeIndex(DataGridRow r) {
      final idx = _source.rows.indexOf(r);
      if (idx >= 0) _selectedIndexInPage.remove(idx);
    }

    added.forEach(addIndex);
    removed.forEach(removeIndex);

    debugPrint('selectedIndexInPage: ${_selectedIndexInPage.join(', ')}');

    // 2. 通知外部：把索引集合转 List 并回调
    widget.onSelectionChanged?.call(_selectedIndexInPage.toList());
  }
}

/* ------------------ 数据源 ------------------ */
class _CommonDataSource<T> extends DataGridSource {
  final List<T> datas;
  final List<GridColumnConfig<T>> columns;
  final LoadDataFunction onLoadData;

  _CommonDataSource({
    required this.datas,
    required this.columns,
    required this.onLoadData,
  }) {
    _mapDataGridRows();
  }

  List<DataGridRow> _dataGridRows = [];

  void _mapDataGridRows() {
    _dataGridRows = datas.map((item) {
      final cells = <DataGridCell>[];
      for (final col in columns) {
        final value = col.valueGetter(item);
        cells.add(DataGridCell<dynamic>(columnName: col.name, value: value));
      }
      return DataGridRow(cells: cells);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final index = rows.indexOf(row);
    final effectiveIndex = effectiveRows.indexOf(row);
    final color = effectiveIndex % 2 == 0 ? Colors.white : _infoBgColor;

    return DataGridRowAdapter(
      color: color,
      cells: row.getCells().map<Widget>((cell) {
        final col = columns.firstWhere((e) => e.name == cell.columnName);
        final custom = col.cellBuilder?.call(
          datas[index],
          cell.columnName,
          cell.value,
        );
        return custom ??
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.centerLeft,
              child: Text(cell.value?.toString() ?? '', style: _infoStyle),
            );
      }).toList(),
    );
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    if (oldPageIndex != newPageIndex) {
      await onLoadData(newPageIndex);
      return true;
    }
    debugPrint('------------- page change ----------');
    debugPrint('old: $oldPageIndex, new: $newPageIndex');
    // return super.handlePageChange(oldPageIndex, newPageIndex);
    return false;
  }
}

/* ------------------ 列配置对象 ------------------ */
class GridColumnConfig<T> {
  final String name;
  final String headerText;
  final double? width;
  final HeaderBuilder? headerBuilder;
  final CellBuilder<T>? cellBuilder;
  final dynamic Function(T row) valueGetter;

  GridColumnConfig({
    required this.name,
    required this.headerText,
    this.width,
    this.headerBuilder,
    required this.valueGetter,
    this.cellBuilder,
  });
}
