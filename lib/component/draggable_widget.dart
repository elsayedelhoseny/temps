import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../utils/cacheHelper/cache_helper.dart';
import '../utils/constant.dart';

class DraggableCustomWidget extends StatefulWidget {
  final Widget child;

  DraggableCustomWidget({required this.child});

  @override
  _DraggableCustomWidgetState createState() => _DraggableCustomWidgetState();
}

class _DraggableCustomWidgetState extends State<DraggableCustomWidget>
    with SingleTickerProviderStateMixin {
  Offset position = Offset(whatsappIconOffsetX!, whatsappIconOffsetY!);
  List<_Particle> _particles = [];
  late Ticker _ticker;
  final GlobalKey _childKey = GlobalKey();
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    print("initX $whatsappIconOffsetX");
    print("initY $whatsappIconOffsetY");

    position = Offset(whatsappIconOffsetX!, whatsappIconOffsetY!);

    _ticker = Ticker((_) {
      _updateParticles();
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _updateParticles() {
    setState(() {
      _particles.removeWhere((p) => p.lifespan <= 0);
      for (var p in _particles) {
        p.update();
      }
    });
  }

  void _addParticle(Offset dragPosition) {
    final renderBox =
        _childKey.currentContext?.findRenderObject() as RenderBox?;
    final size = renderBox?.size ?? Size.zero;

    final centerOffset = position + Offset(size.width / 2, size.height * 0.9);

    _particles.add(
      _Particle(
        position: centerOffset,
        velocity: Offset(
          (random.nextDouble() - 0.5) * 4,
          (random.nextDouble() - 0.5) * 4,
        ),
        color: Colors.greenAccent,
        lifespan: 50,
      ),
    );
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    setState(() {
      position += details.delta;
      _addParticle(position);
    });
  }

  void _handlePanEnd(DragEndDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final screenSize = box.size;
    final renderBox =
        _childKey.currentContext?.findRenderObject() as RenderBox?;
    final size = renderBox?.size ?? Size.zero;

    double newX = position.dx.clamp(0, screenSize.width - size.width);
    double newY = position.dy.clamp(0, screenSize.height - size.height);

    setState(() {
      position = Offset(newX, newY);
    });

    whatsappIconOffsetX = newX;
    whatsappIconOffsetY = newY;

    CacheHelper.saveData(key: 'whatsappIconOffsetX', value: newX);
    CacheHelper.saveData(key: 'whatsappIconOffsetY', value: newY);

    print("Saved X: $newX");
    print("Saved Y: $newY");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: position.dx,
          top: position.dy,
          child: GestureDetector(
            onPanUpdate: _handlePanUpdate,
            onPanEnd: _handlePanEnd,
            child: Container(
              key: _childKey,
              child: widget.child,
            ),
          ),
        ),
        IgnorePointer(
          child: CustomPaint(
            painter: _ParticlePainter(_particles),
            child: Container(),
          ),
        ),
      ],
    );
  }
}

class _Particle {
  Offset position;
  Offset velocity;
  Color color;
  int lifespan;

  _Particle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.lifespan,
  });

  void update() {
    position += velocity;
    lifespan--;
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;

  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      final paint = Paint()
        ..color = p.color.withValues(alpha: p.lifespan / 20)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(p.position, 4, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
