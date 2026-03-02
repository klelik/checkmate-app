import '../../domain/entities/vehicle_check_entity.dart';

/// Provides realistic mock vehicle data for demo/testing purposes.
/// Each vehicle covers a different scenario (clean, finance, stolen, etc.).
class MockVehicleData {
  MockVehicleData._();

  static Map<String, VehicleCheckResult> getVehicles() {
    return {
      // -----------------------------------------------------------------------
      // 1. AB12 CDE - Clean 2019 BMW 320d
      // -----------------------------------------------------------------------
      'AB12 CDE': const VehicleCheckResult(
        registrationNumber: 'AB12 CDE',
        make: 'BMW',
        model: '320d M Sport',
        year: 2019,
        colour: 'Alpine White',
        fuelType: 'Diesel',
        engineSizeCC: 1995,
        bodyType: 'Saloon',
        transmission: 'Automatic',
        overallRiskScore: 5,
        riskCategory: 'Clear',
        aiSummary:
            'This BMW 320d has a clean history with no outstanding finance, '
            'write-offs, or theft markers. The mileage is consistent across all '
            'readings at approximately 45,000 miles, and the vehicle has had '
            'three careful keepers since registration. All MOT tests have been '
            'passed with only minor advisories.',
        stolenCheck: StolenCheck(isStolen: false),
        financeCheck: FinanceCheck(hasFinance: false),
        writeOffCheck: WriteOffCheck(isWriteOff: false),
        mileageCheck: MileageCheck(
          hasDiscrepancy: false,
          averagePerYear: 7500,
          readings: [
            MileageReading(
              date: '2022-06-14',
              mileage: 22384,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2023-06-08',
              mileage: 30102,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2024-06-11',
              mileage: 37841,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2025-06-09',
              mileage: 45213,
              source: 'MOT Test',
            ),
          ],
        ),
        keeperHistory: KeeperHistory(
          keeperCount: 3,
          changes: [
            KeeperChange(date: '2019-03-15', duration: '2 years 4 months'),
            KeeperChange(date: '2021-07-22', duration: '1 year 11 months'),
            KeeperChange(date: '2023-06-18', duration: '2 years 9 months'),
          ],
        ),
        plateChanges: PlateChangeHistory(hasChanges: false, changes: []),
        importExport: ImportExportCheck(
          isImported: false,
          isExported: false,
        ),
        scrappedCheck: ScrappedCheck(
          isScrapped: false,
          isUnscrapped: false,
        ),
        v5cCheck: V5CCheck(
          lastIssueDate: '2023-07-02',
          documentReference: '12345678901',
        ),
        motHistory: MOTHistory(
          tests: [
            MOTTest(
              date: '2025-06-09',
              result: 'Pass',
              mileage: 45213,
              expiryDate: '2026-06-08',
              advisories: [
                'Front brake disc worn but not excessively (1.1.14)',
              ],
              failures: [],
            ),
            MOTTest(
              date: '2024-06-11',
              result: 'Pass',
              mileage: 37841,
              expiryDate: '2025-06-10',
              advisories: [
                'Offside rear tyre tread depth approaching the legal minimum (5.2.3)',
                'Slight oil leak from engine (8.4.1)',
              ],
              failures: [],
            ),
            MOTTest(
              date: '2023-06-08',
              result: 'Pass',
              mileage: 30102,
              expiryDate: '2024-06-07',
              advisories: [
                'Nearside front anti-roll bar linkage has slight play (5.3.4)',
              ],
              failures: [],
            ),
            MOTTest(
              date: '2022-06-14',
              result: 'Pass',
              mileage: 22384,
              expiryDate: '2023-06-13',
              advisories: [],
              failures: [],
            ),
          ],
        ),
        taxStatus: TaxStatus(
          isTaxed: true,
          expiryDate: '2026-03-01',
          rate: 'Standard',
          band: 'J',
          annualCost: 190.0,
        ),
        co2Emissions: '124 g/km',
        euroStatus: 'Euro 6d',
        ulezCompliant: true,
        valuation: VehicleValuation(
          tradeIn: 17250.0,
          privateSale: 19800.0,
          dealer: 22495.0,
          confidenceLevel: 'High',
        ),
        safetyRecall: SafetyRecall(hasRecalls: false, recalls: []),
        euroNcapRating: 5,
        specs: VehicleSpecification(
          bhp: 190.0,
          torque: '400 Nm',
          zeroToSixty: 6.8,
          topSpeed: 150.0,
          weight: 1535.0,
          length: 4709.0,
          width: 1827.0,
          height: 1435.0,
          fuelEconomyUrban: 47.9,
          fuelEconomyCombined: 55.4,
          fuelEconomyExtraUrban: 62.8,
          insuranceGroup: '30E',
          doors: 4,
          seats: 5,
        ),
      ),

      // -----------------------------------------------------------------------
      // 2. FG63 HIJ - 2016 Ford Focus with outstanding finance
      // -----------------------------------------------------------------------
      'FG63 HIJ': const VehicleCheckResult(
        registrationNumber: 'FG63 HIJ',
        make: 'Ford',
        model: 'Focus Zetec',
        year: 2016,
        colour: 'Deep Impact Blue',
        fuelType: 'Petrol',
        engineSizeCC: 1499,
        bodyType: 'Hatchback',
        transmission: 'Manual',
        overallRiskScore: 45,
        riskCategory: 'Caution',
        aiSummary:
            'This Ford Focus has outstanding finance recorded against it. A '
            'Hire Purchase agreement with Black Horse Finance shows '
            '\u00A38,400 remaining. The buyer should not proceed without '
            'confirming that the finance will be settled before or at the '
            'point of sale, as legal ownership rests with the finance company.',
        stolenCheck: StolenCheck(isStolen: false),
        financeCheck: FinanceCheck(
          hasFinance: true,
          agreementType: 'Hire Purchase (HP)',
          financeCompany: 'Black Horse Finance',
          amountOutstanding: 8400.0,
          startDate: '2021-09-14',
          contactNumber: '0344 824 6247',
        ),
        writeOffCheck: WriteOffCheck(isWriteOff: false),
        mileageCheck: MileageCheck(
          hasDiscrepancy: false,
          averagePerYear: 9200,
          readings: [
            MileageReading(
              date: '2019-08-22',
              mileage: 28416,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2020-08-18',
              mileage: 37892,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2021-08-24',
              mileage: 46753,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2022-08-16',
              mileage: 55819,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2023-08-21',
              mileage: 64288,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2024-08-19',
              mileage: 73601,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2025-08-20',
              mileage: 82934,
              source: 'MOT Test',
            ),
          ],
        ),
        keeperHistory: KeeperHistory(
          keeperCount: 2,
          changes: [
            KeeperChange(date: '2016-03-20', duration: '5 years 6 months'),
            KeeperChange(date: '2021-09-14', duration: '4 years 6 months'),
          ],
        ),
        plateChanges: PlateChangeHistory(hasChanges: false, changes: []),
        importExport: ImportExportCheck(
          isImported: false,
          isExported: false,
        ),
        scrappedCheck: ScrappedCheck(
          isScrapped: false,
          isUnscrapped: false,
        ),
        v5cCheck: V5CCheck(
          lastIssueDate: '2021-10-01',
          documentReference: '98765432109',
        ),
        motHistory: MOTHistory(
          tests: [
            MOTTest(
              date: '2025-08-20',
              result: 'Pass',
              mileage: 82934,
              expiryDate: '2026-08-19',
              advisories: [
                'Nearside front tyre tread depth approaching the legal minimum (5.2.3)',
                'Offside rear brake pad worn but not excessively (1.1.13)',
                'Exhaust has a minor leak at the manifold joint (6.1.2)',
              ],
              failures: [],
            ),
            MOTTest(
              date: '2024-08-19',
              result: 'Pass',
              mileage: 73601,
              expiryDate: '2025-08-18',
              advisories: [
                'Front windscreen has a stoned chip but not within the critical area (3.2)',
              ],
              failures: [],
            ),
            MOTTest(
              date: '2023-08-21',
              result: 'Fail',
              mileage: 64288,
              advisories: [
                'Nearside rear coil spring corroded (5.3.1)',
              ],
              failures: [
                'Offside front position lamp not working (4.2.1)',
                'Nearside rear tyre tread depth below the legal minimum of 1.6mm (5.2.3)',
              ],
            ),
            MOTTest(
              date: '2023-08-28',
              result: 'Pass',
              mileage: 64288,
              expiryDate: '2024-08-27',
              advisories: [
                'Nearside rear coil spring corroded (5.3.1)',
              ],
              failures: [],
            ),
            MOTTest(
              date: '2022-08-16',
              result: 'Pass',
              mileage: 55819,
              expiryDate: '2023-08-15',
              advisories: [],
              failures: [],
            ),
          ],
        ),
        taxStatus: TaxStatus(
          isTaxed: true,
          expiryDate: '2026-09-01',
          rate: 'Standard',
          band: 'G',
          annualCost: 165.0,
        ),
        co2Emissions: '119 g/km',
        euroStatus: 'Euro 6',
        ulezCompliant: true,
        valuation: VehicleValuation(
          tradeIn: 5800.0,
          privateSale: 7200.0,
          dealer: 8995.0,
          confidenceLevel: 'High',
        ),
        safetyRecall: SafetyRecall(hasRecalls: false, recalls: []),
        euroNcapRating: 5,
        specs: VehicleSpecification(
          bhp: 150.0,
          torque: '240 Nm',
          zeroToSixty: 8.6,
          topSpeed: 131.0,
          weight: 1309.0,
          length: 4358.0,
          width: 1823.0,
          height: 1469.0,
          fuelEconomyUrban: 40.4,
          fuelEconomyCombined: 51.4,
          fuelEconomyExtraUrban: 60.1,
          insuranceGroup: '16E',
          doors: 5,
          seats: 5,
        ),
      ),

      // -----------------------------------------------------------------------
      // 3. KL17 MNO - 2017 Mercedes C-Class Cat S write-off
      // -----------------------------------------------------------------------
      'KL17 MNO': const VehicleCheckResult(
        registrationNumber: 'KL17 MNO',
        make: 'Mercedes-Benz',
        model: 'C220d AMG Line',
        year: 2017,
        colour: 'Obsidian Black',
        fuelType: 'Diesel',
        engineSizeCC: 2143,
        bodyType: 'Saloon',
        transmission: 'Automatic',
        overallRiskScore: 65,
        riskCategory: 'High Risk',
        aiSummary:
            'This Mercedes C-Class was recorded as a Category S insurance '
            'write-off in October 2021 due to structural damage to the front '
            'nearside. The vehicle has since been professionally repaired and '
            'returned to the road. Buyers should obtain an independent '
            'structural inspection before purchasing, as Cat S vehicles may '
            'have reduced resale value.',
        stolenCheck: StolenCheck(isStolen: false),
        financeCheck: FinanceCheck(hasFinance: false),
        writeOffCheck: WriteOffCheck(
          isWriteOff: true,
          category: 'S',
          date: '2021-10-08',
          insurer: 'Admiral Insurance',
          damageArea: 'Front nearside structural damage',
        ),
        mileageCheck: MileageCheck(
          hasDiscrepancy: false,
          averagePerYear: 11000,
          readings: [
            MileageReading(
              date: '2020-04-14',
              mileage: 34218,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2021-04-12',
              mileage: 45087,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2022-07-19',
              mileage: 52346,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2023-07-11',
              mileage: 63718,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2024-07-15',
              mileage: 74892,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2025-07-08',
              mileage: 85401,
              source: 'MOT Test',
            ),
          ],
        ),
        keeperHistory: KeeperHistory(
          keeperCount: 4,
          changes: [
            KeeperChange(date: '2017-06-01', duration: '2 years 3 months'),
            KeeperChange(date: '2019-09-15', duration: '2 years 1 month'),
            KeeperChange(date: '2021-10-22', duration: '6 months'),
            KeeperChange(date: '2022-04-10', duration: '3 years 11 months'),
          ],
        ),
        plateChanges: PlateChangeHistory(hasChanges: false, changes: []),
        importExport: ImportExportCheck(
          isImported: false,
          isExported: false,
        ),
        scrappedCheck: ScrappedCheck(
          isScrapped: false,
          isUnscrapped: false,
        ),
        v5cCheck: V5CCheck(
          lastIssueDate: '2022-05-01',
          documentReference: '44556677889',
        ),
        motHistory: MOTHistory(
          tests: [
            MOTTest(
              date: '2025-07-08',
              result: 'Pass',
              mileage: 85401,
              expiryDate: '2026-07-07',
              advisories: [
                'Offside front lower suspension arm ball joint dust cover deteriorated but secure (5.3.4)',
                'Both front brake discs lightly pitted on the inner face (1.1.14)',
              ],
              failures: [],
            ),
            MOTTest(
              date: '2024-07-15',
              result: 'Pass',
              mileage: 74892,
              expiryDate: '2025-07-14',
              advisories: [
                'Nearside rear tyre has slight cracking on the sidewall (5.2.3)',
              ],
              failures: [],
            ),
            MOTTest(
              date: '2023-07-11',
              result: 'Pass',
              mileage: 63718,
              expiryDate: '2024-07-10',
              advisories: [
                'Offside rear brake pad wearing thin but serviceable (1.1.13)',
                'Oil leak from engine sump, not excessive (8.4.1)',
              ],
              failures: [],
            ),
            MOTTest(
              date: '2022-07-19',
              result: 'Pass',
              mileage: 52346,
              expiryDate: '2023-07-18',
              advisories: [],
              failures: [],
            ),
            MOTTest(
              date: '2021-04-12',
              result: 'Pass',
              mileage: 45087,
              expiryDate: '2022-04-11',
              advisories: [
                'Nearside front tyre tread depth approaching the legal minimum (5.2.3)',
              ],
              failures: [],
            ),
          ],
        ),
        taxStatus: TaxStatus(
          isTaxed: true,
          expiryDate: '2026-06-01',
          rate: 'Standard',
          band: 'J',
          annualCost: 190.0,
        ),
        co2Emissions: '127 g/km',
        euroStatus: 'Euro 6',
        ulezCompliant: true,
        valuation: VehicleValuation(
          tradeIn: 10200.0,
          privateSale: 12500.0,
          dealer: 14995.0,
          confidenceLevel: 'Medium',
        ),
        safetyRecall: SafetyRecall(
          hasRecalls: true,
          recalls: [
            Recall(
              date: '2019-11-15',
              description:
                  'Possible fault with the electronic stability programme '
                  '(ESP) sensor. In rare cases the ESP may activate '
                  'unexpectedly at low speed.',
              status: 'Completed',
            ),
          ],
        ),
        euroNcapRating: 5,
        specs: VehicleSpecification(
          bhp: 170.0,
          torque: '400 Nm',
          zeroToSixty: 7.3,
          topSpeed: 146.0,
          weight: 1555.0,
          length: 4686.0,
          width: 1810.0,
          height: 1442.0,
          fuelEconomyUrban: 50.4,
          fuelEconomyCombined: 60.1,
          fuelEconomyExtraUrban: 67.3,
          insuranceGroup: '28E',
          doors: 4,
          seats: 5,
        ),
      ),

      // -----------------------------------------------------------------------
      // 4. PQ19 RST - 2019 Audi A4 Cat N write-off
      // -----------------------------------------------------------------------
      'PQ19 RST': const VehicleCheckResult(
        registrationNumber: 'PQ19 RST',
        make: 'Audi',
        model: 'A4 35 TFSI Sport',
        year: 2019,
        colour: 'Glacier White',
        fuelType: 'Petrol',
        engineSizeCC: 1984,
        bodyType: 'Saloon',
        transmission: 'Automatic',
        overallRiskScore: 55,
        riskCategory: 'Caution',
        aiSummary:
            'This Audi A4 was recorded as a Category N insurance write-off in '
            'March 2023 due to non-structural damage to the rear panels and '
            'bumper. Category N means the vehicle sustained cosmetic damage '
            'only and no structural repair was required. The mileage and '
            'keeper history are consistent, but buyers should verify the '
            'quality of the repair work.',
        stolenCheck: StolenCheck(isStolen: false),
        financeCheck: FinanceCheck(hasFinance: false),
        writeOffCheck: WriteOffCheck(
          isWriteOff: true,
          category: 'N',
          date: '2023-03-12',
          insurer: 'Aviva Insurance',
          damageArea: 'Rear bumper, boot lid and offside rear panel',
        ),
        mileageCheck: MileageCheck(
          hasDiscrepancy: false,
          averagePerYear: 8500,
          readings: [
            MileageReading(
              date: '2022-09-06',
              mileage: 26842,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2023-09-04',
              mileage: 35417,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2024-09-09',
              mileage: 43281,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2025-09-03',
              mileage: 52064,
              source: 'MOT Test',
            ),
          ],
        ),
        keeperHistory: KeeperHistory(
          keeperCount: 3,
          changes: [
            KeeperChange(date: '2019-07-22', duration: '2 years 8 months'),
            KeeperChange(date: '2022-03-18', duration: '1 year 3 months'),
            KeeperChange(date: '2023-06-25', duration: '2 years 8 months'),
          ],
        ),
        plateChanges: PlateChangeHistory(hasChanges: false, changes: []),
        importExport: ImportExportCheck(
          isImported: false,
          isExported: false,
        ),
        scrappedCheck: ScrappedCheck(
          isScrapped: false,
          isUnscrapped: false,
        ),
        v5cCheck: V5CCheck(
          lastIssueDate: '2023-07-10',
          documentReference: '55667788990',
        ),
        motHistory: MOTHistory(
          tests: [
            MOTTest(
              date: '2025-09-03',
              result: 'Pass',
              mileage: 52064,
              expiryDate: '2026-09-02',
              advisories: [
                'Offside front brake disc lightly scored (1.1.14)',
              ],
              failures: [],
            ),
            MOTTest(
              date: '2024-09-09',
              result: 'Pass',
              mileage: 43281,
              expiryDate: '2025-09-08',
              advisories: [
                'Nearside rear tyre has minor damage to the sidewall but '
                    'the ply or cords are not exposed (5.2.3)',
              ],
              failures: [],
            ),
            MOTTest(
              date: '2023-09-04',
              result: 'Pass',
              mileage: 35417,
              expiryDate: '2024-09-03',
              advisories: [],
              failures: [],
            ),
            MOTTest(
              date: '2022-09-06',
              result: 'Pass',
              mileage: 26842,
              expiryDate: '2023-09-05',
              advisories: [
                'Front windscreen has a stoned chip in the secondary zone (3.2)',
              ],
              failures: [],
            ),
          ],
        ),
        taxStatus: TaxStatus(
          isTaxed: true,
          expiryDate: '2026-07-31',
          rate: 'Standard',
          band: 'H',
          annualCost: 175.0,
        ),
        co2Emissions: '138 g/km',
        euroStatus: 'Euro 6d-TEMP',
        ulezCompliant: true,
        valuation: VehicleValuation(
          tradeIn: 14500.0,
          privateSale: 17200.0,
          dealer: 19995.0,
          confidenceLevel: 'Medium',
        ),
        safetyRecall: SafetyRecall(hasRecalls: false, recalls: []),
        euroNcapRating: 5,
        specs: VehicleSpecification(
          bhp: 150.0,
          torque: '270 Nm',
          zeroToSixty: 8.2,
          topSpeed: 142.0,
          weight: 1495.0,
          length: 4762.0,
          width: 1847.0,
          height: 1428.0,
          fuelEconomyUrban: 33.2,
          fuelEconomyCombined: 42.2,
          fuelEconomyExtraUrban: 50.4,
          insuranceGroup: '24E',
          doors: 4,
          seats: 5,
        ),
      ),

      // -----------------------------------------------------------------------
      // 5. UV14 WXY - 2014 VW Golf - STOLEN
      // -----------------------------------------------------------------------
      'UV14 WXY': const VehicleCheckResult(
        registrationNumber: 'UV14 WXY',
        make: 'Volkswagen',
        model: 'Golf GTD',
        year: 2014,
        colour: 'Night Blue',
        fuelType: 'Diesel',
        engineSizeCC: 1968,
        bodyType: 'Hatchback',
        transmission: 'Manual',
        overallRiskScore: 95,
        riskCategory: 'Critical',
        aiSummary:
            'CRITICAL WARNING: This Volkswagen Golf is currently recorded as '
            'stolen on the Police National Computer (PNC). It was reported '
            'stolen on 15th January 2026 by West Midlands Police. Do NOT '
            'purchase this vehicle. If you have seen it, contact the police '
            'immediately using the reference number provided.',
        stolenCheck: StolenCheck(
          isStolen: true,
          dateReported: '2026-01-15',
          policeForce: 'West Midlands Police',
          referenceNumber: 'WM/2026/014829',
        ),
        financeCheck: FinanceCheck(hasFinance: false),
        writeOffCheck: WriteOffCheck(isWriteOff: false),
        mileageCheck: MileageCheck(
          hasDiscrepancy: false,
          averagePerYear: 10200,
          readings: [
            MileageReading(
              date: '2017-03-22',
              mileage: 31842,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2018-03-19',
              mileage: 42108,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2019-03-21',
              mileage: 52374,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2020-03-16',
              mileage: 62891,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2021-03-18',
              mileage: 72146,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2022-03-22',
              mileage: 82457,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2023-03-20',
              mileage: 93021,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2024-03-18',
              mileage: 103448,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2025-03-17',
              mileage: 113672,
              source: 'MOT Test',
            ),
          ],
        ),
        keeperHistory: KeeperHistory(
          keeperCount: 3,
          changes: [
            KeeperChange(date: '2014-06-12', duration: '3 years 8 months'),
            KeeperChange(date: '2018-02-20', duration: '4 years 2 months'),
            KeeperChange(date: '2022-04-18', duration: '3 years 11 months'),
          ],
        ),
        plateChanges: PlateChangeHistory(hasChanges: false, changes: []),
        importExport: ImportExportCheck(
          isImported: false,
          isExported: false,
        ),
        scrappedCheck: ScrappedCheck(
          isScrapped: false,
          isUnscrapped: false,
        ),
        v5cCheck: V5CCheck(
          lastIssueDate: '2022-05-02',
          documentReference: '77889900112',
        ),
        motHistory: MOTHistory(
          tests: [
            MOTTest(
              date: '2025-03-17',
              result: 'Pass',
              mileage: 113672,
              expiryDate: '2026-03-16',
              advisories: [
                'Both rear tyres approaching the legal tread depth limit (5.2.3)',
                'Offside front suspension arm ball joint dust cover split (5.3.4)',
                'Front brake discs worn but not excessively (1.1.14)',
              ],
              failures: [],
            ),
            MOTTest(
              date: '2024-03-18',
              result: 'Pass',
              mileage: 103448,
              expiryDate: '2025-03-17',
              advisories: [
                'Slight oil leak from rocker cover gasket (8.4.1)',
                'Nearside rear shock absorber has a light misting of oil (5.3.2)',
              ],
              failures: [],
            ),
            MOTTest(
              date: '2023-03-20',
              result: 'Fail',
              mileage: 93021,
              advisories: [
                'Slight oil leak from rocker cover gasket (8.4.1)',
              ],
              failures: [
                'Offside headlamp aim too high (4.1.2)',
                'Nearside rear coil spring fractured (5.3.1)',
              ],
            ),
            MOTTest(
              date: '2023-03-27',
              result: 'Pass',
              mileage: 93021,
              expiryDate: '2024-03-26',
              advisories: [
                'Slight oil leak from rocker cover gasket (8.4.1)',
              ],
              failures: [],
            ),
          ],
        ),
        taxStatus: TaxStatus(
          isTaxed: true,
          expiryDate: '2026-06-01',
          rate: 'Standard',
          band: 'G',
          annualCost: 165.0,
        ),
        co2Emissions: '119 g/km',
        euroStatus: 'Euro 6',
        ulezCompliant: true,
        valuation: VehicleValuation(
          tradeIn: 7800.0,
          privateSale: 9500.0,
          dealer: 11495.0,
          confidenceLevel: 'Low',
        ),
        safetyRecall: SafetyRecall(
          hasRecalls: true,
          recalls: [
            Recall(
              date: '2018-06-22',
              description:
                  'Diesel particulate filter pressure sensor pipe may '
                  'become detached, leading to potential fire risk.',
              status: 'Completed',
            ),
          ],
        ),
        euroNcapRating: 5,
        specs: VehicleSpecification(
          bhp: 184.0,
          torque: '380 Nm',
          zeroToSixty: 7.5,
          topSpeed: 143.0,
          weight: 1376.0,
          length: 4255.0,
          width: 1799.0,
          height: 1452.0,
          fuelEconomyUrban: 52.3,
          fuelEconomyCombined: 62.8,
          fuelEconomyExtraUrban: 72.4,
          insuranceGroup: '26E',
          doors: 5,
          seats: 5,
        ),
      ),

      // -----------------------------------------------------------------------
      // 6. BC65 DEF - 2015 Vauxhall Astra - mileage discrepancy (clocked)
      // -----------------------------------------------------------------------
      'BC65 DEF': const VehicleCheckResult(
        registrationNumber: 'BC65 DEF',
        make: 'Vauxhall',
        model: 'Astra SRi',
        year: 2015,
        colour: 'Sovereign Silver',
        fuelType: 'Petrol',
        engineSizeCC: 1399,
        bodyType: 'Hatchback',
        transmission: 'Manual',
        overallRiskScore: 70,
        riskCategory: 'High Risk',
        aiSummary:
            'WARNING: A significant mileage discrepancy has been detected on '
            'this Vauxhall Astra. The MOT in September 2023 recorded 71,204 '
            'miles, but the following test in September 2024 recorded only '
            '48,312 miles \u2014 a reduction of nearly 23,000 miles. This is a '
            'strong indicator that the odometer has been tampered with. Buyers '
            'should avoid this vehicle.',
        stolenCheck: StolenCheck(isStolen: false),
        financeCheck: FinanceCheck(hasFinance: false),
        writeOffCheck: WriteOffCheck(isWriteOff: false),
        mileageCheck: MileageCheck(
          hasDiscrepancy: true,
          averagePerYear: 8900,
          readings: [
            MileageReading(
              date: '2018-09-18',
              mileage: 27413,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2019-09-16',
              mileage: 36284,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2020-09-14',
              mileage: 44892,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2021-09-20',
              mileage: 53617,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2022-09-19',
              mileage: 62348,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2023-09-18',
              mileage: 71204,
              source: 'MOT Test',
            ),
            // Clocked - mileage goes DOWN
            MileageReading(
              date: '2024-09-16',
              mileage: 48312,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2025-09-15',
              mileage: 56918,
              source: 'MOT Test',
            ),
          ],
        ),
        keeperHistory: KeeperHistory(
          keeperCount: 4,
          changes: [
            KeeperChange(date: '2015-09-25', duration: '2 years 1 month'),
            KeeperChange(date: '2017-10-30', duration: '3 years 4 months'),
            KeeperChange(date: '2021-02-14', duration: '2 years 6 months'),
            KeeperChange(date: '2023-08-20', duration: '2 years 7 months'),
          ],
        ),
        plateChanges: PlateChangeHistory(hasChanges: false, changes: []),
        importExport: ImportExportCheck(
          isImported: false,
          isExported: false,
        ),
        scrappedCheck: ScrappedCheck(
          isScrapped: false,
          isUnscrapped: false,
        ),
        v5cCheck: V5CCheck(
          lastIssueDate: '2023-09-05',
          documentReference: '33221100998',
        ),
        motHistory: MOTHistory(
          tests: [
            MOTTest(
              date: '2025-09-15',
              result: 'Pass',
              mileage: 56918,
              expiryDate: '2026-09-14',
              advisories: [
                'Offside front lower suspension arm ball joint has slight play (5.3.4)',
              ],
              failures: [],
            ),
            MOTTest(
              date: '2024-09-16',
              result: 'Pass',
              mileage: 48312,
              expiryDate: '2025-09-15',
              advisories: [
                'Nearside rear brake shoe worn but not excessively (1.1.13)',
              ],
              failures: [],
            ),
            MOTTest(
              date: '2023-09-18',
              result: 'Pass',
              mileage: 71204,
              expiryDate: '2024-09-17',
              advisories: [
                'Front brake discs lightly corroded (1.1.14)',
                'Offside rear tyre tread depth approaching the legal minimum (5.2.3)',
              ],
              failures: [],
            ),
            MOTTest(
              date: '2022-09-19',
              result: 'Pass',
              mileage: 62348,
              expiryDate: '2023-09-18',
              advisories: [
                'Exhaust centre section has light surface corrosion (6.1.1)',
              ],
              failures: [],
            ),
          ],
        ),
        taxStatus: TaxStatus(
          isTaxed: true,
          expiryDate: '2026-09-30',
          rate: 'Standard',
          band: 'G',
          annualCost: 165.0,
        ),
        co2Emissions: '129 g/km',
        euroStatus: 'Euro 6',
        ulezCompliant: true,
        valuation: VehicleValuation(
          tradeIn: 3200.0,
          privateSale: 4500.0,
          dealer: 5995.0,
          confidenceLevel: 'Low',
        ),
        safetyRecall: SafetyRecall(hasRecalls: false, recalls: []),
        euroNcapRating: 5,
        specs: VehicleSpecification(
          bhp: 150.0,
          torque: '245 Nm',
          zeroToSixty: 8.5,
          topSpeed: 137.0,
          weight: 1266.0,
          length: 4370.0,
          width: 1809.0,
          height: 1485.0,
          fuelEconomyUrban: 36.7,
          fuelEconomyCombined: 47.1,
          fuelEconomyExtraUrban: 56.5,
          insuranceGroup: '18E',
          doors: 5,
          seats: 5,
        ),
      ),

      // -----------------------------------------------------------------------
      // 7. GH18 JKL - 2018 Toyota Yaris with plate change
      // -----------------------------------------------------------------------
      'GH18 JKL': const VehicleCheckResult(
        registrationNumber: 'GH18 JKL',
        make: 'Toyota',
        model: 'Yaris Icon Tech',
        year: 2018,
        colour: 'Burning Red',
        fuelType: 'Hybrid',
        engineSizeCC: 1497,
        bodyType: 'Hatchback',
        transmission: 'Automatic (CVT)',
        overallRiskScore: 15,
        riskCategory: 'Clear',
        aiSummary:
            'This Toyota Yaris is in good standing with no finance, write-off '
            'or theft markers. The vehicle has had one plate change, which '
            'is typically a cosmetic preference and not a cause for concern. '
            'Mileage is consistent and modest at around 6,000 miles per year, '
            'and the hybrid drivetrain has a strong reliability record.',
        stolenCheck: StolenCheck(isStolen: false),
        financeCheck: FinanceCheck(hasFinance: false),
        writeOffCheck: WriteOffCheck(isWriteOff: false),
        mileageCheck: MileageCheck(
          hasDiscrepancy: false,
          averagePerYear: 6000,
          readings: [
            MileageReading(
              date: '2021-05-12',
              mileage: 18214,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2022-05-09',
              mileage: 24389,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2023-05-15',
              mileage: 30107,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2024-05-13',
              mileage: 36482,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2025-05-12',
              mileage: 42218,
              source: 'MOT Test',
            ),
          ],
        ),
        keeperHistory: KeeperHistory(
          keeperCount: 2,
          changes: [
            KeeperChange(date: '2018-03-08', duration: '4 years 1 month'),
            KeeperChange(date: '2022-04-15', duration: '3 years 11 months'),
          ],
        ),
        plateChanges: PlateChangeHistory(
          hasChanges: true,
          changes: [
            PlateChange(
              date: '2022-06-10',
              previousPlate: 'GH18 JKL',
              newPlate: 'T0Y 80Y',
            ),
            PlateChange(
              date: '2024-01-15',
              previousPlate: 'T0Y 80Y',
              newPlate: 'GH18 JKL',
            ),
          ],
        ),
        importExport: ImportExportCheck(
          isImported: false,
          isExported: false,
        ),
        scrappedCheck: ScrappedCheck(
          isScrapped: false,
          isUnscrapped: false,
        ),
        v5cCheck: V5CCheck(
          lastIssueDate: '2024-02-01',
          documentReference: '11223344556',
        ),
        motHistory: MOTHistory(
          tests: [
            MOTTest(
              date: '2025-05-12',
              result: 'Pass',
              mileage: 42218,
              expiryDate: '2026-05-11',
              advisories: [],
              failures: [],
            ),
            MOTTest(
              date: '2024-05-13',
              result: 'Pass',
              mileage: 36482,
              expiryDate: '2025-05-12',
              advisories: [
                'Nearside rear brake shoe lining worn but not excessively (1.1.13)',
              ],
              failures: [],
            ),
            MOTTest(
              date: '2023-05-15',
              result: 'Pass',
              mileage: 30107,
              expiryDate: '2024-05-14',
              advisories: [],
              failures: [],
            ),
            MOTTest(
              date: '2022-05-09',
              result: 'Pass',
              mileage: 24389,
              expiryDate: '2023-05-08',
              advisories: [
                'Offside front tyre slightly worn on the inner edge (5.2.3)',
              ],
              failures: [],
            ),
            MOTTest(
              date: '2021-05-12',
              result: 'Pass',
              mileage: 18214,
              expiryDate: '2022-05-11',
              advisories: [],
              failures: [],
            ),
          ],
        ),
        taxStatus: TaxStatus(
          isTaxed: true,
          expiryDate: '2026-04-01',
          rate: 'Alternative Fuel',
          band: 'B',
          annualCost: 10.0,
        ),
        co2Emissions: '75 g/km',
        euroStatus: 'Euro 6',
        ulezCompliant: true,
        valuation: VehicleValuation(
          tradeIn: 9200.0,
          privateSale: 11000.0,
          dealer: 12795.0,
          confidenceLevel: 'High',
        ),
        safetyRecall: SafetyRecall(hasRecalls: false, recalls: []),
        euroNcapRating: 4,
        specs: VehicleSpecification(
          bhp: 100.0,
          torque: '111 Nm',
          zeroToSixty: 11.8,
          topSpeed: 109.0,
          weight: 1100.0,
          length: 3945.0,
          width: 1695.0,
          height: 1500.0,
          fuelEconomyUrban: 72.4,
          fuelEconomyCombined: 68.9,
          fuelEconomyExtraUrban: 67.3,
          insuranceGroup: '11E',
          doors: 5,
          seats: 5,
        ),
      ),

      // -----------------------------------------------------------------------
      // 8. MN20 PQR - 2020 Nissan Qashqai - imported from Japan
      // -----------------------------------------------------------------------
      'MN20 PQR': const VehicleCheckResult(
        registrationNumber: 'MN20 PQR',
        make: 'Nissan',
        model: 'Qashqai N-Connecta',
        year: 2020,
        colour: 'Magnetic Blue',
        fuelType: 'Petrol',
        engineSizeCC: 1332,
        bodyType: 'SUV',
        transmission: 'Manual',
        overallRiskScore: 25,
        riskCategory: 'Clear',
        aiSummary:
            'This Nissan Qashqai was imported from Japan in August 2020 and '
            'subsequently registered in the UK. Imported vehicles may have '
            'differing specifications from UK models, including varying '
            'equipment levels. The mileage is consistent and there are no '
            'finance, write-off or theft records. Overall this is a low-risk '
            'vehicle.',
        stolenCheck: StolenCheck(isStolen: false),
        financeCheck: FinanceCheck(hasFinance: false),
        writeOffCheck: WriteOffCheck(isWriteOff: false),
        mileageCheck: MileageCheck(
          hasDiscrepancy: false,
          averagePerYear: 7800,
          readings: [
            MileageReading(
              date: '2023-08-14',
              mileage: 23412,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2024-08-12',
              mileage: 31287,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2025-08-11',
              mileage: 38946,
              source: 'MOT Test',
            ),
          ],
        ),
        keeperHistory: KeeperHistory(
          keeperCount: 2,
          changes: [
            KeeperChange(date: '2020-08-20', duration: '3 years 2 months'),
            KeeperChange(date: '2023-10-18', duration: '2 years 5 months'),
          ],
        ),
        plateChanges: PlateChangeHistory(hasChanges: false, changes: []),
        importExport: ImportExportCheck(
          isImported: true,
          isExported: false,
          date: '2020-08-10',
          originCountry: 'Japan',
        ),
        scrappedCheck: ScrappedCheck(
          isScrapped: false,
          isUnscrapped: false,
        ),
        v5cCheck: V5CCheck(
          lastIssueDate: '2023-11-02',
          documentReference: '66778899001',
        ),
        motHistory: MOTHistory(
          tests: [
            MOTTest(
              date: '2025-08-11',
              result: 'Pass',
              mileage: 38946,
              expiryDate: '2026-08-10',
              advisories: [
                'Offside rear tyre has minor damage to sidewall but not '
                    'exposing ply or cords (5.2.3)',
              ],
              failures: [],
            ),
            MOTTest(
              date: '2024-08-12',
              result: 'Pass',
              mileage: 31287,
              expiryDate: '2025-08-11',
              advisories: [],
              failures: [],
            ),
            MOTTest(
              date: '2023-08-14',
              result: 'Pass',
              mileage: 23412,
              expiryDate: '2024-08-13',
              advisories: [
                'Nearside front brake disc worn but not excessively (1.1.14)',
                'Wiper blade deterioration noted on drivers side (3.4)',
              ],
              failures: [],
            ),
          ],
        ),
        taxStatus: TaxStatus(
          isTaxed: true,
          expiryDate: '2026-08-01',
          rate: 'Standard',
          band: 'H',
          annualCost: 175.0,
        ),
        co2Emissions: '137 g/km',
        euroStatus: 'Euro 6d',
        ulezCompliant: true,
        valuation: VehicleValuation(
          tradeIn: 12800.0,
          privateSale: 15200.0,
          dealer: 17495.0,
          confidenceLevel: 'High',
        ),
        safetyRecall: SafetyRecall(hasRecalls: false, recalls: []),
        euroNcapRating: 5,
        specs: VehicleSpecification(
          bhp: 140.0,
          torque: '240 Nm',
          zeroToSixty: 9.9,
          topSpeed: 124.0,
          weight: 1374.0,
          length: 4425.0,
          width: 1806.0,
          height: 1595.0,
          fuelEconomyUrban: 35.3,
          fuelEconomyCombined: 44.1,
          fuelEconomyExtraUrban: 51.4,
          insuranceGroup: '17E',
          doors: 5,
          seats: 5,
        ),
      ),

      // -----------------------------------------------------------------------
      // 9. ST11 UVW - 2011 Honda Civic - scrapped then un-scrapped
      // -----------------------------------------------------------------------
      'ST11 UVW': const VehicleCheckResult(
        registrationNumber: 'ST11 UVW',
        make: 'Honda',
        model: 'Civic 1.8 i-VTEC SE',
        year: 2011,
        colour: 'Polished Metal',
        fuelType: 'Petrol',
        engineSizeCC: 1799,
        bodyType: 'Hatchback',
        transmission: 'Manual',
        overallRiskScore: 80,
        riskCategory: 'High Risk',
        aiSummary:
            'WARNING: This Honda Civic was officially scrapped by the DVLA '
            'in June 2022, meaning it was declared unfit for the road and '
            'destined for destruction. However, the vehicle was subsequently '
            'un-scrapped and returned to the road in November 2022. This is '
            'a significant red flag \u2014 the vehicle should be thoroughly '
            'inspected by an independent engineer before any purchase.',
        stolenCheck: StolenCheck(isStolen: false),
        financeCheck: FinanceCheck(hasFinance: false),
        writeOffCheck: WriteOffCheck(isWriteOff: false),
        mileageCheck: MileageCheck(
          hasDiscrepancy: false,
          averagePerYear: 8400,
          readings: [
            MileageReading(
              date: '2014-04-22',
              mileage: 25218,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2015-04-20',
              mileage: 33847,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2016-04-18',
              mileage: 42109,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2017-04-24',
              mileage: 50873,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2018-04-19',
              mileage: 59214,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2019-04-22',
              mileage: 67841,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2020-04-14',
              mileage: 74218,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2021-04-19',
              mileage: 80492,
              source: 'MOT Test',
            ),
            // Gap where scrapped
            MileageReading(
              date: '2023-02-14',
              mileage: 83716,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2024-02-12',
              mileage: 91284,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2025-02-10',
              mileage: 99847,
              source: 'MOT Test',
            ),
          ],
        ),
        keeperHistory: KeeperHistory(
          keeperCount: 5,
          changes: [
            KeeperChange(date: '2011-06-15', duration: '3 years 2 months'),
            KeeperChange(date: '2014-08-20', duration: '2 years 7 months'),
            KeeperChange(date: '2017-03-14', duration: '3 years 1 month'),
            KeeperChange(date: '2020-04-22', duration: '2 years 2 months'),
            KeeperChange(date: '2022-06-28', duration: '3 years 8 months'),
          ],
        ),
        plateChanges: PlateChangeHistory(hasChanges: false, changes: []),
        importExport: ImportExportCheck(
          isImported: false,
          isExported: false,
        ),
        scrappedCheck: ScrappedCheck(
          isScrapped: true,
          dateScrapped: '2022-06-14',
          isUnscrapped: true,
        ),
        v5cCheck: V5CCheck(
          lastIssueDate: '2022-12-01',
          documentReference: '99887766554',
        ),
        motHistory: MOTHistory(
          tests: [
            MOTTest(
              date: '2025-02-10',
              result: 'Pass',
              mileage: 99847,
              expiryDate: '2026-02-09',
              advisories: [
                'Nearside front suspension arm ball joint has slight play (5.3.4)',
                'Both rear brake drums worn but not excessively (1.1.14)',
                'Exhaust centre box has light corrosion (6.1.1)',
                'Offside front tyre has slight damage to the sidewall (5.2.3)',
              ],
              failures: [],
            ),
            MOTTest(
              date: '2024-02-12',
              result: 'Pass',
              mileage: 91284,
              expiryDate: '2025-02-11',
              advisories: [
                'Front brake discs scored (1.1.14)',
                'Nearside rear shock absorber has a light misting of oil (5.3.2)',
              ],
              failures: [],
            ),
            MOTTest(
              date: '2023-02-14',
              result: 'Fail',
              mileage: 83716,
              advisories: [
                'Nearside rear shock absorber has a light misting of oil (5.3.2)',
              ],
              failures: [
                'Nearside front tyre tread below the legal minimum (5.2.3)',
                'Offside rear brake binding (1.2.1)',
                'Exhaust emissions exceed the prescribed limits (8.2.1.2)',
              ],
            ),
            MOTTest(
              date: '2023-02-22',
              result: 'Pass',
              mileage: 83716,
              expiryDate: '2024-02-21',
              advisories: [
                'Nearside rear shock absorber has a light misting of oil (5.3.2)',
              ],
              failures: [],
            ),
            MOTTest(
              date: '2021-04-19',
              result: 'Pass',
              mileage: 80492,
              expiryDate: '2022-04-18',
              advisories: [
                'Slight play in steering rack inner joint (2.1.3)',
                'Both front tyres approaching the legal tread depth limit (5.2.3)',
              ],
              failures: [],
            ),
          ],
        ),
        taxStatus: TaxStatus(
          isTaxed: false,
          expiryDate: '2025-12-01',
          rate: 'Standard',
          band: 'H',
          annualCost: 175.0,
        ),
        co2Emissions: '153 g/km',
        euroStatus: 'Euro 5',
        ulezCompliant: true,
        valuation: VehicleValuation(
          tradeIn: 1800.0,
          privateSale: 2800.0,
          dealer: 3995.0,
          confidenceLevel: 'Low',
        ),
        safetyRecall: SafetyRecall(
          hasRecalls: true,
          recalls: [
            Recall(
              date: '2019-04-10',
              description:
                  'Takata airbag inflator may deploy with excessive force '
                  'due to propellant degradation, potentially causing '
                  'injury to occupants.',
              status: 'Completed',
            ),
            Recall(
              date: '2016-08-22',
              description:
                  'Passenger side front airbag inflator requires replacement '
                  'as a precautionary measure.',
              status: 'Completed',
            ),
          ],
        ),
        euroNcapRating: 5,
        specs: VehicleSpecification(
          bhp: 140.0,
          torque: '174 Nm',
          zeroToSixty: 9.0,
          topSpeed: 131.0,
          weight: 1280.0,
          length: 4390.0,
          width: 1770.0,
          height: 1440.0,
          fuelEconomyUrban: 30.1,
          fuelEconomyCombined: 40.9,
          fuelEconomyExtraUrban: 49.6,
          insuranceGroup: '18E',
          doors: 5,
          seats: 5,
        ),
      ),

      // -----------------------------------------------------------------------
      // 10. XY21 ZAB - 2021 Tesla Model 3 - clean, high keeper count
      // -----------------------------------------------------------------------
      'XY21 ZAB': const VehicleCheckResult(
        registrationNumber: 'XY21 ZAB',
        make: 'Tesla',
        model: 'Model 3 Standard Range Plus',
        year: 2021,
        colour: 'Pearl White',
        fuelType: 'Electric',
        engineSizeCC: 0,
        bodyType: 'Saloon',
        transmission: 'Automatic',
        overallRiskScore: 30,
        riskCategory: 'Caution',
        aiSummary:
            'This Tesla Model 3 has a clean history with no finance, write-off '
            'or theft concerns. However, it has had five registered keepers in '
            'under five years, which is unusually high and may indicate '
            'recurring issues that have prompted multiple owners to sell. '
            'Buyers should request full service records and carefully inspect '
            'the vehicle.',
        stolenCheck: StolenCheck(isStolen: false),
        financeCheck: FinanceCheck(hasFinance: false),
        writeOffCheck: WriteOffCheck(isWriteOff: false),
        mileageCheck: MileageCheck(
          hasDiscrepancy: false,
          averagePerYear: 9400,
          readings: [
            MileageReading(
              date: '2024-03-18',
              mileage: 28714,
              source: 'MOT Test',
            ),
            MileageReading(
              date: '2025-03-14',
              mileage: 37892,
              source: 'MOT Test',
            ),
          ],
        ),
        keeperHistory: KeeperHistory(
          keeperCount: 5,
          changes: [
            KeeperChange(date: '2021-03-25', duration: '8 months'),
            KeeperChange(date: '2021-11-30', duration: '10 months'),
            KeeperChange(date: '2022-09-22', duration: '1 year 1 month'),
            KeeperChange(date: '2023-10-15', duration: '11 months'),
            KeeperChange(date: '2024-09-08', duration: '6 months'),
          ],
        ),
        plateChanges: PlateChangeHistory(hasChanges: false, changes: []),
        importExport: ImportExportCheck(
          isImported: false,
          isExported: false,
        ),
        scrappedCheck: ScrappedCheck(
          isScrapped: false,
          isUnscrapped: false,
        ),
        v5cCheck: V5CCheck(
          lastIssueDate: '2024-09-20',
          documentReference: '22334455667',
        ),
        motHistory: MOTHistory(
          tests: [
            MOTTest(
              date: '2025-03-14',
              result: 'Pass',
              mileage: 37892,
              expiryDate: '2026-03-13',
              advisories: [
                'Nearside rear tyre tread depth approaching the legal minimum (5.2.3)',
              ],
              failures: [],
            ),
            MOTTest(
              date: '2024-03-18',
              result: 'Pass',
              mileage: 28714,
              expiryDate: '2025-03-17',
              advisories: [],
              failures: [],
            ),
          ],
        ),
        taxStatus: TaxStatus(
          isTaxed: true,
          expiryDate: '2026-04-01',
          rate: 'Zero Emission',
          band: 'A',
          annualCost: 0.0,
        ),
        co2Emissions: '0 g/km',
        euroStatus: 'N/A (Electric)',
        ulezCompliant: true,
        valuation: VehicleValuation(
          tradeIn: 19500.0,
          privateSale: 22800.0,
          dealer: 25995.0,
          confidenceLevel: 'High',
        ),
        safetyRecall: SafetyRecall(
          hasRecalls: true,
          recalls: [
            Recall(
              date: '2023-05-12',
              description:
                  'Front suspension lateral link fastener may not have been '
                  'tightened to the correct specification during manufacture. '
                  'Could result in separation of the link.',
              status: 'Completed',
            ),
            Recall(
              date: '2022-11-18',
              description:
                  'Rear-view camera cable harness may be damaged by the boot '
                  'lid opening and closing, causing the rear-view image to '
                  'not display.',
              status: 'Completed',
            ),
          ],
        ),
        euroNcapRating: 5,
        specs: VehicleSpecification(
          bhp: 283.0,
          torque: '420 Nm',
          zeroToSixty: 5.6,
          topSpeed: 140.0,
          weight: 1745.0,
          length: 4694.0,
          width: 1849.0,
          height: 1443.0,
          fuelEconomyUrban: null,
          fuelEconomyCombined: null,
          fuelEconomyExtraUrban: null,
          insuranceGroup: '39E',
          doors: 4,
          seats: 5,
        ),
      ),

      // -----------------------------------------------------------------------
      // 11. CD22 EFG - 2022 Range Rover Evoque - finance AND Cat N
      // -----------------------------------------------------------------------
      'CD22 EFG': const VehicleCheckResult(
        registrationNumber: 'CD22 EFG',
        make: 'Land Rover',
        model: 'Range Rover Evoque D200 R-Dynamic S',
        year: 2022,
        colour: 'Santorini Black',
        fuelType: 'Diesel',
        engineSizeCC: 1999,
        bodyType: 'SUV',
        transmission: 'Automatic',
        overallRiskScore: 75,
        riskCategory: 'High Risk',
        aiSummary:
            'This Range Rover Evoque has TWO significant concerns. First, '
            'there is outstanding PCP finance of \u00A314,200 with Lloyds '
            'Banking Group. Second, it was recorded as a Category N write-off '
            'in January 2025 following non-structural damage to the front '
            'bumper and bonnet. The combination of active finance and a '
            'write-off marker makes this a high-risk purchase requiring '
            'careful due diligence.',
        stolenCheck: StolenCheck(isStolen: false),
        financeCheck: FinanceCheck(
          hasFinance: true,
          agreementType: 'Personal Contract Purchase (PCP)',
          financeCompany: 'Lloyds Banking Group',
          amountOutstanding: 14200.0,
          startDate: '2022-06-22',
          contactNumber: '0345 300 0116',
        ),
        writeOffCheck: WriteOffCheck(
          isWriteOff: true,
          category: 'N',
          date: '2025-01-18',
          insurer: 'Direct Line Group',
          damageArea: 'Front bumper, bonnet and nearside headlamp',
        ),
        mileageCheck: MileageCheck(
          hasDiscrepancy: false,
          averagePerYear: 10500,
          readings: [
            MileageReading(
              date: '2025-06-20',
              mileage: 31842,
              source: 'MOT Test',
            ),
          ],
        ),
        keeperHistory: KeeperHistory(
          keeperCount: 2,
          changes: [
            KeeperChange(date: '2022-06-22', duration: '2 years 6 months'),
            KeeperChange(date: '2024-12-18', duration: '3 months'),
          ],
        ),
        plateChanges: PlateChangeHistory(hasChanges: false, changes: []),
        importExport: ImportExportCheck(
          isImported: false,
          isExported: false,
        ),
        scrappedCheck: ScrappedCheck(
          isScrapped: false,
          isUnscrapped: false,
        ),
        v5cCheck: V5CCheck(
          lastIssueDate: '2025-01-10',
          documentReference: '88990011223',
        ),
        motHistory: MOTHistory(
          tests: [
            MOTTest(
              date: '2025-06-20',
              result: 'Pass',
              mileage: 31842,
              expiryDate: '2026-06-19',
              advisories: [
                'Offside front brake disc worn but not excessively (1.1.14)',
                'Nearside front tyre has minor damage to the sidewall but '
                    'ply or cords are not exposed (5.2.3)',
              ],
              failures: [],
            ),
          ],
        ),
        taxStatus: TaxStatus(
          isTaxed: true,
          expiryDate: '2026-07-01',
          rate: 'Standard',
          band: 'K',
          annualCost: 190.0,
        ),
        co2Emissions: '149 g/km',
        euroStatus: 'Euro 6d',
        ulezCompliant: true,
        valuation: VehicleValuation(
          tradeIn: 26500.0,
          privateSale: 30200.0,
          dealer: 34995.0,
          confidenceLevel: 'Medium',
        ),
        safetyRecall: SafetyRecall(
          hasRecalls: true,
          recalls: [
            Recall(
              date: '2023-09-01',
              description:
                  'Possible incorrect tightening of a rear suspension '
                  'crossmember bolt during assembly, which could affect '
                  'rear suspension alignment over time.',
              status: 'Recall open - not yet actioned',
            ),
          ],
        ),
        euroNcapRating: 5,
        specs: VehicleSpecification(
          bhp: 204.0,
          torque: '430 Nm',
          zeroToSixty: 7.8,
          topSpeed: 135.0,
          weight: 1886.0,
          length: 4371.0,
          width: 1904.0,
          height: 1649.0,
          fuelEconomyUrban: 34.4,
          fuelEconomyCombined: 40.4,
          fuelEconomyExtraUrban: 46.3,
          insuranceGroup: '34E',
          doors: 5,
          seats: 5,
        ),
      ),
    };
  }
}
