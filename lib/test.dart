import 'package:flutter/material.dart';

class HomePage1 extends StatefulWidget {
  @override
  _HomePage1State createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  List<TableRowData> rows = List.generate(
    10,
    (index) => TableRowData(
      id: index + 1,
      name: "用户${index + 1}",
      age: 20 + (index % 10),
      city: ["北京", "上海", "广州", "深圳", "杭州"][index % 5],
      selected: false,
    ),
  );

  List<TableColumn> columns = [
    TableColumn(key: 'select', title: '', width: 60),
    TableColumn(key: 'id', title: 'ID', width: 80, sortable: true),
    TableColumn(key: 'name', title: '姓名', width: 120, sortable: true),
    TableColumn(key: 'age', title: '年龄', width: 80, sortable: true),
    TableColumn(key: 'city', title: '城市', width: 100, sortable: true),
  ];

  String? sortBy;
  bool sortAsc = true;
  bool isAllSelected = false;

  void toggleSort(String columnKey) {
    setState(() {
      if (sortBy == columnKey) {
        sortAsc = !sortAsc;
      } else {
        sortBy = columnKey;
        sortAsc = true;
      }
      _sortRows();
    });
  }

  void _sortRows() {
    if (sortBy == null) return;
    rows.sort((a, b) {
      dynamic aValue, bValue;
      switch (sortBy) {
        case 'id':
          aValue = a.id;
          bValue = b.id;
          break;
        case 'name':
          aValue = a.name;
          bValue = b.name;
          break;
        case 'age':
          aValue = a.age;
          bValue = b.age;
          break;
        case 'city':
          aValue = a.city;
          bValue = b.city;
          break;
        default:
          return 0;
      }
      if (aValue is String && bValue is String) {
        return sortAsc ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
      } else {
        return sortAsc ? (aValue - bValue).sign : (bValue - aValue).sign;
      }
    });
  }

  void toggleSelectAll() {
    setState(() {
      isAllSelected = !isAllSelected;
      for (var row in rows) {
        row.selected = isAllSelected;
      }
    });
  }

  void toggleRowSelect(int index) {
    setState(() {
      rows[index].selected = !rows[index].selected;
      isAllSelected = rows.every((row) => row.selected);
    });
  }

