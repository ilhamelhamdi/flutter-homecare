import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/cubit/nursing/presentation/bloc/nursing_case/nursing_case_bloc.dart';
import 'package:m2health/cubit/nursing/presentation/widgets/nursing_case_form.dart';

class NursingCaseFormPage extends StatelessWidget {
  const NursingCaseFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Nursing Case'),
      ),
      body: BlocProvider(
        create: (context) => NursingCaseBloc(
          getNursingCases: context.read(),
          createNursingCase: context.read(),
        ),
        child: const NursingCaseForm(),
      ),
    );
  }
}
