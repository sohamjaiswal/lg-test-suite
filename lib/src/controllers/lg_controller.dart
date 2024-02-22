import 'package:flutter/material.dart';
import 'package:lg_tester/src/controllers/ssh_controller.dart';
import 'package:lg_tester/src/controllers/settings_controller.dart';
import 'package:lg_tester/src/helpers/kml_helper.dart';
import 'package:lg_tester/src/helpers/snackbar_helper.dart';

class LgController {
  final SshController sshController;
  final SettingsController settingsController;

  LgController({required this.sshController, required this.settingsController});

  Future<void> relaunchLg(BuildContext context) async {
    try {
      String res = await sshController.runCommand(
        'lg-relaunch',
      );
      sshController.close();
      showSnackBar(
          context: context, message: 'Rebooting LGs', color: Colors.green);
    } catch (e) {
      showSnackBar(context: context, message: e.toString(), color: Colors.red);
    }
  }

  Future<void> rebootLg(BuildContext context) async {
    try {
      for (var i = int.parse(settingsController.lgRigsNum!); i >= 1; i--) {
        try {
          await sshController.runCommand(
              'sshpass -p ${settingsController.lgPassword} ssh -t lg$i "echo ${settingsController.lgPassword} | sudo -S reboot"');
        } catch (e) {
          // ignore: avoid_print
          print(e);
        }
      }
      await sshController.close();
      showSnackBar(
          context: context, message: 'Rebooting LGs', color: Colors.green);
    } catch (e) {
      showSnackBar(context: context, message: e.toString(), color: Colors.red);
    }
  }

  Future<void> dispatchQuery(BuildContext context, String query) async {
    try {
      String res = await sshController.runCommand(
        "echo '$query' > /tmp/query.txt",
      );
      print(res);
      showSnackBar(
        context: context,
        message: 'Dispatching KML query',
        color: Colors.green,
      );
    } catch (e) {
      showSnackBar(
        context: context,
        message: e.toString(),
        color: Colors.red,
      );
    }
  }

  Future<void> setRefresh(BuildContext context) async {
    const search = '<href>##LG_PHPIFACE##kml\\/slave_{{slave}}.kml<\\/href>';
    const replace =
        '<href>##LG_PHPIFACE##kml\\/slave_{{slave}}.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';
    final command =
        'echo ${sshController.password} | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml';

    final clear =
        'echo ${sshController.password} | sudo -S sed -i "s/$replace/$search/" ~/earth/kml/slave/myplaces.kml';

    for (var i = 2; i <= int.parse(settingsController.lgRigsNum!); i++) {
      final clearCmd = clear.replaceAll('{{slave}}', i.toString());
      final cmd = command.replaceAll('{{slave}}', i.toString());
      String query =
          'sshpass -p ${sshController.password} ssh -t lg$i \'{{cmd}}\'';

      try {
        await sshController.runCommand(query.replaceAll('{{cmd}}', clearCmd));
        await sshController.runCommand(query.replaceAll('{{cmd}}', cmd));
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
    await rebootLg(context);
  }

  Future<void> clearSlaveKml(BuildContext context, int slaveNo) async {
    try {
      String res = await sshController.runCommand(
        "echo '${KmlHelper.getSlaveDefaultKml(slaveNo)}' > /var/www/html/kml/slave_$slaveNo.kml",
      );
      dispatchQuery(context, '');
      showSnackBar(
        context: context,
        message: 'Clearing KML on slave',
        color: Colors.green,
      );
    } catch (e) {
      showSnackBar(
        context: context,
        message: e.toString(),
        color: Colors.red,
      );
    }
  }

  Future<void> dispatchSlaveKml(
      BuildContext context, int slaveNo, String kml) async {
    String command = 'echo "$kml" > /var/www/html/kml/slave_$slaveNo.kml';
    try {
      String res = await sshController.runCommand(command);
      showSnackBar(
        context: context,
        message: 'Showing KML on slave',
        color: Colors.green,
      );
    } catch (e) {
      showSnackBar(
        context: context,
        message: e.toString(),
        color: Colors.red,
      );
    }
  }
}
