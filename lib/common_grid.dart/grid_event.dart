import 'package:equatable/equatable.dart';

abstract class CommonDataGridEvent<T> extends Equatable {
  const CommonDataGridEvent();

  @override
  List<Object?> get props => [];
}

/// 加载数据事件
class LoadDataEvent<T> extends CommonDataGridEvent<T> {
  final int pageIndex;

  const LoadDataEvent(this.pageIndex);

  @override
  List<Object?> get props => [pageIndex];
}

/// 删除选中行事件
class DeleteSelectedRowsEvent<T> extends CommonDataGridEvent<T> {
  final List<int> selectedRows;

  const DeleteSelectedRowsEvent(this.selectedRows);

  @override
  List<Object?> get props => [selectedRows];
}

class ChangeSelectedRowsEvent<T> extends CommonDataGridEvent<T> {
  final List<int> selectedRows;

  const ChangeSelectedRowsEvent(this.selectedRows);

  @override
  List<Object?> get props => [selectedRows];
}

class UpdateTableDataEvent<T> extends CommonDataGridEvent<T> {
  final List<T> data;

  const UpdateTableDataEvent(this.data);

  @override
  List<Object?> get props => [data];
}
