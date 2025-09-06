import 'package:flutter/material.dart';

class InventoryCollectionPage extends StatefulWidget {
  const InventoryCollectionPage({Key? key}) : super(key: key);

  @override
  State<InventoryCollectionPage> createState() =>
      _InventoryCollectionPageState();
}

class _InventoryCollectionPageState extends State<InventoryCollectionPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<bool> _selectedItems = List.generate(10, (index) => false);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // 预设选中状态
    _selectedItems[0] = true;
    _selectedItems[1] = true;
    _selectedItems[5] = true;
    _selectedItems[6] = true;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E88E5),
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
          // 顶部信息提示
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: const Text(
              '请扫描或输入库位/物料',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),

          // 信息卡片
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildInfoRow('库位：C2PP170302', '库存：100'),
                const SizedBox(height: 12),
                _buildInfoRow('采集数量：100', '物料：10166834'),
                const SizedBox(height: 12),
                _buildInfoRow('批次：20200519', '序列：20200519055'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.blue[700]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '名称：制动电阻 RGCB-3.5MJ-0.25M-J',
                        style: TextStyle(fontSize: 14, color: Colors.blue[700]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Tab栏
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF1E88E5),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF1E88E5),
              indicatorWeight: 3,
              tabs: const [
                Tab(text: '任务列表'),
                Tab(text: '正在采集'),
              ],
            ),
          ),

          // Tab内容
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildTaskList(), _buildCollectingList()],
            ),
          ),

          // 底部按钮
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E88E5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      '采集结果',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E88E5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      '提交',
                      style: TextStyle(fontSize: 16, color: Colors.white),
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

  Widget _buildInfoRow(String left, String right) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: Colors.blue[700]),
              const SizedBox(width: 4),
              Text(
                left,
                style: TextStyle(fontSize: 14, color: Colors.blue[700]),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: Colors.blue[700]),
              const SizedBox(width: 4),
              Text(
                right,
                style: TextStyle(fontSize: 14, color: Colors.blue[700]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTaskList() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // 表头
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 40),
                const Expanded(
                  flex: 2,
                  child: Text(
                    '物料编码',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
                const Expanded(
                  flex: 2,
                  child: Text(
                    '库位',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
                const Expanded(
                  child: Text(
                    '任务数量',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
                const Expanded(
                  child: Text(
                    '采集数量',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
          // 列表内容
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: index % 2 == 0 ? Colors.white : Colors.grey[50],
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!, width: 0.5),
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedItems[index] = !_selectedItems[index];
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 40,
                            child: Checkbox(
                              value: _selectedItems[index],
                              onChanged: (value) {
                                setState(() {
                                  _selectedItems[index] = value ?? false;
                                });
                              },
                              activeColor: const Color(0xFF1E88E5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 2,
                            child: Text(
                              '10006503',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 2,
                            child: Text(
                              'C1PR560206',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Text(
                              '100',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Text(
                              '0',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectingList() {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Text(
          '暂无正在采集的任务',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}
