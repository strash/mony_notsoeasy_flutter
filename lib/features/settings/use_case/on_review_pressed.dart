import "package:flutter/widgets.dart";
import "package:mony_app/app/app_review_service/app_review_service.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:provider/provider.dart";

final class OnReviewPressed extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [_]) async {
    final reviewService = context.read<AppReviewService>();

    await reviewService.requestImmediateReview();
  }
}
