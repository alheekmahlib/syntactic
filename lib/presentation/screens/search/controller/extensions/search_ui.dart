import 'dart:convert';

import '/presentation/screens/search/controller/search_controller.dart';
import '../../../../../core/utils/constants/shared_preferences_constants.dart';
import '../../../home/data/models/time_now.dart';
import '../../data/models/search_model.dart';

extension SearchUi on SearchControllers {
  void clearList() {
    if (state.tabController.index == 1) {
      state.pagingController.itemList!.clear();
    }
    state.currentQuery.value = '';
    state.searchResults.clear();
    state.searchController.clear();
    update();
  }

  void loadSearchHistory() {
    var historyData = state.box.read(SEARCH_HISTORY);
    if (historyData is List) {
      List<Map<String, dynamic>?> rawHistory = historyData
          .map((item) {
            if (item is String) {
              try {
                return jsonDecode(item) as Map<String, dynamic>;
              } catch (e) {
                return null;
              }
            }
            return null;
          })
          .where((item) => item != null)
          .toList();
      state.searchHistory.value =
          rawHistory.map((item) => SearchItem.fromMap(item!)).toList();
    } else {
      state.searchHistory.value = [];
    }
  }

  void addSearchItem(String query) {
    TimeNow timeNow = TimeNow();

    SearchItem newItem = SearchItem(query, timeNow.lastTime);
    state.searchHistory.removeWhere((item) => item.query == query);
    state.searchHistory.insert(0, newItem);
    state.box.write(SEARCH_HISTORY,
        state.searchHistory.map((item) => jsonEncode(item.toMap())).toList());
  }

  void removeSearchItem(SearchItem item) {
    state.searchHistory.remove(item);
    state.box.write(SEARCH_HISTORY,
        state.searchHistory.map((item) => jsonEncode(item.toMap())).toList());
  }
}
