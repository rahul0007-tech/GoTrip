import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../controllers/add_vehicle_controller.dart';

class AddVehiclePage extends GetView<AddVehicleController> {
  const AddVehiclePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Vehicle'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          // Changed from angle_left to arrowLeft
          icon: const Icon(LineAwesomeIcons.arrow_left_solid),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && 
            (controller.vehicleTypes.isEmpty || controller.fuelTypes.isEmpty)) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vehicle Information Title
                  const Text(
                    'Vehicle Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  // Vehicle Company
                  TextFormField(
                    controller: controller.vehicleCompanyController,
                    decoration: InputDecoration(
                      labelText: 'Vehicle Company',
                      // Changed from building to building_solid
                      prefixIcon: const Icon(LineAwesomeIcons.building_solid),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) => (value?.isEmpty ?? true) 
                        ? 'Please enter vehicle company' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  // Vehicle Color
                  TextFormField(
                    controller: controller.vehicleColorController,
                    decoration: InputDecoration(
                      labelText: 'Vehicle Color',
                      // Changed from paint_brush to paint_brush_solid
                      prefixIcon: const Icon(LineAwesomeIcons.paint_brush_solid),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) => (value?.isEmpty ?? true) 
                        ? 'Please enter vehicle color' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  // Vehicle Number
                  TextFormField(
                    controller: controller.vehicleNumberController,
                    decoration: InputDecoration(
                      labelText: 'Vehicle Number',
                      // Changed from car to car_solid
                      prefixIcon: const Icon(LineAwesomeIcons.car_solid),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) => (value?.isEmpty ?? true) 
                        ? 'Please enter vehicle number' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  // Seating Capacity
                  TextFormField(
                    controller: controller.sittingCapacityController,
                    decoration: InputDecoration(
                      labelText: 'Seating Capacity',
                      // Changed from user_friends to users_solid
                      prefixIcon: const Icon(LineAwesomeIcons.users_solid),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter seating capacity';
                      }
                      final capacity = int.tryParse(value);
                      if (capacity == null || capacity <= 0) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Vehicle Type Dropdown
                  Obx(() => DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: 'Vehicle Type',
                      // Changed from truck to truck_solid
                      prefixIcon: const Icon(LineAwesomeIcons.truck_solid),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: controller.vehicleTypes.map((type) {
                      return DropdownMenuItem<int>(
                        value: type.id,
                        child: Text(type.displayName),
                      );
                    }).toList(),
                    value: controller.selectedVehicleTypeId.value,
                    onChanged: (value) {
                      controller.selectedVehicleTypeId.value = value;
                    },
                    validator: (value) => value == null 
                        ? 'Please select vehicle type' : null,
                  )),
                  const SizedBox(height: 16),
                  
                  // Fuel Type Dropdown
                  Obx(() => DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: 'Fuel Type',
                      // Changed from gas_pump to gas_pump_solid
                      prefixIcon: const Icon(LineAwesomeIcons.gas_pump_solid),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: controller.fuelTypes.map((type) {
                      return DropdownMenuItem<int>(
                        value: type.id,
                        child: Text(type.displayName),
                      );
                    }).toList(),
                    value: controller.selectedFuelTypeId.value,
                    onChanged: (value) {
                      controller.selectedFuelTypeId.value = value;
                    },
                    validator: (value) => value == null 
                        ? 'Please select fuel type' : null,
                  )),
                  const SizedBox(height: 24),
                  
                  // Vehicle Images Section
                  const Text(
                    'Vehicle Images',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  
                  // Image picker button
                  ElevatedButton.icon(
                    onPressed: controller.pickImages,
                    // Changed from camera to camera_solid
                    icon: const Icon(LineAwesomeIcons.camera_solid),
                    label: const Text('Add Images'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Display selected images
                  Obx(() => controller.vehicleImages.isEmpty
                      ? const Center(
                          child: Text('No images selected'),
                        )
                      : SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.vehicleImages.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: FileImage(controller.vehicleImages[index]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () => controller.removeImage(index),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Error message
                  Obx(() => controller.errorMessage.isNotEmpty
                      ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            controller.errorMessage.value,
                            style: TextStyle(color: Colors.red.shade800),
                          ),
                        )
                      : const SizedBox(),
                  ),
                  
                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: Obx(() => ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.submitVehicle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Add Vehicle',
                              style: TextStyle(fontSize: 16),
                            ),
                    )),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}