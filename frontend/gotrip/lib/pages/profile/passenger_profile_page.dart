import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotrip/controllers/passenger_profile_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PassengerProfilePage extends GetView<PassengerProfileController> {
  const PassengerProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Implement edit profile functionality
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Text(
              controller.error.value,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final passenger = controller.passenger.value;
        if (passenger == null) {
          return const Center(child: Text('No profile data available'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: passenger.photo != null
                      ? CachedNetworkImage(
                          imageUrl: passenger.photo!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Image.asset(
                            'asset/images/profile_placeholder.png',
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          'asset/images/profile_placeholder.png',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: 20),
              _buildInfoCard(
                context,
                [
                  _buildInfoRow('Name', passenger.name),
                  _buildInfoRow('Email', passenger.email),
                  _buildInfoRow('Phone', passenger.phone.toString()),
                  _buildInfoRow('Member Since', 
                    '${passenger.createdAt.day}/${passenger.createdAt.month}/${passenger.createdAt.year}'),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoCard(BuildContext context, List<Widget> children) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}