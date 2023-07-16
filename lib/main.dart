import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_analyzer/cubit/spectrum.dart';
import 'package:wifi_analyzer/get_data.dart';

import 'graph_signal_strength.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SpectrumCubit(),
      child: MaterialApp(
        theme: ThemeData.light(useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        themeMode: ThemeMode.system,
        home: const Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<SpectrumCubit, Spectrum>(builder: (context, spec) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),
              Opacity(
                  opacity: spec == Spectrum.ghz2dot4 ? 1 : .5,
                  child: TextButton(
                    onPressed: context.read<SpectrumCubit>().to2dot4,
                    child: const Text("2.4GHz"),
                  )),
              const Spacer(),
              Opacity(
                  opacity: spec == Spectrum.ghz5 ? 1 : .5,
                  child: TextButton(
                    onPressed: context.read<SpectrumCubit>().to5,
                    child: const Text("5GHz"),
                  )),
              const Spacer(),
            ],
          );
        }),
        actions: [
          IconButton(
            onPressed: () => showAboutDialog(
              applicationName: "Wifi_analyzer",
              applicationVersion: "1.0.0",
              applicationLegalese: "MIT",
              context: context,
            ),
            icon: const Icon(Icons.info),
          )
        ],
      ),
      body: GetData(
          child: BlocBuilder<SpectrumCubit, Spectrum>(builder: (context, spec) {
        late int endShowFrequency;
        late int startShowFrequency;

        switch (spec) {
          case Spectrum.ghz2dot4:
            startShowFrequency = 2400;
            endShowFrequency = 2477;
            break;
          case Spectrum.ghz5:
            startShowFrequency = 5170;
            endShowFrequency = 5825;
            break;
        }

        return GraphSignalStrength(
          startShowFrequency: startShowFrequency,
          endShowFrequency: endShowFrequency,
        );
      })),
    );
  }
}