  void updateColumnWidth(int index, double newWidth) {
    setState(() {
      columns[index].width = newWidth.clamp(60.0, 300.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("可交互表格")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // 固定表头
            TableHeader(
              columns: columns,
              sortBy: sortBy,
              sortAsc: sortAsc,
              onSort: toggleSort,
              isAllSelected: isAllSelected,
              onSelectAll: toggleSelectAll,
              onResize: updateColumnWidth,
            ),
            // 可滚动的表格内容
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ListView.separated(
                  itemCount: rows.length,
                  separatorBuilder: (context, index) => Divider(height: 1),
                  itemBuilder: (context, index) {
                    return TableRowWidget(
                      row: rows[index],
                      columns: columns,
                      index: index,
                      onSelect: () => toggleRowSelect(index),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== 数据模型 =====
class TableRowData {
  int id;
  String name;
  int age;
  String city;
  bool selected;

  TableRowData({
    required this.id,
    required this.name,
    required this.age,
    required this.city,
    required this.selected,
  });
}

class TableColumn {
  final String key;
  final String title;
  double width;
  final bool sortable;

  TableColumn({
    required this.key,
    required this.title,
    this.width = 100,
    this.sortable = false,
  });
}

// ===== 表头组件 =====
class TableHeader extends StatelessWidget {
  final List<TableColumn> columns;
  final String? sortBy;
  final bool sortAsc;
  final Function(String) onSort;
  final bool isAllSelected;
  final Function() onSelectAll;
  final Function(int, double) onResize;

  const TableHeader({
    required this.columns,
    required this.sortBy,
    required this.sortAsc,
    required this.onSort,
    required this.isAllSelected,
    required this.onSelectAll,
    required this.onResize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Row(
        children: List.generate(columns.length, (index) {
          final column = columns[index];
          return SizedBox(
            width: column.width,
            child: ResizableColumn(
              minWidth: 60,
              maxWidth: 300,
              width: column.width,
              onResize: (newWidth) => onResize(index, newWidth),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Row(
                  children: [
                    if (column.key == 'select')
                      Expanded(
                        child: Center(
                          child: Checkbox(
                            value: isAllSelected,
                            onChanged: (value) => onSelectAll(),
                          ),
                        ),
                      )
                    else ...[
                      Expanded(
                        child: InkWell(
                          onTap: column.sortable
                              ? () => onSort(column.key)
                              : null,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  column.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (sortBy == column.key)
                                Icon(
                                  sortAsc
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  size: 16,
                                ),
                            ],
                          ),
                        ),
                      ),
                      if (index < columns.length - 1)
                        ColumnResizeHandle(
                          onResize: (delta) =>
                              onResize(index, column.width + delta),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ===== 表格行组件 =====
class TableRowWidget extends StatelessWidget {
  final TableRowData row;
  final List<TableColumn> columns;
  final int index;
  final VoidCallback onSelect;

  const TableRowWidget({
    required this.row,
    required this.columns,
    required this.index,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: index % 2 == 0 ? Colors.white : Colors.grey[50],
      child: Row(
        children: List.generate(columns.length, (colIndex) {
          final column = columns[colIndex];
          Widget content;

          switch (column.key) {
            case 'select':
              content = Center(
                child: Checkbox(
                  value: row.selected,
                  onChanged: (value) => onSelect(),
                ),
              );
              break;
            case 'id':
              content = Text(row.id.toString());
              break;
            case 'name':
              content = Text(row.name);
              break;
            case 'age':
              content = Text(row.age.toString());
              break;
            case 'city':
              content = Text(row.city);
              break;
            default:
              content = Text('');
          }

          return SizedBox(
            width: column.width,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: content is Text
                  ? Text(
                      (content as Text).data ?? '',
                      style: (content as Text).style,
                      overflow: TextOverflow.ellipsis,
                    )
                  : content,
            ),
          );
        }),
      ),
    );
  }
}

// ===== 可拖拽调整宽度组件 =====
class ResizableColumn extends StatefulWidget {
  final double width;
  final double minWidth;
  final double maxWidth;
  final Function(double) onResize;
  final Widget child;

  const ResizableColumn({
    required this.width,
    this.minWidth = 60,
    this.maxWidth = 300,
    required this.onResize,
    required this.child,
  });

  @override
  _ResizableColumnState createState() => _ResizableColumnState();
}

class _ResizableColumnState extends State<ResizableColumn> {
  double startWidth = 0;
  double startX = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: SizedBox(
            width: 10,
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeColumn,
              child: GestureDetector(
                onHorizontalDragStart: (details) {
                  setState(() {
                    startWidth = widget.width;
                    startX = details.globalPosition.dx;
                  });
                },
                onHorizontalDragUpdate: (details) {
                  double delta = details.globalPosition.dx - startX;
                  widget.onResize(
                    (startWidth + delta).clamp(
                      widget.minWidth,
                      widget.maxWidth,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ===== 列宽调整手柄（可选视觉增强） =====
class ColumnResizeHandle extends StatelessWidget {
  final Function(double) onResize;

  const ColumnResizeHandle({required this.onResize});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      child: GestureDetector(
        onHorizontalDragStart: (details) {},
        onHorizontalDragUpdate: (details) {
          onResize(details.delta.dx);
        },
        child: Container(
          width: 6,
          color: Colors.transparent,
          margin: EdgeInsets.symmetric(vertical: 4),
          child: Center(
            child: Container(width: 2, height: 16, color: Colors.grey[400]),
          ),
        ),
      ),
    );
  }
}