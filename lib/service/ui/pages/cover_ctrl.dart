import 'package:cyber_mobile/service/business/models/cover_page_model.dart';
import 'package:cyber_mobile/service/ui/pages/cover_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cover_ctrl.g.dart';

@riverpod
class CoverCtrl extends _$CoverCtrl {
  @override
  CoverState build() {
    return CoverState();
  }

  void selectCoverPage(CoverPageModel data) {
    state = state.copyWith(selectCoverPage: data);
  }
}
