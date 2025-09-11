import 'package:equatable/equatable.dart';

enum GridStatus { initial, loading, loaded, deleting, error }

class CommonDataGridState<T> extends Equatable {
  final GridStatus status;
  final List<T> data;
  final int currentPage;
  final int totalPages;
  final List<int> selectedRows;
  final String? errorMessage;

  const CommonDataGridState({
    this.status = GridStatus.initial,
    this.data = const [],
    this.currentPage = 0,
    this.totalPages = 1,
    this.selectedRows = const [],
    this.errorMessage,
  });

  CommonDataGridState<T> copyWith({
    GridStatus? status,
    List<T>? data,
    int? currentPage,
    int? totalPages,
    List<int>? selectedRows,
    String? errorMessage,
  }) {
    return CommonDataGridState<T>(
      status: status ?? this.status,
      data: data ?? this.data,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      selectedRows: selectedRows ?? this.selectedRows,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    data,
    currentPage,
    totalPages,
    selectedRows,
    errorMessage,
  ];
}
