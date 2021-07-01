
class Utils {
  /// to get [username] of the [user] from the email provided
  static String getUsername(String email) {
    return "${email.split('@')[0]}";
  }
}
