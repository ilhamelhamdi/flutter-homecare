import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/app_localzations.dart';
import 'package:m2health/cubit/nursing/presentation/bloc/nursing_services/nursing_services_bloc.dart';
import 'package:m2health/cubit/nursing/presentation/bloc/nursing_services/nursing_services_event.dart';
import 'package:m2health/cubit/nursing/presentation/bloc/nursing_services/nursing_services_state.dart';
import 'package:m2health/cubit/nursing/presentation/pages/nursing_case_form_page.dart';
import 'package:m2health/cubit/nursing/presentation/widgets/nursing_service_card.dart';

class NursingServicesPage extends StatelessWidget {
  const NursingServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          NursingServicesBloc(getNursingServices: context.read())
            ..add(GetNursingServicesEvent()),
      child: const NursingServicesView(),
    );
  }
}

class NursingServicesView extends StatelessWidget {
  const NursingServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('nursing'),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: BlocBuilder<NursingServicesBloc, NursingServicesState>(
        builder: (context, state) {
          if (state is NursingServicesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NursingServicesLoaded) {
            return ListView.builder(
              itemCount: state.nursingServices.length,
              itemBuilder: (context, index) {
                final service = state.nursingServices[index];
                return NursingServiceCard(
                  service: service,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NursingCaseFormPage(),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is NursingServicesError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
