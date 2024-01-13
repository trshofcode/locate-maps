import 'package:firebase_auth/firebase_auth.dart';
import 'package:pickme/models/user.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentUser;

UserModel? userModelCurrentInfo;
