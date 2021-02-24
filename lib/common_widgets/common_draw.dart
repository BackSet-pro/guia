import 'package:flutter/material.dart';
import 'package:guia_entrenamiento/app/home/aerobic_activity/continuous_run/for_km/for_km_page.dart';
import 'package:guia_entrenamiento/app/home/aerobic_activity/continuous_run/for_time/for_time_page.dart';
import 'package:guia_entrenamiento/app/home/aerobic_activity/interval/fartlek/fartlek_page.dart';
import 'package:guia_entrenamiento/app/home/aerobic_activity/interval/repetitions/repetitions_page.dart';
import 'package:guia_entrenamiento/app/home/aerobic_activity/interval/stair/stair_page.dart';
import 'package:guia_entrenamiento/app/home/anaerobic_activity/race/race_page.dart';
import 'package:guia_entrenamiento/app/home/anaerobic_activity/swimming/swimming_page.dart';
import 'package:guia_entrenamiento/app/home/brigade/brigade_page.dart';
import 'package:guia_entrenamiento/app/home/military_skill/military_skill_page.dart';
import 'package:guia_entrenamiento/app/home/recreational_activity/recreacional_activity_page.dart';
import 'package:guia_entrenamiento/app/home/strength/principal/croossfit/crossfit_page.dart';
import 'package:guia_entrenamiento/app/home/strength/principal/personalized/personalized_page.dart';
import 'package:guia_entrenamiento/app/home/strength/stretching/stretching_page.dart';
import 'package:guia_entrenamiento/app/home/strength/warm_up/warm_up_page.dart';

class CommonDraw extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Text(
              'Guía digital de AFM',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Brigade'.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.00),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => BrigadePage()),
              );
            },
          ),
          ExpansionTile(
            title: Text(
              'FUERZA'.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.00),
            ),
            children: [
              ListTile(
                title: Text('Calentamiento'.toUpperCase()),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => WarmUpPage()),
                  );
                },
              ),
              ExpansionTile(
                title: Text('Principal'.toUpperCase()),
                children: [
                  ListTile(
                    title: Text('Personalizada'.toUpperCase()),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PersonalizedPage()),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Crossfit'.toUpperCase()),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => CrossfitPage()),
                      );
                    },
                  ),
                ],
              ),
              ListTile(
                // leading: Icon(Icons.source),
                title: Text('Estiramiento'.toUpperCase()),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => StretchingPage()),
                  );
                },
              ),
            ],
          ),
          ExpansionTile(
            title: Text(
              'ACT. AEROBICA'.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.00),
            ),
            children: [
              ExpansionTile(
                title: Text('Carrera Continua'.toUpperCase()),
                children: [
                  ListTile(
                    title: Text('Por Tiempo'.toUpperCase()),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ForTimePage()),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Por KM'.toUpperCase()),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ForKmPage()),
                      );
                    },
                  ),
                ],
              ),
              ListTile(
                title: Text('Fartlek'.toUpperCase()),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => FartlekPage()),
                  );
                },
              ),
              ExpansionTile(
                title: Text('Invervalo'.toUpperCase()),
                children: [
                  ListTile(
                    title: Text('Repeticiones'.toUpperCase()),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RepetitionsPage()),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Escaleras'.toUpperCase()),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => StairPage()),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
          ListTile(
            title: Text(
              'DESTREZAS MILITARES'.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.00),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MilitarySkillPage()),
              );
            },
          ),
          ExpansionTile(
            title: Text(
              'ACT. ANAERÓBICA'.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.00),
            ),
            children: [
              ListTile(
                title: Text('Carrera'.toUpperCase()),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RacePage()),
                  );
                },
              ),
              ListTile(
                title: Text('Natación'.toUpperCase()),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SwimmingPage()),
                  );
                },
              ),
            ],
          ),
          ListTile(
            title: Text(
              'ACT. FÍSICA RECREATIVA'.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.00),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => RecreationalActivityPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
