import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marquee/marquee.dart';

/* ---------------- 入口 ---------------- */
class WMSHomePage extends StatelessWidget {
  const WMSHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Stack(children: const [_TopBackground(), _MainContent()]),
      ),
    );
  }
}

/* ---------------- 主体 ---------------- */
class _MainContent extends StatelessWidget {
  const _MainContent();

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Column(
        children: [
          _Header(),
          SizedBox(height: 10),
          _NotificationSection(),
          SizedBox(height: 18),
          _FunctionGrid(),
        ],
      ),
    );
  }
}

/* ---------------- 顶部背景 ---------------- */
class _TopBackground extends StatelessWidget {
  const _TopBackground();

  static const double _height = 256;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      width: double.infinity,
      child: Stack(
        children: [
          SvgPicture.asset('assets/images/home_top_bg.svg', fit: BoxFit.fill),
          Positioned(
            top: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/images/home_top_circle.svg',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

/* ---------------- 头部 ---------------- */
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.logout, color: Colors.white, size: 24),
          ),
        ),
        const Center(
          child: Text(
            '金风科技WMS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            children: [
              const Icon(Icons.volume_up, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 20,
                  child: Marquee(
                    text: '公告：重大喜讯，金风科技wms上新了',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                    ),
                    scrollAxis: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    blankSpace: 20.0,
                    velocity: 30.0,
                    pauseAfterRound: Duration(seconds: 2),
                    showFadingOnlyWhenScrolling: true,
                    fadingEdgeStartFraction: 0.1,
                    fadingEdgeEndFraction: 0.1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/* ---------------- 通知区 ---------------- */
class _NotificationSection extends StatelessWidget {
  const _NotificationSection();

  static const List<NotificationItem> _items = [
    NotificationItem('采集异常', Icons.warning, Color(0xFFFF7637)),
    NotificationItem('接口异常', Icons.link_off, Color(0xFFFF7637)),
    NotificationItem('我的消息', Icons.message, Color(0xFF0099F9)),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      margin: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _items.map((e) => _item(e, context)).toList(),
      ),
    );
  }

  Widget _item(NotificationItem e, BuildContext context) => Expanded(
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('点击了 ${e.title}'),
            duration: const Duration(seconds: 2),
          ),
        ),
        borderRadius: BorderRadius.circular(8),
        splashColor: e.color.withValues(alpha: 0.3),
        highlightColor: e.color.withValues(alpha: 0.2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _iconWithBadge(e),
            const SizedBox(height: 8),
            Text(
              e.title,
              style: const TextStyle(color: Color(0xFF323337), fontSize: 14),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _iconWithBadge(NotificationItem e) => Stack(
    clipBehavior: Clip.none,
    children: [
      Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: e.color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(e.icon, color: Colors.white, size: 28),
      ),
      Positioned(
        top: -8,
        right: -8,
        child: Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            color: const Color(0xFFFF5304),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Center(
            child: Text(
              '99',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

/* ---------------- 功能网格 ---------------- */
class _FunctionGrid extends StatelessWidget {
  const _FunctionGrid();

  static const List<FunctionItem> _list = [
    FunctionItem(
      '到货接收',
      'assets/images/home_icon_recieved.svg',
      showBadge: true,
    ),
    FunctionItem('立库组盘', 'assets/images/home_icon_ palletizing.svg'),
    FunctionItem('平库入库', 'assets/images/home_icon_ inbound.svg'),
    FunctionItem('平库出库', 'assets/images/home_icon_ outbound.svg'),
    FunctionItem('在线拣选', 'assets/images/home_icon_online_picking.svg'),
    FunctionItem('拉式发料', 'assets/images/home_icon_pull_feeding.svg'),
    FunctionItem('平库盘点', 'assets/images/home_icon_floor_count.svg'),
    FunctionItem('平库移库', 'assets/images/home_icon_floor_to_floor.svg'),
    FunctionItem('立库盘点', 'assets/images/home_icon_count.svg'),
    FunctionItem('库存查询', 'assets/images/home_icon_search.svg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '功能',
            style: TextStyle(
              color: Color(0xFF374150),
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.85,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _list.length,
            itemBuilder: (_, i) => _card(_list[i], context),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _card(FunctionItem f, BuildContext context) => Container(
    height: 60,
    decoration: BoxDecoration(
      color: const Color(0xFFF3F4F6),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('点击了 ${f.title}'),
            duration: const Duration(seconds: 2),
          ),
        ),
        borderRadius: BorderRadius.circular(8),
        splashColor: Colors.blue.withValues(alpha: 0.3),
        highlightColor: Colors.blue.withValues(alpha: 0.2),
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: SvgPicture.asset(f.iconPath, fit: BoxFit.contain),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      f.title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              if (f.showBadge)
                Positioned(
                  top: -8,
                  right: -8,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5304),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

/* ---------------- 数据模型 ---------------- */
class NotificationItem {
  final String title;
  final IconData icon;
  final Color color;
  const NotificationItem(this.title, this.icon, this.color);
}

class FunctionItem {
  final String title;
  final String iconPath;
  final bool showBadge;
  const FunctionItem(this.title, this.iconPath, {this.showBadge = false});
}
