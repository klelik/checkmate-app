import 'package:equatable/equatable.dart';

// ---------------------------------------------------------------------------
// Top-level result
// ---------------------------------------------------------------------------

class VehicleCheckResult extends Equatable {
  final String registrationNumber;
  final String make;
  final String model;
  final int year;
  final String colour;
  final String fuelType;
  final int engineSizeCC;
  final String bodyType;
  final String transmission;
  final int overallRiskScore; // 0-100
  final String riskCategory; // "Clear", "Caution", "High Risk", "Critical"
  final String aiSummary;
  final StolenCheck stolenCheck;
  final FinanceCheck financeCheck;
  final WriteOffCheck writeOffCheck;
  final MileageCheck mileageCheck;
  final KeeperHistory keeperHistory;
  final PlateChangeHistory plateChanges;
  final ImportExportCheck importExport;
  final ScrappedCheck scrappedCheck;
  final V5CCheck v5cCheck;
  final MOTHistory motHistory;
  final TaxStatus taxStatus;
  final String co2Emissions;
  final String euroStatus;
  final bool ulezCompliant;
  final VehicleValuation valuation;
  final SafetyRecall safetyRecall;
  final int euroNcapRating;
  final VehicleSpecification specs;

  const VehicleCheckResult({
    required this.registrationNumber,
    required this.make,
    required this.model,
    required this.year,
    required this.colour,
    required this.fuelType,
    required this.engineSizeCC,
    required this.bodyType,
    required this.transmission,
    required this.overallRiskScore,
    required this.riskCategory,
    required this.aiSummary,
    required this.stolenCheck,
    required this.financeCheck,
    required this.writeOffCheck,
    required this.mileageCheck,
    required this.keeperHistory,
    required this.plateChanges,
    required this.importExport,
    required this.scrappedCheck,
    required this.v5cCheck,
    required this.motHistory,
    required this.taxStatus,
    required this.co2Emissions,
    required this.euroStatus,
    required this.ulezCompliant,
    required this.valuation,
    required this.safetyRecall,
    required this.euroNcapRating,
    required this.specs,
  });

  @override
  List<Object?> get props => [
        registrationNumber,
        make,
        model,
        year,
        colour,
        fuelType,
        engineSizeCC,
        bodyType,
        transmission,
        overallRiskScore,
        riskCategory,
        aiSummary,
        stolenCheck,
        financeCheck,
        writeOffCheck,
        mileageCheck,
        keeperHistory,
        plateChanges,
        importExport,
        scrappedCheck,
        v5cCheck,
        motHistory,
        taxStatus,
        co2Emissions,
        euroStatus,
        ulezCompliant,
        valuation,
        safetyRecall,
        euroNcapRating,
        specs,
      ];
}

// ---------------------------------------------------------------------------
// Stolen
// ---------------------------------------------------------------------------

class StolenCheck extends Equatable {
  final bool isStolen;
  final String? dateReported;
  final String? policeForce;
  final String? referenceNumber;

  const StolenCheck({
    required this.isStolen,
    this.dateReported,
    this.policeForce,
    this.referenceNumber,
  });

  @override
  List<Object?> get props => [
        isStolen,
        dateReported,
        policeForce,
        referenceNumber,
      ];
}

// ---------------------------------------------------------------------------
// Finance
// ---------------------------------------------------------------------------

class FinanceCheck extends Equatable {
  final bool hasFinance;
  final String? agreementType;
  final String? financeCompany;
  final double? amountOutstanding;
  final String? startDate;
  final String? contactNumber;

  const FinanceCheck({
    required this.hasFinance,
    this.agreementType,
    this.financeCompany,
    this.amountOutstanding,
    this.startDate,
    this.contactNumber,
  });

  @override
  List<Object?> get props => [
        hasFinance,
        agreementType,
        financeCompany,
        amountOutstanding,
        startDate,
        contactNumber,
      ];
}

// ---------------------------------------------------------------------------
// Write-off
// ---------------------------------------------------------------------------

class WriteOffCheck extends Equatable {
  final bool isWriteOff;
  final String? category; // S, N, A, B
  final String? date;
  final String? insurer;
  final String? damageArea;

  const WriteOffCheck({
    required this.isWriteOff,
    this.category,
    this.date,
    this.insurer,
    this.damageArea,
  });

  @override
  List<Object?> get props => [
        isWriteOff,
        category,
        date,
        insurer,
        damageArea,
      ];
}

// ---------------------------------------------------------------------------
// Mileage
// ---------------------------------------------------------------------------

class MileageReading extends Equatable {
  final String date;
  final int mileage;
  final String source;

  const MileageReading({
    required this.date,
    required this.mileage,
    required this.source,
  });

  @override
  List<Object?> get props => [date, mileage, source];
}

class MileageCheck extends Equatable {
  final bool hasDiscrepancy;
  final List<MileageReading> readings;
  final int averagePerYear;

  const MileageCheck({
    required this.hasDiscrepancy,
    required this.readings,
    required this.averagePerYear,
  });

  @override
  List<Object?> get props => [hasDiscrepancy, readings, averagePerYear];
}

// ---------------------------------------------------------------------------
// Keeper history
// ---------------------------------------------------------------------------

class KeeperChange extends Equatable {
  final String date;
  final String duration;

  const KeeperChange({
    required this.date,
    required this.duration,
  });

  @override
  List<Object?> get props => [date, duration];
}

class KeeperHistory extends Equatable {
  final int keeperCount;
  final List<KeeperChange> changes;

