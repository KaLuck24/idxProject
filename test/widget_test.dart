import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/main.dart'; // Ganti dengan nama proyekmu

void main() {
  testWidgets('Aplikasi kustom menampilkan teks dengan benar',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our custom text is displayed.
    expect(find.text('Selamat datang di aplikasi saya!'), findsOneWidget);
  });
}
