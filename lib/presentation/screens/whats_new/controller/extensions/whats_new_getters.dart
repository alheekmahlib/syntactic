import '/presentation/screens/whats_new/controller/whats_new_controller.dart';
import '../../../../../core/utils/constants/shared_preferences_constants.dart';

extension WhatsNewGetters on WhatsNewController {
  /// -------- [Getters] --------
  void saveLastShownIndex(int index) =>
      state.box.write(LAST_SHOWN_UPDATE_INDEX, index);

  int getLastShownIndex() => state.box.read(LAST_SHOWN_UPDATE_INDEX) ?? 0;
}