  const KeeperHistory({
    required this.keeperCount,
    required this.changes,
  });

  @override
  List<Object?> get props => [keeperCount, changes];
}

// ---------------------------------------------------------------------------
// Plate changes
// ---------------------------------------------------------------------------

class PlateChange extends Equatable {
  final String date;
  final String previousPlate;
  final String newPlate;

  const PlateChange({
    required this.date,
    required this.previousPlate,
    required this.newPlate,
  });

  @override
  List<Object?> get props => [date, previousPlate, newPlate];
}

class PlateChangeHistory extends Equatable {
  final bool hasChanges;
  final List<PlateChange> changes;

  const PlateChangeHistory({
    required this.hasChanges,
    required this.changes,
  });

  @override
  List<Object?> get props => [hasChanges, changes];
}

// ---------------------------------------------------------------------------
// Import / Export
// ---------------------------------------------------------------------------

class ImportExportCheck extends Equatable {
  final bool isImported;
  final bool isExported;
  final String? date;
  final String? originCountry;

  const ImportExportCheck({
    required this.isImported,
    required this.isExported,
    this.date,
    this.originCountry,
  });

  @override
  List<Object?> get props => [isImported, isExported, date, originCountry];
}

// ---------------------------------------------------------------------------
// Scrapped
// ---------------------------------------------------------------------------

class ScrappedCheck extends Equatable {
  final bool isScrapped;
  final String? dateScrapped;
  final bool isUnscrapped;

  const ScrappedCheck({
    required this.isScrapped,
    this.dateScrapped,
    required this.isUnscrapped,
  });

  @override
  List<Object?> get props => [isScrapped, dateScrapped, isUnscrapped];
}

// ---------------------------------------------------------------------------
// V5C
// ---------------------------------------------------------------------------

class V5CCheck extends Equatable {
  final String? lastIssueDate;
  final String? documentReference;

  const V5CCheck({
    this.lastIssueDate,
    this.documentReference,
  });

  @override
  List<Object?> get props => [lastIssueDate, documentReference];
}

// ---------------------------------------------------------------------------
// MOT
// ---------------------------------------------------------------------------

class MOTTest extends Equatable {
  final String date;
  final String result;
  final int mileage;
  final String? expiryDate;
  final List<String> advisories;
  final List<String> failures;

  const MOTTest({
    required this.date,
    required this.result,
    required this.mileage,
    this.expiryDate,
    required this.advisories,
    required this.failures,
  });

  @override
  List<Object?> get props => [
        date,
        result,
        mileage,
        expiryDate,
        advisories,
        failures,
      ];
}

class MOTHistory extends Equatable {
  final List<MOTTest> tests;

  const MOTHistory({
    required this.tests,
  });

  @override
  List<Object?> get props => [tests];
}

// ---------------------------------------------------------------------------
// Tax
// ---------------------------------------------------------------------------

class TaxStatus extends Equatable {
  final bool isTaxed;
  final String? expiryDate;
  final String? rate;
  final String? band;
  final double? annualCost;

  const TaxStatus({
    required this.isTaxed,
    this.expiryDate,
    this.rate,
    this.band,
    this.annualCost,
  });

  @override
  List<Object?> get props => [isTaxed, expiryDate, rate, band, annualCost];
}

// ---------------------------------------------------------------------------
// Valuation
// ---------------------------------------------------------------------------

class VehicleValuation extends Equatable {
  final double tradeIn;
  final double privateSale;
  final double dealer;
  final String confidenceLevel;

  const VehicleValuation({
    required this.tradeIn,
    required this.privateSale,
    required this.dealer,
    required this.confidenceLevel,
  });

  @override
  List<Object?> get props => [tradeIn, privateSale, dealer, confidenceLevel];
}

// ---------------------------------------------------------------------------
// Safety recall
// ---------------------------------------------------------------------------

class Recall extends Equatable {
  final String date;
  final String description;
  final String status;

  const Recall({
    required this.date,
    required this.description,
    required this.status,
  });

  @override
  List<Object?> get props => [date, description, status];
}

class SafetyRecall extends Equatable {
  final bool hasRecalls;
  final List<Recall> recalls;

  const SafetyRecall({
    required this.hasRecalls,
    required this.recalls,
  });

  @override
  List<Object?> get props => [hasRecalls, recalls];
}

// ---------------------------------------------------------------------------
// Vehicle specification
// ---------------------------------------------------------------------------

class VehicleSpecification extends Equatable {
  final double? bhp;
  final String? torque;
  final double? zeroToSixty;
  final double? topSpeed;
  final double? weight;
  final double? length;
  final double? width;
  final double? height;
  final double? fuelEconomyUrban;
  final double? fuelEconomyCombined;
  final double? fuelEconomyExtraUrban;
  final String? insuranceGroup;
  final int? doors;
  final int? seats;

  const VehicleSpecification({
    this.bhp,
    this.torque,
    this.zeroToSixty,
    this.topSpeed,
    this.weight,
    this.length,
    this.width,
    this.height,
    this.fuelEconomyUrban,
    this.fuelEconomyCombined,
    this.fuelEconomyExtraUrban,
    this.insuranceGroup,
    this.doors,
    this.seats,
  });

  @override
  List<Object?> get props => [
        bhp,
        torque,
        zeroToSixty,
        topSpeed,
        weight,
        length,
        width,
        height,
        fuelEconomyUrban,
        fuelEconomyCombined,
        fuelEconomyExtraUrban,
        insuranceGroup,
        doors,
        seats,
      ];
}
