//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <awesome_notifications/awesome_notifications_plugin.h>
#include <awesome_notifications_core/awesome_notifications_core_plugin.h>
#include <sqlite3_flutter_libs/sqlite3_flutter_libs_plugin.h>
#include <url_launcher_linux/url_launcher_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) awesome_notifications_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "AwesomeNotificationsPlugin");
  awesome_notifications_plugin_register_with_registrar(awesome_notifications_registrar);
  g_autoptr(FlPluginRegistrar) awesome_notifications_core_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "AwesomeNotificationsCorePlugin");
  awesome_notifications_core_plugin_register_with_registrar(awesome_notifications_core_registrar);
  g_autoptr(FlPluginRegistrar) sqlite3_flutter_libs_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "Sqlite3FlutterLibsPlugin");
  sqlite3_flutter_libs_plugin_register_with_registrar(sqlite3_flutter_libs_registrar);
  g_autoptr(FlPluginRegistrar) url_launcher_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "UrlLauncherPlugin");
  url_launcher_plugin_register_with_registrar(url_launcher_linux_registrar);
}
