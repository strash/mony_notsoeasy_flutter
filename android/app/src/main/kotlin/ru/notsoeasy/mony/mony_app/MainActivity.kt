package ru.notsoeasy.mony.mony_app

import com.google.android.play.core.review.ReviewManagerFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {
    private val channelName = "strash.mony/review"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler {
                call, result ->
            if (call.method == "requestReview") {
                requestReview(result)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun requestReview(result: MethodChannel.Result): Unit {
        val manager = ReviewManagerFactory.create(context)
        val request = manager.requestReviewFlow()
        request.addOnCompleteListener { task ->
            if (task.isSuccessful) {
                val reviewInfo = task.result
                val flow = manager.launchReviewFlow(activity, reviewInfo)
                flow.addOnCompleteListener { _ -> }
                result.success(null)
            } else {
                result.error("SOME_SHIT", "Some shit happened", null)
            }
        }
    }
}

