import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xlapparals_app/core/routes/route_name.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/features/agent/orders/customers/presentation/blocs/customer_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/customers/presentation/blocs/customer_event.dart';
import 'package:xlapparals_app/features/agent/orders/customers/presentation/blocs/customer_state.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/transport.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/blocs/agent_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/blocs/agent_event.dart';

class AddCustomerPage extends StatefulWidget {
  const AddCustomerPage({super.key});

  @override
  State<AddCustomerPage> createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactController = TextEditingController();
  final _gstController = TextEditingController();

  Transport? _selectedTransport;

  @override
  void initState() {
    super.initState();
    context.read<CustomerBloc>().add(FetchTransports());
    context.read<AgentBloc>().add(LoadAgent());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    _gstController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final agentState = context.read<AgentBloc>().state;
      if (agentState.agent == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Agent data not loaded yet.')),
        );
        return;
      }

      final data = {
        "name": _nameController.text.trim(),
        "address": _addressController.text.trim(),
        "contact": _contactController.text.trim(),
        "gst": _gstController.text.trim(),
        "agent": agentState.agent!.id,
        "preferred_transport": _selectedTransport?.id,
      };

      context.read<CustomerBloc>().add(CreateCustomer(data));
    }
  }

  void _showSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.secondary,
          title: const Text('Success'),
          content: const Text('Customer created successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                context.go(
                  RouteNames.agentOrderCustomers,
                ); // Go back to customer list
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Customer'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(RouteNames.agentOrderCustomers),
        ),
      ),
      body: BlocConsumer<CustomerBloc, CustomerState>(
        listenWhen: (previous, current) =>
            previous.isCreating != current.isCreating,
        listener: (context, state) {
          if (!state.isCreating && state.createSuccess) {
            _showSuccessPopup();
          } else if (!state.isCreating && state.createError != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.createError!)));
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _contactController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Contact',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _gstController,
                    decoration: InputDecoration(
                      labelText: 'GST',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (state.isLoadingTransports)
                    const Center(child: CircularProgressIndicator())
                  else
                    DropdownButtonFormField<Transport>(
                      initialValue: _selectedTransport,
                      decoration: InputDecoration(
                        labelText: 'Preferred Transport',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                      ),
                      items: state.transports.map((transport) {
                        return DropdownMenuItem(
                          value: transport,
                          child: Text(transport.name),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedTransport = val;
                        });
                      },
                      validator: (value) => value == null ? 'Required' : null,
                    ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: state.isCreating ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: state.isCreating
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'CREATE CUSTOMER',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
