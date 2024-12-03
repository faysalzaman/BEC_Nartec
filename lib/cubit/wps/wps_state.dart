import 'package:bec_app/model/attendance/WpsModel.dart';
import 'package:bec_app/model/attendance/locationModel.dart';

abstract class WpsState {}

class WpsInitial extends WpsState {}

class WpsLoading extends WpsState {}

class LocationLoading extends WpsState {}

class LocationSuccess extends WpsState {
  final List<LocationModel> locations;

  LocationSuccess(this.locations);
}

class WpsSuccess extends WpsState {
  final List<WpsModel> wps;

  WpsSuccess(this.wps);
}

class CostCodeSuccess extends WpsState {
  final List<WpsModel> costCodes;

  CostCodeSuccess(this.costCodes);
}

class WpsError extends WpsState {
  final String error;

  WpsError(this.error);
}

class LocationError extends WpsState {
  final String error;

  LocationError(this.error);
}
