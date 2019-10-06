import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Join Us!',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          Text(
            '\nRegister for a mentoring major:\n\nMusic/Production',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
          Text(
            'sing, rap, beat maker, live sound, lighting, stage production.',
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            'Photography & Videography',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
          Text(
            'VLOGS, music videos, graphics, poster creation, artist photos, event photographers, social media team.',
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            'Events Leadership Team',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
          Text(
            'Youth led events team that creates events and runs them. Also in charge of Jam Cellar’s & Set The Tone.',
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            'Artist Development',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
          Text(
            'Learn the behind the scenes of the music industry, upskill in artist management, meet industry professionals to pathway into different careers.\n',
            style: TextStyle(fontSize: 16.0),
          ),

          InkWell(
            child: Text("Mentoring Enrollment and Induction Process Form",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.blue)),
            onTap: () {
              _launchURL('https://docs.google.com/forms/d/e/1FAIpQLSdOF88V32z6t4My4qSt0wDr7TTU52Fn0YacCjxZx4Fp5rxa1g/viewform');
            },
          ),
        ],
      ),
    );
  }

  _launchURL(String url) async {
//    const url = 'https://flutterhackathon.com/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
