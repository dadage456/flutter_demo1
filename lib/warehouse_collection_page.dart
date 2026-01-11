import 'package:flutter/material.dart';

class WarehouseCollectionPage extends StatefulWidget {
  const WarehouseCollectionPage({super.key});

  @override
  State<WarehouseCollectionPage> createState() => _WarehouseCollectionPageState();
}

class _WarehouseCollectionPageState extends State<WarehouseCollectionPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _scanController = TextEditingController();
  final FocusNode _scanFocusNode = FocusNode();
  Set<int> _selectedItems = {};
  bool _isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scanFocusNode.addListener(_onScanFocusChange);
  }

  void _onScanFocusChange() {
    if (!_scanFocusNode.hasFocus) {
      _processScanInput(_scanController.text);
    }
  }

  void _processScanInput(String input) {
    if (input.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('扫描到: $input'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      _scanController.clear();
    }
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedItems.clear();
      }
    });
  }

  void _toggleItemSelection(int index) {
    setState(() {
      if (_selectedItems.contains(index)) {
        _selectedItems.remove(index);
      } else {
        _selectedItems.add(index);
      }
    });
  }

  Future<void> _showSubmitConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('确认提交'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('确定要提交采集结果吗？'),
              const SizedBox(height: 8),
              if (_selectedItems.isNotEmpty)
                Text(
                  '已选择 ${_selectedItems.length} 条记录',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _submitData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('确认提交'),
            ),
          ],
        );
      },
    );
  }

  void _submitData() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('提交成功'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: '撤销',
          onPressed: () {},
        ),
      ),
    );
  }

  Future<void> _showBatchOperationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('批量操作'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.blue),
                title: const Text('批量确认'),
                onTap: () {
                  Navigator.pop(context);
                  _batchConfirm();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('批量删除'),
                onTap: () {
                  Navigator.pop(context);
                  _batchDelete();
                },
              ),
              ListTile(
                leading: const Icon(Icons.download, color: Colors.green),
                title: const Text('导出数据'),
                onTap: () {
                  Navigator.pop(context);
                  _exportData();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('关闭'),
            ),
          ],
        );
      },
    );
  }

  void _batchConfirm() {
    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请先选择要操作的记录'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已确认 ${_selectedItems.length} 条记录'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _batchDelete() {
    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请先选择要删除的记录'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已删除 ${_selectedItems.length} 条记录'),
        duration: const Duration(seconds: 2),
      ),
    );
    setState(() {
      _selectedItems.clear();
      _isSelectionMode = false;
    });
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('数据导出中...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scanController.dispose();
    _scanFocusNode.removeListener(_onScanFocusChange);
    _scanFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isSelectionMode ? '已选择 ${_selectedItems.length} 项' : '平库下架采集',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_tabController.index == 0)
            TextButton(
              onPressed: _toggleSelectionMode,
              child: Text(
                _isSelectionMode ? '取消选择' : '批量操作',
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
            ),
          TextButton(
            onPressed: () {},
            child: const Text(
              '更多',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _scanController,
                            focusNode: _scanFocusNode,
                            decoration: const InputDecoration(
                              hintText: '请扫描或输入库位/物料',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            onSubmitted: _processScanInput,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _processScanInput(_scanController.text);
                          },
                          icon: const Icon(Icons.qr_code_scanner, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),

                  // Item details section
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildDetailItem('库位：', 'C2PP170302'),
                            ),
                            Expanded(
                              child: _buildDetailItem('库存：', '100'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDetailItem('采集数量：', '100'),
                            ),
                            Expanded(
                              child: _buildDetailItem('物料：', '10166834'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDetailItem('批次：', '20200519'),
                            ),
                            Expanded(
                              child: _buildDetailItem('序列：', '202005190055'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildDetailItem('名称：', '制动电阻 RGCB-3.5MJ-0.25M-J'),
                      ],
                    ),
                  ),
                  
                  // Tab section
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          TabBar(
                            controller: _tabController,
                            labelColor: Colors.blue,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: Colors.blue,
                            dividerColor: Colors.transparent,
                            tabs: const [
                              Tab(text: '任务列表'),
                              Tab(text: '正在采集'),
                            ],
                          ),
                          Container(
                            height: 400,
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                _buildTaskList(),
                                _buildCollectingList(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom buttons
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Colors.blue, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        '采集结果',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _showSubmitConfirmationDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        '提交',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    return Column(
      children: [
        if (_isSelectionMode && _selectedItems.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.blue[50],
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    '已选择',
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                  ),
                ),
                TextButton(
                  onPressed: _showBatchOperationDialog,
                  child: const Text('批量操作'),
                ),
              ],
            ),
          ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border(
              bottom: BorderSide(color: Colors.grey[200]!),
            ),
          ),
          child: Row(
            children: [
              if (_isSelectionMode)
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _selectedItems.length == 8,
                    onChanged: (value) {
                      if (value == true) {
                        _selectedItems = Set.from(List.generate(8, (i) => i));
                      } else {
                        _selectedItems.clear();
                      }
                      setState(() {});
                    },
                  ),
                ),
              if (_isSelectionMode) const SizedBox(width: 8),
              const Expanded(flex: 2, child: Text('物料编码', style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(flex: 2, child: _isSelectionMode ? const SizedBox.shrink() : const Text('库位', style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(child: _isSelectionMode ? const SizedBox.shrink() : const Text('任务数量', style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(child: _isSelectionMode ? const SizedBox.shrink() : const Text('采集数量', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
        ),
        
        Expanded(
          child: ListView.builder(
            itemCount: 8,
            itemBuilder: (context, index) {
              final isSelected = _selectedItems.contains(index);
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue[50] : Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[100]!, width: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    if (_isSelectionMode)
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: isSelected,
                          onChanged: (value) => _toggleItemSelection(index),
                        ),
                      ),
                    if (_isSelectionMode) const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF9800),
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.inventory_2,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                          Text('1000650${index + 1}'),
                        ],
                      ),
                    ),
                    Expanded(flex: 2, child: Text('C1PR56020${index + 1}')),
                    Expanded(child: Text('${100 + index}')),
                    Expanded(child: Text('${index * 10}')),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCollectingList() {
    return const Center(
      child: Text(
        '正在采集的任务',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    );
  }
}
