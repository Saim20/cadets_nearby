import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:readiew/services/user.dart';

class NearbyCard extends StatelessWidget {
  const NearbyCard({
    Key? key,
    required this.e,
    required this.isKm,
    required this.distance,
    required this.distanceInt,
  }) : super(key: key);

  final AppUser e;
  final bool isKm;
  final double distance;
  final int distanceInt;

  @override
  Widget build(BuildContext context) {
    String lastUpdate = e.timeStamp == null
        ? 'never'
        : (e.timeStamp!.day.toString() +
            '/' +
            e.timeStamp!.month.toString() +
            '/' +
            e.timeStamp!.year.toString());
    print(e.premium);
    print(e.celeb);
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CircleAvatar(
                  radius: 40.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: e.photoUrl! == ''
                        ? Image.asset('assets/images/user.png')
                        : Image.network(
                            e.photoUrl!,
                            width: 80,
                            height: 80,
                          ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Name: ' + e.fullName,
                        ),
                        if (e.premium)
                          Icon(
                            MdiIcons.crown,
                            size: 20,
                            color: Theme.of(context).accentColor,
                          ),
                        if (e.celeb)
                          Icon(Icons.star, size: 20, color: Colors.lightBlue),
                        if (!e.verified)
                          Icon(
                            Icons.dangerous,
                            size: 15,
                            color: Colors.redAccent,
                          ),
                      ],
                    ),
                    if (e.pLocation)
                      Text(
                        (isKm ? distance.toString() : distanceInt.toString()) +
                            (isKm ? 'km' : 'm'),
                      ),
                    if (!e.pLocation)
                      Icon(
                        Icons.visibility_off_rounded,
                        size: 17,
                      ),
                    Text('Last update: ' + lastUpdate),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
