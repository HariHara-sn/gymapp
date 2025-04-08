import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymapp/Screens/widgets/qr_preview.dart';
import 'package:gymapp/Utils/custom_snack_bar.dart';
import 'package:gymapp/main.dart';
import '../../Theme/appcolor.dart' show AppColors;
import 'package:uuid/uuid.dart';
import 'package:gymapp/Screens/Dashboard/cubit/dashboard_cubit.dart';
import 'package:gymapp/Screens/Dashboard/model/dashboard_model.dart';
import 'package:gymapp/Screens/Dashboard/widget/section_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<ExerciseModel> exercises = [];
  final List<NoticeModel> notices = [];
  late PaymentModel payment;

  final List<TextEditingController> exerciseTitleControllers = [];
  final List<TextEditingController> exerciseDescControllers = [];
  final List<TextEditingController> noticeTitleControllers = [];
  final List<TextEditingController> noticeDescControllers = [];

  @override
  void initState() {
    super.initState();
    payment = PaymentModel(
      id: Uuid().v4(),
      upiId: '',
      amount: '0',
      createdAt: DateTime.now(),
    );
    context.read<DashboardCubit>().fetchPaymentDetails();

    // Initialize with one empty exercise and notice
    _addNewExercise();
    _addNewNotice();
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in exerciseTitleControllers) {
      controller.dispose();
    }
    for (var controller in exerciseDescControllers) {
      controller.dispose();
    }
    for (var controller in noticeTitleControllers) {
      controller.dispose();
    }
    for (var controller in noticeDescControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addNewExercise() {
    exerciseTitleControllers.add(TextEditingController());
    exerciseDescControllers.add(TextEditingController());
    exercises.add(
      ExerciseModel(
        id: Uuid().v4(),
        title: '',
        description: '',
        createdAt: DateTime.now(),
      ),
    );
  }

  void _addNewNotice() {
    noticeTitleControllers.add(TextEditingController());
    noticeDescControllers.add(TextEditingController());
    notices.add(
      NoticeModel(
        id: Uuid().v4(),
        title: '',
        description: '',
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {
        if (state is DashboardLoaded) {
          if (!mounted) return;

          setState(() {
            payment = state.payment;
          });
        } else if (state is DashboardError) {
          CustomSnackBar.showSnackBar(state.message, SnackBarType.failure);
          logger.e(state.message);
        } else if (state is DashboardSaved) {
          CustomSnackBar.showSnackBar(
            'Data saved successfully!',
            SnackBarType.success,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Gym Dashboard')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Exercise of the Day section
                SectionWidget(
                  title: 'Exercise of the Day',
                  items: List.generate(exercises.length, (index) {
                    return {
                      'exercise_title': exerciseTitleControllers[index],
                      'exercise_desc': exerciseDescControllers[index],
                    };
                  }),
                  type: 'exercise',
                  onAdd: () {
                    if (!mounted) return;

                    setState(() {
                      _addNewExercise();
                    });
                  },
                  onDelete: (index) {
                    if (!mounted) return;

                    setState(() {
                      exercises.removeAt(index);
                      exerciseTitleControllers.removeAt(index).dispose();
                      exerciseDescControllers.removeAt(index).dispose();
                    });
                  },
                  onChanged: (index, title, description) {
                    exercises[index] = ExerciseModel(
                      id: exercises[index].id,
                      title: title,
                      description: description,
                      createdAt: exercises[index].createdAt,
                    );
                  },
                ),

                const Divider(height: 40),

                // Gym Notices section
                SectionWidget(
                  title: 'Gym Notices',
                  items: List.generate(notices.length, (index) {
                    return {
                      'notice_title': noticeTitleControllers[index],
                      'notice_desc': noticeDescControllers[index],
                    };
                  }),
                  type: 'notice',
                  onAdd: () {
                    if (!mounted) return;
                    setState(() {
                      _addNewNotice();
                    });
                  },
                  onDelete: (index) {
                    if (!mounted) return;

                    setState(() {
                      notices.removeAt(index);
                      noticeTitleControllers.removeAt(index).dispose();
                      noticeDescControllers.removeAt(index).dispose();
                    });
                  },
                  onChanged: (index, title, description) {
                    notices[index] = NoticeModel(
                      id: notices[index].id,
                      title: title,
                      description: description,
                      createdAt: notices[index].createdAt,
                    );
                  },
                ),

                const Divider(height: 40),

                // Gym QR Code section
                Text(
                  'Gym QR Code',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.greenAccent,
                  ),
                ),

                QrPreviewWidget(
                  qrReference: payment.qrData,
                  upiId: payment.upiId,
                  amount: payment.amount.toString(),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: OutlinedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.15,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => _showQRUpdateBottomSheet(context),
                      icon: Icon(Icons.qr_code, color: AppColors.greenAccent),
                      label: Text(
                        'Generate New QR',
                        style: TextStyle(color: AppColors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed:
                          state is DashboardSaving
                              ? null
                              : () async {
                                // Update all models with current text field values
                                for (int i = 0; i < exercises.length; i++) {
                                  exercises[i] = ExerciseModel(
                                    id: exercises[i].id,
                                    title: exerciseTitleControllers[i].text,
                                    description:
                                        exerciseDescControllers[i].text,
                                    createdAt: exercises[i].createdAt,
                                  );
                                }
                                for (int i = 0; i < notices.length; i++) {
                                  notices[i] = NoticeModel(
                                    id: notices[i].id,
                                    title: noticeTitleControllers[i].text,
                                    description: noticeDescControllers[i].text,
                                    createdAt: notices[i].createdAt,
                                  );
                                }

                                final cubit = context.read<DashboardCubit>();
                                logger.i(
                                  exercises
                                      .map((e) => e.toJson())
                                      .toList()
                                      .toString(),
                                );

                                final exercisesToSave =
                                    exercises
                                        .where(
                                          (e) =>
                                              e.title.trim().isNotEmpty ||
                                              e.description.trim().isNotEmpty,
                                        )
                                        .toList();
                                final noticesToSave =
                                    notices
                                        .where(
                                          (n) =>
                                              n.title.trim().isNotEmpty ||
                                              n.description.trim().isNotEmpty,
                                        )
                                        .toList();
                                logger.i(exercisesToSave.isNotEmpty);
                                if (exercisesToSave.isNotEmpty) {
                                  await cubit.saveExercises(exercisesToSave);
                                }

                                if (noticesToSave.isNotEmpty) {
                                  await cubit.saveNotices(noticesToSave);
                                }

                                if (exercisesToSave.isEmpty &&
                                    noticesToSave.isEmpty) {
                                  CustomSnackBar.showSnackBar(
                                    'No valid data to save',
                                    SnackBarType.failure,
                                  );
                                }
                              },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        backgroundColor: AppColors.greenAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child:
                          state is DashboardSaving
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : Text(
                                "Save Data",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showQRUpdateBottomSheet(BuildContext context) {
    TextEditingController upiController = TextEditingController(
      text: payment.upiId,
    );
    TextEditingController amountController = TextEditingController(
      text: payment.amount.toString(),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: upiController,
                decoration: const InputDecoration(labelText: 'UPI ID'),
              ),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<DashboardCubit>().updatePayment(
                    PaymentModel(
                      id: payment.id,
                      upiId: upiController.text,
                      amount: amountController.text,
                      createdAt: payment.createdAt,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Update'),
              ),
            ],
          ),
        );
      },
    );
  }
}