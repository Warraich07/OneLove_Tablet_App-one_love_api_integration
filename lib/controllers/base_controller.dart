import '../api_services/api_exceptions.dart';
import '../utils/custom_dialogbox.dart';


class BaseController {
  BaseController._();

  static final BaseController _instance = BaseController._();
  static BaseController get instance => _instance;
  void handleError(error) {
    hideLoading();
    if (error is BadRequestException) {
      var message = error.message;
      CustomDialog.showErrorDialog(description: message);
    } else if (error is FetchDataException) {
      var message = error.message;
      CustomDialog.showErrorDialog(description: message);
    } else if (error is ApiNotRespondingException) {
      CustomDialog.showErrorDialog(
          description: 'Oops! It took longer to respond.');
    }
  }

  showLoading([String? message]) {
    CustomDialog.showLoading(message);
  }

  hideLoading() {
    CustomDialog.hideLoading();
  }
}
