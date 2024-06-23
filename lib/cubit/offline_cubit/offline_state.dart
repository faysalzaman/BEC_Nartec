abstract class OfflineState {}

class OfflineInitial extends OfflineState {}

class OfflineLoading extends OfflineState {}

class OfflineLoaded extends OfflineState {}

class OfflineError extends OfflineState {
  final String error;

  OfflineError(this.error);
}
