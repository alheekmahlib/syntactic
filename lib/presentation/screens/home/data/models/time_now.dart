class TimeNow {
  DateTime now = DateTime.now();
  late String lastTime;

  TimeNow() {
    lastTime =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }
}
