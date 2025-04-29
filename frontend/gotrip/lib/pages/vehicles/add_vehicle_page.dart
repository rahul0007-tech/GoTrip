

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../controllers/add_vehicle_controller.dart';

class AddVehiclePage extends GetView<AddVehicleController> {
  const AddVehiclePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal.shade700,
        title: const Text(
          'Add Your Vehicle',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(LineAwesomeIcons.arrow_left_solid),
          onPressed: () => Get.back(),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && 
            (controller.vehicleTypes.isEmpty || controller.fuelTypes.isEmpty)) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Colors.teal.shade700,
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading vehicle information...',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }
        
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vehicle Images Section at the top
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Vehicle Photos',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal.shade800,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: controller.pickImages,
                              icon: const Icon(LineAwesomeIcons.camera_solid, size: 18),
                              label: const Text('Add Images'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal.shade600,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                textStyle: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Display selected images
                        Obx(() => controller.vehicleImages.isEmpty
                            ? Container(
                                height: 160,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.shade300, width: 1),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      LineAwesomeIcons.car_side_solid,
                                      size: 50,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Add photos of your vehicle',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Photos help passengers identify your vehicle',
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                height: 160,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListView.builder(
                                  padding: const EdgeInsets.all(8),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.vehicleImages.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 12.0),
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: 140,
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image: FileImage(controller.vehicleImages[index]),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: GestureDetector(
                                              onTap: () => controller.removeImage(index),
                                              child: Container(
                                                padding: const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: Colors.black.withOpacity(0.7),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 16,
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
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Vehicle Details Container
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vehicle Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade800,
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Vehicle Company and Color in one row
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: controller.vehicleCompanyController,
                                label: 'Company',
                                icon: LineAwesomeIcons.building,
                                validator: (value) => (value?.isEmpty ?? true) 
                                    ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField(
                                controller: controller.vehicleColorController,
                                label: 'Color',
                                icon: LineAwesomeIcons.paint_brush_solid,
                                validator: (value) => (value?.isEmpty ?? true) 
                                    ? 'Required' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Vehicle Number
                        _buildTextField(
                          controller: controller.vehicleNumberController,
                          label: 'Vehicle Number',
                          icon: LineAwesomeIcons.car_alt_solid,
                          hint: 'e.g. KA01AB1234',
                          validator: (value) => (value?.isEmpty ?? true) 
                              ? 'Please enter vehicle number' : null,
                        ),
                        const SizedBox(height: 16),
                        
                        // Vehicle Type and Fuel Type in one row
                        Row(
                          children: [
                            Expanded(
                              child: Obx(() => _buildDropdown(
                                label: 'Vehicle Type',
                                icon: LineAwesomeIcons.car_side_solid,
                                value: controller.selectedVehicleTypeId.value,
                                items: controller.vehicleTypes.map((type) {
                                  return DropdownMenuItem<int>(
                                    value: type.id,
                                    child: Text(type.displayName),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  controller.selectedVehicleTypeId.value = value;
                                },
                                validator: (value) => value == null 
                                    ? 'Required' : null,
                              )),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Obx(() => _buildDropdown(
                                label: 'Fuel Type',
                                icon: LineAwesomeIcons.gas_pump_solid,
                                value: controller.selectedFuelTypeId.value,
                                items: controller.fuelTypes.map((type) {
                                  return DropdownMenuItem<int>(
                                    value: type.id,
                                    child: Text(type.displayName),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  controller.selectedFuelTypeId.value = value;
                                },
                                validator: (value) => value == null 
                                    ? 'Required' : null,
                              )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Seating Capacity
                        _buildTextField(
                          controller: controller.sittingCapacityController,
                          label: 'Seating Capacity',
                          icon: LineAwesomeIcons.users_solid,
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
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Error message
                  Obx(() => controller.errorMessage.isNotEmpty
                      ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                LineAwesomeIcons.exclamation_circle_solid,
                                color: Colors.red.shade700,
                                size: 18,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  controller.errorMessage.value,
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Submit button
                  Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.submitVehicle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade700,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.teal.shade300,
                      elevation: 0,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                LineAwesomeIcons.check_circle,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Add Vehicle',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  )),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
  
  // Helper method for text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String label, 
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? hint,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(icon, size: 20, color: Colors.teal.shade700),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal.shade700, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade300),
        ),
        errorStyle: TextStyle(
          color: Colors.red.shade700,
          fontSize: 12,
        ),
      ),
      validator: validator,
    );
  }
  
  // Helper method for dropdown fields
  Widget _buildDropdown<T>({
    required String label,
    required IconData icon,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?)? onChanged,
    required String? Function(T?)? validator,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(icon, size: 20, color: Colors.teal.shade700),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal.shade700, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade300),
        ),
        errorStyle: TextStyle(
          color: Colors.red.shade700,
          fontSize: 12,
        ),
      ),
      icon: Icon(LineAwesomeIcons.angle_down_solid, size: 16),
      isExpanded: true,
      dropdownColor: Colors.white,
    );
  }
}