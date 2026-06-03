import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/service_request.dart';
import '../providers/service_provider.dart';
import '../widgets/gradient_button.dart';

class ServiceRequestScreen extends StatefulWidget {
  const ServiceRequestScreen({super.key});

  @override
  State<ServiceRequestScreen> createState() => _ServiceRequestScreenState();
}

class _ServiceRequestScreenState extends State<ServiceRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _detail = TextEditingController();
  ServiceType _type = ServiceType.repair;
  bool _submitting = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _detail.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    final request = ServiceRequest(
      customerName: _name.text.trim(),
      phone: _phone.text.trim(),
      type: _type,
      detail: _detail.text.trim(),
    );
    await context.read<ServiceProvider>().submit(request);
    if (!mounted) return;
    setState(() => _submitting = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Service request submitted. We\'ll call you back.')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request Service')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'Your name',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.length < 9) ? 'Enter a valid phone' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ServiceType>(
              value: _type,
              decoration: const InputDecoration(
                labelText: 'Service type',
                border: OutlineInputBorder(),
              ),
              items: [
                for (final t in ServiceType.values)
                  DropdownMenuItem(value: t, child: Text(t.label)),
              ],
              onChanged: (v) => setState(() => _type = v!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _detail,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Describe the issue',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 24),
            GradientButton(
              label: 'Submit Request',
              icon: Icons.send_rounded,
              loading: _submitting,
              onPressed: _submitting ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}
