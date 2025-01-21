// ignore_for_file: library_private_types_in_public_api

import 'package:bec_app/constant/app_colors.dart';
import 'package:bec_app/cubit/wps/wps_cubit.dart';
import 'package:bec_app/cubit/wps/wps_state.dart';
import 'package:bec_app/model/attendance/locationModel.dart';
import 'package:bec_app/screen/time_and_attendance/scan_employee_attendance_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_searchable_dropdown/flutter_searchable_dropdown.dart';

class CheckInOutSelectionScreen extends StatefulWidget {
  const CheckInOutSelectionScreen({super.key});

  @override
  _CheckInOutSelectionScreenState createState() =>
      _CheckInOutSelectionScreenState();
}

class _CheckInOutSelectionScreenState extends State<CheckInOutSelectionScreen>
    with SingleTickerProviderStateMixin {
  // Animation controllers
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  // Selection variables
  String? selectedWps;
  String? selectedCostCode;
  int? selectedLocation;
  String? selectedSegment = "checkin";

  // Options lists
  List<String> wpsOptions = [];
  List<String> costCodeOptions = [];

  List<String> locationList = [];
  List<LocationModel> locationOptions = [];

  @override
  void initState() {
    super.initState();

    // Initialize animation
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();

    // Fetch initial locations
    context.read<WpsCubit>().getLocation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Builds dropdown for locations
  Widget _buildLocationDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Select Location",
            style: TextStyle(fontWeight: FontWeight.bold)),
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.primary),
            borderRadius: BorderRadius.circular(10),
          ),
          child: SearchableDropdown.single(
            menuBackgroundColor: Colors.white,
            dialogBox: false,
            menuConstraints: BoxConstraints.loose(Size(
              MediaQuery.of(context).size.width * 0.9,
              MediaQuery.of(context).size.height * 0.4,
            )),
            items: locationList.isNotEmpty
                ? locationList.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList()
                : [
                    const DropdownMenuItem<String>(
                        value: null, child: Text('No locations available'))
                  ],
            value: selectedLocation,
            hint: const Text('Select Location'),
            searchHint: const Text('Search Location'),
            isExpanded: true,
            onChanged: (String? newValue) {
              if (newValue != null) {
                final selectedLocationModel = locationOptions
                    .firstWhere((loc) => loc.name.toString() == newValue);

                int index = locationOptions
                    .firstWhere((locModel) => locModel.name == newValue)
                    .id;

                setState(() {
                  selectedLocation = selectedLocationModel.id;
                  selectedWps = null;
                  selectedCostCode = null;
                });

                // Fetch WPS and Cost Codes for selected location
                context.read<WpsCubit>().getWps(index);
              }
            },
          ),
        ),
      ],
    );
  }

  // Builds dropdown for WPS
  Widget _buildWpsDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Select WBS", style: TextStyle(fontWeight: FontWeight.bold)),
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.primary),
            borderRadius: BorderRadius.circular(10),
          ),
          child: SearchableDropdown.single(
            menuBackgroundColor: Colors.white,
            dialogBox: false,
            menuConstraints: BoxConstraints.loose(Size(
              MediaQuery.of(context).size.width * 0.9,
              MediaQuery.of(context).size.height * 0.4,
            )),
            items: wpsOptions.isNotEmpty
                ? wpsOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList()
                : [
                    const DropdownMenuItem<String>(
                        value: null, child: Text('null'))
                  ],
            value: selectedWps,
            hint: const Text('Select WBS'),
            searchHint: const Text('Search WBS'),
            isExpanded: true,
            onChanged: (String? newValue) {
              setState(() {
                selectedWps = newValue;
              });
            },
          ),
        ),
      ],
    );
  }

  // Builds dropdown for Cost Code
  Widget _buildCostCodeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Select Cost Code",
            style: TextStyle(fontWeight: FontWeight.bold)),
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.primary),
            borderRadius: BorderRadius.circular(10),
          ),
          child: SearchableDropdown.single(
            menuBackgroundColor: Colors.white,
            dialogBox: false,
            menuConstraints: BoxConstraints.loose(Size(
              MediaQuery.of(context).size.width * 0.9,
              MediaQuery.of(context).size.height * 0.4,
            )),
            items: costCodeOptions.isNotEmpty
                ? costCodeOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList()
                : [
                    const DropdownMenuItem<String>(
                        value: null, child: Text('null'))
                  ],
            value: selectedCostCode,
            hint: const Text('Select Cost Code'),
            searchHint: const Text('Search Cost Code'),
            isExpanded: true,
            onChanged: (String? newValue) {
              setState(() {
                selectedCostCode = newValue;
              });
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Check In / Out',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: BlocConsumer<WpsCubit, WpsState>(
          listener: (context, state) {
            if (state is LocationSuccess) {
              setState(() {
                locationOptions = state.locations;
                locationList = locationOptions.map((e) => e.name).toList();

                // Automatically select first location if available
                if (locationOptions.isNotEmpty) {
                  selectedLocation = locationOptions.first.id;
                  context.read<WpsCubit>().getWps(locationOptions.first.id);
                } else {
                  selectedCostCode = null;
                  selectedWps = null;
                  selectedLocation = null;
                }
              });
            }

            if (state is WpsSuccess) {
              setState(() {
                wpsOptions = state.wps.map((e) => e.name ?? '').toList();
                // Set selectedWps to the first item if available
                selectedWps = wpsOptions.isNotEmpty
                    ? wpsOptions.first
                    : null; // Updated to select first WPS
              });
            }

            if (state is CostCodeSuccess) {
              setState(() {
                costCodeOptions =
                    state.costCodes.map((e) => e.name ?? '').toList();

                // Set selectedCostCode to the first item if available
                selectedCostCode = costCodeOptions.isNotEmpty
                    ? costCodeOptions.first
                    : null; // Updated to select first Cost Code
              });
            }
          },
          builder: (context, state) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Check In / Check Out Segment
                      // make a segmented for checkin or checkout
                      SegmentedButton(
                        showSelectedIcon: false,
                        segments: const <ButtonSegment<Object?>>[
                          ButtonSegment<Object?>(
                            value: 'checkin',
                            label: Text('Check In'),
                          ),
                          ButtonSegment<Object?>(
                            value: 'checkout',
                            label: Text('Check Out'),
                          ),
                        ],
                        style: SegmentedButton.styleFrom(
                          backgroundColor: AppColors.white,
                          selectedBackgroundColor: AppColors.primary,
                          selectedForegroundColor: AppColors.background,
                        ),
                        selected: selectedSegment != null
                            ? {selectedSegment}
                            : {}, // Use the selected variable
                        emptySelectionAllowed: true, // Allow empty selection
                        onSelectionChanged: (Set<Object?> newSelection) {
                          setState(() {
                            selectedSegment = newSelection.isNotEmpty
                                ? newSelection.first as String?
                                : null; // Update the selected segment
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      // Conditionally show dropdowns for Check In
                      if (selectedSegment == 'checkin') ...[
                        // Dropdowns
                        _buildLocationDropdown(),
                        const SizedBox(height: 15),

                        if (selectedLocation != null) ...[
                          _buildCostCodeDropdown(),
                          const SizedBox(height: 15),
                          _buildWpsDropdown(),
                        ],
                      ],

                      const SizedBox(height: 30),

                      // Start Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(200, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          if (selectedSegment == 'checkin') {
                            // Validate all selections are made
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ScanEmployeeAttendanceScreen(
                                  checkIn: true,
                                  wps: selectedWps,
                                  costCode: selectedCostCode,
                                ),
                              ),
                            );
                          } else {
                            // Checkout flow
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ScanEmployeeAttendanceScreen(
                                  checkIn: false,
                                ),
                              ),
                            );
                          }
                        },
                        child: Text(
                          "Start ${selectedSegment == 'checkin' ? 'Check-In' : 'Check-Out'}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
