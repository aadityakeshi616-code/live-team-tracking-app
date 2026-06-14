import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InviteTeamScreen extends StatelessWidget {

  final String teamCode;

  const InviteTeamScreen({
    super.key,
    required this.teamCode,
  });

  @override
  Widget build(BuildContext context) {

    String inviteMessage = '''
Hello Team 👋

Join our TrackTeam workspace using this Team Code:

$teamCode

Open the app and enter this code in Team Member Login.

Thanks.
''';

    return Scaffold(
      backgroundColor: const Color(0xffF4FFF6),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // TOP HEADER
              Row(

                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(18),
                    ),

                    child: const Icon(
                      Icons.groups_rounded,
                      color: Colors.green,
                      size: 30,
                    ),
                  ),

                  const SizedBox(width: 15),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Invite Team",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      SizedBox(height: 5),

                      Text(
                        "Share your workspace code",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      )
                    ],
                  )
                ],
              ),

              const SizedBox(height: 35),

              // TEAM CODE CARD
              Container(

                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xff16A34A),
                      Color(0xff22C55E),
                    ],
                  ),

                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),

                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.lock_person_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 22),

                    const Text(
                      "YOUR TEAM CODE",
                      style: TextStyle(
                        color: Colors.white70,
                        letterSpacing: 2,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      teamCode,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(30),
                      ),

                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified,
                            color: Colors.white,
                            size: 18,
                          ),

                          SizedBox(width: 8),
                          Text(
                            "Active Workspace",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 35),

              // INVITE MESSAGE CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [

                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),

                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(14),
                          ),

                          child: const Icon(
                            Icons.message_rounded,
                            color: Colors.green,
                          ),
                        ),

                        const SizedBox(width: 12),

                        const Text(
                          "Invitation Message",

                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xffF7F7F7),
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Text(
                        inviteMessage,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.8,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // COPY BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton.icon(

                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () async {
                          await Clipboard.setData(
                            ClipboardData(
                              text: inviteMessage,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Message Copied"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },

                        icon: const Icon(
                          Icons.copy_rounded,
                          color: Colors.white,
                        ),

                        label: const Text(
                          "Copy Invitation",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
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