class ThemeState {
  final String selectedModelId;

  ThemeState({this.selectedModelId = ''});

  ThemeState copyWith({String? selectedModelId}) {
    return ThemeState(selectedModelId: selectedModelId ?? this.selectedModelId);
  }
}
