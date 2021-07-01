import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';

/// show loading dialog box to user
showLoading() => BotToast.showLoading();

/// remove the loading dialog
dismissLoading() => BotToast.closeAllLoading();
