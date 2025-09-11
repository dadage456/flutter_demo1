import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_demo/common_grid.dart/grid_event.dart';
import 'package:flutter_demo/common_grid.dart/grid_state.dart';

typedef DataLoader<T> = Future<List<T>> Function(int pageIndex);
typedef DataDeleter<T> = Future<void> Function(List<T> items);

class CommonDataGridBloc<T>
    extends Bloc<CommonDataGridEvent<T>, CommonDataGridState<T>> {
  final DataLoader<T> dataLoader;
  final DataDeleter<T>? dataDeleter;

  CommonDataGridBloc({required this.dataLoader, this.dataDeleter})
    : super(CommonDataGridState<T>()) {
    on<LoadDataEvent<T>>(_onLoadData);
    on<DeleteSelectedRowsEvent<T>>(_onDeleteSelectedRows);

    on<ChangeSelectedRowsEvent<T>>(_onChangeSelectedRows);
    on<UpdateTableDataEvent<T>>(_onUpdateData);
  }

  /// 处理加载数据事件
  Future<void> _onLoadData(
    LoadDataEvent<T> event,
    Emitter<CommonDataGridState<T>> emit,
  ) async {
    try {
      emit(state.copyWith(status: GridStatus.loading));

      final data = await dataLoader(event.pageIndex);

      debugPrint('加载数据成功: $data');

      emit(
        state.copyWith(
          status: GridStatus.loaded,
          currentPage: event.pageIndex,
          totalPages: 20,
          data: data,
          selectedRows: [],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: GridStatus.error, errorMessage: e.toString()),
      );
    }
  }

  /// 处理删除选中行事件
  Future<void> _onDeleteSelectedRows(
    DeleteSelectedRowsEvent<T> event,
    Emitter<CommonDataGridState<T>> emit,
  ) async {
    if (dataDeleter == null) {
      emit(state.copyWith(status: GridStatus.error, errorMessage: '删除功能未配置'));
      return;
    }

    try {
      // 发出删除中状态
      emit(state.copyWith(status: GridStatus.loading));
      // 执行删除操作
      //await dataDeleter!();

      // 删除成功后，从当前数据中移除被删除的项
      final updatedData = <T>[];

      for (var i = 0; i < state.data.length; i++) {
        if (!event.selectedRows.contains(i)) {
          updatedData.add(state.data[i]);
        }
      }

      // 清空选中项并更新数据
      emit(
        state.copyWith(
          status: GridStatus.loaded,
          data: updatedData,
          selectedRows: [],
        ),
      );

      // 重新加载当前页数据以确保数据同步
      // add(LoadDataEvent<T>(state.currentPage));
    } catch (e) {
      emit(
        state.copyWith(
          status: GridStatus.error,
          errorMessage: '删除失败: ${e.toString()}',
        ),
      );
    }
  }

  /// 修改选择行
  Future<void> _onChangeSelectedRows(
    ChangeSelectedRowsEvent<T> event,
    Emitter<CommonDataGridState<T>> emit,
  ) async {
    emit(state.copyWith(selectedRows: event.selectedRows));
  }

  /// 更新表格中的数据
  Future<void> _onUpdateData(
    UpdateTableDataEvent<T> event,
    Emitter<CommonDataGridState<T>> emit,
  ) async {
    emit(state.copyWith(data: event.data));
  }

  /// 是否可以刷新
  bool canUpdate(
    CommonDataGridState<T> previousState,
    CommonDataGridState<T> currentState,
  ) {
    return previousState.status != currentState.status ||
        previousState.data != currentState.data ||
        previousState.currentPage != currentState.currentPage ||
        previousState.totalPages != currentState.totalPages ||
        previousState.selectedRows != currentState.selectedRows ||
        previousState.errorMessage != currentState.errorMessage;
  }
}
