import 'package:flutter/material.dart';
import 'package:volume_controller/volume_controller.dart';

class volumnSystem extends StatefulWidget {
  const volumnSystem({super.key});

  @override
  State<volumnSystem> createState() => _volumnSystemState();
}

class _volumnSystemState extends State<volumnSystem> {
  double _volumeListenerValue = 0;
  double _getVolume = 0;
  double _setVolumeValue = 0;

  @override
  void initState() {
    super.initState();
    // Listen to system volume change
    VolumeController().listener((volume) {
      setState(() => _volumeListenerValue = volume);
    });

    VolumeController().getVolume().then((volume) => _setVolumeValue = volume);
  }

  @override
  void dispose() {
    VolumeController().removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int currentVolumn = (_volumeListenerValue * 100).round();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Volume Plugin example app'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text('Current volume: $currentVolumn%'),
              Row(
                children: [
                  Text('Set Volume:'),
                  Flexible(
                    child: Slider(
                      min: 0,
                      max: 1,
                      onChanged: (double value) {
                        _setVolumeValue = value;
                        VolumeController().setVolume(_setVolumeValue);
                        setState(() {});
                      },
                      value: _setVolumeValue,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => VolumeController().muteVolume(),
                child: Text('Mute Volume'),
              ),
              TextButton(
                onPressed: () => VolumeController().maxVolume(),
                child: Text('Max Volume'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Show system UI:${VolumeController().showSystemUI}'),
                  TextButton(
                    onPressed: () => setState(() => VolumeController()
                        .showSystemUI = !VolumeController().showSystemUI),
                    child: Text('Show/Hide UI'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
