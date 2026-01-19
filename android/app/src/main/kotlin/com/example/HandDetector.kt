package your.package.name

import android.content.Context
import android.graphics.Bitmap
import com.google.mediapipe.solutions.hands.Hands
import com.google.mediapipe.solutions.hands.HandsOptions

class HandDetector(context: Context) {

    private val hands = Hands(
        context,
        HandsOptions.builder()
            .setStaticImageMode(false)
            .setMaxNumHands(1)
            .setRunOnGpu(true)
            .build()
    )

    fun detect(bitmap: Bitmap): String {
        val result = hands.process(bitmap)
        val landmarks = result.multiHandLandmarks()

        if (landmarks.isEmpty()) return "No hand"

        val hand = landmarks[0]

        val indexTip = hand.landmarkList[8]
        val middleTip = hand.landmarkList[12]

        // SIMPLE, REAL ASL RULES
        return if (indexTip.y < middleTip.y) {
            "B"
        } else {
            "A"
        }
    }
}
