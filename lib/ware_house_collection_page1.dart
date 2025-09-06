import 'package:flutter/material.dart';

class WarehouseCollectionPage extends StatefulWidget {
  const WarehouseCollectionPage({Key? key}) : super(key: key);

  @override
  State<WarehouseCollectionPage> createState() =>
      _WarehouseCollectionPageState();
}

class _WarehouseCollectionPageState extends State<WarehouseCollectionPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _scanController = TextEditingController();

  // 示例数据
  final List<CollectionItem> items = List.generate(
    10,
    (index) => CollectionItem(
      materialCode: '10006503',
      location: 'C1PR560206',
      taskQuantity: 100,
      collectedQuantity: 0,
      isSelected: index == 0 || index == 5 || index == 6, // 部分选中状态
    ),
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '平库下架采集',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              '更多',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 扫描输入区域
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _scanController,
              decoration: const InputDecoration(
                hintText: '请扫描或输入库位/物料',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),

          // 信息卡片区域
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildInfoRow('库位：', 'C2PP170302', '库存：', '100'),
                const SizedBox(height: 8),
                _buildDottedDivider(),
                _buildInfoRow('采集数量：', '100', '物料：', '10166834'),
                const SizedBox(height: 8),
                _buildDottedDivider(),
                _buildInfoRow('批次：', '20200519', '序列：', '202005190055'),
                const SizedBox(height: 8),
                _buildDottedDivider(),
                _buildInfoRow('名称：', '制动电阻 RGCB-3.5MJ-0.25M-J', '', ''),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Tab栏
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF1976D2),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF1976D2),
              indicatorWeight: 3,
              tabs: const [
                Tab(text: '任务列表'),
                Tab(text: '正在采集'),
              ],
            ),
          ),

          // 列表内容
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  // 表头
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                    ),
                    child: const Row(
                      children: [
                        SizedBox(width: 40),
                        Expanded(
                          flex: 2,
                          child: Text(
                            '物料编码',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            '库位',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '任务数量',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '采集数量',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 列表项
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: item.isSelected
                                ? Colors.blue[50]
                                : Colors.white,
                            border: Border(
                              bottom: BorderSide(color: Colors.grey[200]!),
                            ),
                          ),
                          child: ListTile(
                            leading: Checkbox(
                              value: item.isSelected,
                              onChanged: (value) {
                                setState(() {
                                  item.isSelected = value ?? false;
                                });
                              },
                              activeColor: const Color(0xFF1976D2),
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(item.materialCode),
                                ),
                                Expanded(flex: 2, child: Text(item.location)),
                                Expanded(
                                  child: Text(item.taskQuantity.toString()),
                                ),
                                Expanded(
                                  child: Text(
                                    item.collectedQuantity.toString(),
                                  ),
                                ),
                              ],
                            ),
                            contentPadding: const EdgeInsets.only(right: 16),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 底部按钮
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // 采集结果逻辑
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      '采集结果',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // 提交逻辑
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label1,
    String value1,
    String label2,
    String value2,
  ) {
    return Row(
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label1,
                  style: const TextStyle(
                    color: Color(0xFF1976D2),
                    fontSize: 14,
                  ),
                ),
                TextSpan(
                  text: value1,
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        if (label2.isNotEmpty)
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: label2,
                    style: const TextStyle(
                      color: Color(0xFF1976D2),
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: value2,
                    style: const TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // Helper function to create the dotted divider
  Widget _buildDottedDivider() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 5.0;
        const dashSpace = 3.0;
        final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return const SizedBox(
              width: dashWidth,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.grey),
              ),
            );
          }),
        );
      },
    );
  }
}

class CollectionItem {
  final String materialCode;
  final String location;
  final int taskQuantity;
  final int collectedQuantity;
  bool isSelected;

  CollectionItem({
    required this.materialCode,
    required this.location,
    required this.taskQuantity,
    required this.collectedQuantity,
    this.isSelected = false,
  });
}
