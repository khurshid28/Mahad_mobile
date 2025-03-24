
import 'package:test_app/export_files.dart';
import 'package:test_app/widgets/network/network.dart';

class MaterialAppCustomBuilder {
  MaterialAppCustomBuilder._();
  static Widget builder(BuildContext context, Widget? child) {
    return MediaQuery(
      // ignore: deprecated_member_use
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: CheckNetworkWidget(
        child: child ??
            const Scaffold(
              body: Center(
                child: Text("Page builder Error"),
              ),
            ),
      ),
    );
  }
}
