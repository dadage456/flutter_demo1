import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/collection_table.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

const Color _bgColor = Color(0xFFF6F6F6);

class WarehouseCollectionPage extends StatefulWidget {
  const WarehouseCollectionPage({super.key});

  @override
  State<WarehouseCollectionPage> createState() =>
      _WarehouseCollectionPageState();
}

class _WarehouseCollectionPageState extends State<WarehouseCollectionPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _scanController = TextEditingController();

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
      backgroundColor: _bgColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildScanInput(),
          const SizedBox(height: 0),
          _buildInfoCard(),
          const SizedBox(height: 1),
          _buildTabBar(),
          // Tab内容
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildTabContent(), _buildTabContent()],
            ),
          ),
          _buildBottomButtons(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF1976D2),
      centerTitle: true,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        '平库下架采集',
        textAlign: TextAlign.center,
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
    );
  }

  Widget _buildScanInput() {
    return Container(
      height: 44,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.vertical(bottom: Radius.circular(8.0)),
      ),
      child: TextField(
        controller: _scanController,
        decoration: InputDecoration(
          hintText: '请扫描或输入库位/物料',
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), // 输入框 8 圆角
            borderSide: BorderSide.none, // 去掉默认边框
          ),
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
      ),
      child: Column(
        children: [
          _buildInfoRow('库位：', 'C2PP170302', '库存：', '100'),
          _buildDottedDivider(),
          _buildInfoRow('采集数量：', '100', '物料：', '10166834'),
          _buildDottedDivider(),
          _buildInfoRow('批次：', '20200519', '序列：', '202005190055'),
          _buildDottedDivider(),
          _buildInfoRow('名称：', '制动电阻 RGCB-3.5MJ-0.25M-J', '', ''),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      height: 44,
      child: TabBar(
        dividerHeight: 0,
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
    );
  }

  Widget _buildTabContent() {
    return CollectionTable();
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(color: Colors.white),
      height: 40,
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: _buildOutlinedButtonStyle(),
              child: const Text('采集结果'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: _buildButtonStyle(),
              child: const Text('提交'),
            ),
          ),
        ],
      ),
    );
  }

  ButtonStyle _buildOutlinedButtonStyle() {
    return OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFF1976D2), // 文字 + 图标色
      backgroundColor: Colors.transparent, // 背景透明
      side: const BorderSide(color: Color(0xFF1976D2)), // 蓝色边框
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.zero,
    );
  }

  ButtonStyle _buildButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF1976D2),
      foregroundColor: Colors.white,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _buildInfoRow(
    String label1,
    String value1,
    String label2,
    String value2,
  ) {
    return Container(
      height: 32,
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 10,
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(2), // 圆角半径，数值越大越圆
                  ),
                ),
                Text(
                  label1,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  value1,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          if (label2.isNotEmpty)
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 10,
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(2), // 圆角半径，数值越大越圆
                    ),
                  ),
                  Text(
                    label2,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    value2,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
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
                decoration: BoxDecoration(color: Color(0xFF0067FC)),
              ),
            );
          }),
        );
      },
    );
  }
}
