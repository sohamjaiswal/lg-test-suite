import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lg_tester/src/constants/values.dart';
import 'package:lg_tester/src/controllers/lg_controller.dart';
import 'package:lg_tester/src/controllers/ssh_controller.dart';
import 'package:lg_tester/src/controllers/settings_controller.dart';
import 'package:lg_tester/src/helpers/kml_helper.dart';
import 'package:lg_tester/src/screens/settings/settings_view.dart';

class LgHome extends StatelessWidget {
  const LgHome(
      {super.key,
      required this.settings,
      required this.sshController,
      required this.lgController});
  final SshController sshController;
  final SettingsController settings;
  final LgController lgController;
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LG Test Suite"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 200,
                child: Image(
                  image: AssetImage('assets/images/lool.png'),
                ),
              ),
              ElevatedButton(
                onPressed: (sshController.client != null)
                    ? () async {
                        try {
                          await sshController.ping();
                          String res = await sshController.runCommand('uptime');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Ping successful: $res'),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to ping'),
                            ),
                          );
                        }
                      }
                    : null,
                child: const Text("Test SSH"),
              ),
              ElevatedButton(
                onPressed: (sshController.client != null)
                    ? () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Restart Liquid Galaxy"),
                            content: const Text(
                                "Are you sure you want to restart Liquid Galaxy?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Restarting Liquid Galaxy'),
                                    ),
                                  );
                                  lgController.rebootLg(context);
                                },
                                child: const Text("Restart"),
                              ),
                            ],
                          ),
                        );
                      }
                    : null,
                child: const Text("Restart Liquid Galaxy"),
              ),
              ElevatedButton(
                onPressed: (sshController.client != null)
                    ? () async {
                        try {
                          await lgController.dispatchQuery(
                            context,
                            'flytoview=${KmlHelper.lookAtLinear(30.733366, 76.779768, ConstantValues.tourZoomScale * 50, 0, 0)}',
                          );
                          for (double i = 0; i <= 180; i += 17) {
                            await lgController.dispatchQuery(context,
                                'flytoview=${KmlHelper.orbitLookAtLinear(30.733366, 76.779768, ConstantValues.tourZoomScale * 50, 0, i)}');
                            await Future.delayed(
                                const Duration(milliseconds: 1000));
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to dispatch KML query'),
                            ),
                          );
                        }
                      }
                    : null,
                child: const Text("Show Dev (Soham) Location"),
              ),
              ElevatedButton(
                onPressed: (sshController.client != null)
                    ? () async {
                        print(settings.lgRigsNum);
                        try {
                          await lgController.dispatchSlaveKml(
                            context,
                            int.parse(settings.lgRigsNum!) - 1,
                            KmlHelper.screenOverlayImage(
                              "https://i.imgur.com/0rCWmFO.png",
                              9 / 16,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to dispatch KML query'),
                            ),
                          );
                        }
                      }
                    : null,
                child: const Text("Show Dev Bubble"),
              ),
              ElevatedButton(
                onPressed: (sshController.client != null)
                    ? () {
                        print(settings.lgRigsNum);
                        try {
                          lgController.clearSlaveKml(
                              context, int.parse(settings.lgRigsNum!) - 1);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to dispatch KML query'),
                            ),
                          );
                        }
                      }
                    : null,
                child: const Text("Clear Right Slave"),
              ),
              ElevatedButton(
                onPressed: (sshController.client != null)
                    ? () {
                        print(settings.lgRigsNum);
                        try {
                          lgController.clearSlaveKml(
                              context, int.parse(settings.lgRigsNum!));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to dispatch KML query'),
                            ),
                          );
                        }
                      }
                    : null,
                child: const Text("Clear Left Slave"),
              ),
              ElevatedButton(
                onPressed: (sshController.client != null)
                    ? () async {
                        try {
                          await lgController.setRefresh(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Refreshing LGs'),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to dispatch KML query'),
                            ),
                          );
                        }
                      }
                    : null,
                child: const Text("Set Slave Refresh"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
