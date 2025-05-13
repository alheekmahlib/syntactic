import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/presentation/screens/audio_player/extensions/audio_download_extension.dart';
import '../../all_books/controller/audio/audio_controller.dart';

/// ويدجت لعرض تقدم تنزيل الملفات الصوتية
/// Widget to show audio file download progress
class AudioDownloadProgress extends StatelessWidget {
  final int audioId;

  const AudioDownloadProgress({
    super.key,
    required this.audioId,
  });

  @override
  Widget build(BuildContext context) {
    final audioCtrl = AudioController.instance;

    return Obx(() {
      // المؤشر -1 محجوز للتنزيل الكامل للفصل
      // Index -1 is reserved for full chapter download
      final isDownloading = audioId == -1
          ? audioCtrl.state.isDownloadingChapter.value
          : audioCtrl.state.downloading[audioId] == true;

      final progress = audioCtrl.state.downloadProgress[audioId] ?? 0.0;

      if (!isDownloading) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              audioId == -1 ? 'downlodingFullBook'.tr : 'downlodingAudio'.tr,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 14,
                fontFamily: 'kufi',
              ),
            ),
            const SizedBox(height: 8.0),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Theme.of(context).colorScheme.surface,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 12,
                    fontFamily: 'kufi',
                  ),
                ),
                TextButton.icon(
                  onPressed: () => audioCtrl.cancelDownload(audioId),
                  icon: Icon(
                    Icons.cancel_rounded,
                    color: Theme.of(context).colorScheme.surface,
                    size: 16,
                  ),
                  label: Text(
                    'cancel'.tr,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontSize: 12,
                      fontFamily: 'kufi',
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size(10, 10),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
