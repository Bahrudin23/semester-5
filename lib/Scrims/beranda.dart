import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class beranda extends StatefulWidget {
  const beranda({super.key});

  @override
  State<beranda> createState() => _berandaState();
}

class _berandaState extends State<beranda> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF009B97),
        foregroundColor: Colors.white,
        title: const Text("Beranda", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
        centerTitle: false,
      ),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ActionTile(
                label: "Bahan Baku Bangunan",
                onTap: () {},
              ),
              const SizedBox(height: 16),
              ActionTile(
                label: "Kelistrikan",
                onTap: () {},
              ),
              const SizedBox(height: 16),
              ActionTile(
                label: "Keramik",
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class ActionTile extends StatelessWidget {
  const ActionTile({
    super.key,
    required this.label,
    this.onTap,
    this.background,
  });

  final String label;
  final VoidCallback? onTap;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: background ?? const Color(0xFFF5F6F7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE1E4E8)),
          boxShadow: const [
            BoxShadow(blurRadius: 8, offset: Offset(0, 3), color: Colors.black12),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}