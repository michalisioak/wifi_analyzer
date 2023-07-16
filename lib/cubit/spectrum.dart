import 'package:flutter_bloc/flutter_bloc.dart';

enum Spectrum { ghz2dot4, ghz5 }

class SpectrumCubit extends Cubit<Spectrum> {
  SpectrumCubit() : super(Spectrum.ghz2dot4);

  void change(Spectrum spectrum) => emit(spectrum);
  void to2dot4() => emit(Spectrum.ghz2dot4);
  void to5() => emit(Spectrum.ghz5);
}
