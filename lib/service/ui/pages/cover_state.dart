import 'package:cyber_mobile/service/business/models/cover_page_model.dart';

class CoverState {
  final List<CoverPageModel> coverPages;
  final CoverPageModel selectCoverPage;

  CoverState({
    this.coverPages = const [
      CoverPageModel(
        id: '1',
        title: 'N/A',
        ownerId: 'N/A',
        content: 'N/A',
        path: 'N/A',
      ),
      CoverPageModel(
        id: '2',
        title: 'N/A',
        ownerId: 'N/A',
        content: 'N/A',
        path: 'N/A',
      ),
    ],
    this.selectCoverPage = const CoverPageModel(
      id: 'N/A',
      title: 'N/A',
      ownerId: 'N/A',
      content: 'N/A',
      path: 'N/A',
    ),
  });

  CoverState copyWith({
    List<CoverPageModel>? coverPages,
    CoverPageModel? selectCoverPage,
  }) {
    return CoverState(
      coverPages: coverPages ?? this.coverPages,
      selectCoverPage: selectCoverPage ?? this.selectCoverPage,
    );
  }
}
