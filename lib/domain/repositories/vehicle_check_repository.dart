import '../entities/vehicle_check_entity.dart';

abstract class VehicleCheckRepository {
  Future<VehicleCheckResult> performFullCheck(String registrationNumber);
  Future<VehicleCheckResult> performBasicCheck(String registrationNumber);
  Future<List<VehicleCheckResult>> getSavedChecks();
  Future<void> saveCheck(VehicleCheckResult check);
  Future<void> deleteCheck(String registrationNumber);
}
