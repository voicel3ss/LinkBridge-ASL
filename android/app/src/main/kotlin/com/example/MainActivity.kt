package your.package.name

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "asl_channel"
    private var currentLetter: String = "Initializing ML…"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // TODO:
        // Hook camera frames → HandDetector.detect(bitmap)
        // Update currentLetter with ML output

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getASLLetter") {
                    result.success(currentLetter)
                } else {
                    result.notImplemented()
                }
            }
    }
}
