import 'package:flutter/widgets.dart';
import 'res_kit.dart';
import 'res_kit_config.dart';

/// Wrap your MaterialApp / CupertinoApp with this once.
/// All ResKit values and extensions will work anywhere in the tree.
///
/// ```dart
/// ResponsiveKit(
///   config: ResKitConfig(
///     designs: ResKitDesignConfig(
///       mobile:  ResKitDesignSize.iphone14,
///       tablet:  ResKitDesignSize.ipadMini,
///       desktop: ResKitDesignSize.macbookAir,
///       web:     ResKitDesignSize.webBrowser,
///     ),
///   ),
///   child: MaterialApp(…),
/// )
/// ```
class ResponsiveKit extends StatefulWidget {
  const ResponsiveKit({super.key, required this.child, this.config = const ResKitConfig()});
  final ResKitConfig config;
  final Widget child;
  @override State<ResponsiveKit> createState() => _ResponsiveKitState();
}

class _ResponsiveKitState extends State<ResponsiveKit> with WidgetsBindingObserver {
  @override void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  @override void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override void didChangeMetrics() => setState(() {});
  @override void didChangeDependencies() { super.didChangeDependencies(); _update(); }
  @override void didUpdateWidget(covariant ResponsiveKit old) {
    super.didUpdateWidget(old);
    if (old.config != widget.config) _update();
  }
  void _update() => ResKit.init(mediaQuery: MediaQuery.of(context), config: widget.config);

  @override
  Widget build(BuildContext context) {
    ResKit.init(mediaQuery: MediaQuery.of(context), config: widget.config);
    return widget.child;
  }
}
