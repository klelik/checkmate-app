import '../../domain/entities/vehicle_check_entity.dart';
import '../../domain/repositories/vehicle_check_repository.dart';
import 'mock_vehicle_data.dart';

class MockVehicleService implements VehicleCheckRepository {
  final _vehicles = MockVehicleData.getVehicles();
  final List<VehicleCheckResult> _savedChecks = [];

  @override
  Future<VehicleCheckResult> performFullCheck(String registrationNumber) async {
    // Simulate API delay 800-1500ms
    await Future.delayed(
      Duration(
        milliseconds: 800 + (registrationNumber.hashCode.abs() % 700),
      ),
    );
    final reg = registrationNumber.replaceAll(' ', '').toUpperCase();
    // Try to find matching reg, or return clean default vehicle
    final result = _vehicles.entries.firstWhere(
      (e) => e.key.replaceAll(' ', '') == reg,
      orElse: () => _vehicles.entries.first,
    );
    return result.value;
  }

  @override
  Future<VehicleCheckResult> performBasicCheck(
    String registrationNumber,
  ) async {
    // Same but faster - returns limited data
    await Future.delayed(const Duration(milliseconds: 500));
    return performFullCheck(registrationNumber);
  }

  @override
  Future<List<VehicleCheckResult>> getSavedChecks() async {
    return _savedChecks;
  }

  @override
  Future<void> saveCheck(VehicleCheckResult check) async {
    _savedChecks.removeWhere(
      (c) => c.registrationNumber == check.registrationNumber,
    );
    _savedChecks.insert(0, check);
  }

  @override
  Future<void> deleteCheck(String registrationNumber) async {
    _savedChecks.removeWhere(
      (c) => c.registrationNumber == registrationNumber,
    );
  }
}
